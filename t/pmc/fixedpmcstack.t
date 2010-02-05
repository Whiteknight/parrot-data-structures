#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(0);

    load_linalg_group();
}

sub load_test_more() {
    Q:PIR {
        .local pmc c
        load_language 'parrot'
        c = compreg 'parrot'
        c.'import'('Test::More')
    };
}

sub load_linalg_group() {
    Q:PIR {
        .local pmc pds
        pds = loadlib "./dynext/pds_group"
        if pds goto has_pds_group
        exit 1
     has_pds_group:
    };
}

