#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    my $num_tests := 18;
    Q:PIR {
        .local pmc c
        load_language 'parrot'
        c = compreg 'parrot'
        c.'import'('Test::More')
    };
    plan(2);
    ok(1, "Test harness works");

    load_linalg_group();
}

sub load_linalg_group() {
    Q:PIR {
        .local pmc pds
        pds = loadlib "./dynext/pds_group"
        if pds goto has_pds_group
        ok(0, "loading pds_group failed")
        goto _end
     has_pds_group:
        ok(1, "has pds_group library available")
     _end:
    }
}
