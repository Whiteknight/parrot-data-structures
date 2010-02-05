#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(2);

    load_linalg_group();
    create_resizablepmcqueue();
    op_does();
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

sub create_resizablepmcqueue() {
    Q:PIR {
        $P0 = new ['ResizablePMCQueue']
        $I0 = null $P0
        $I0 = not $I0
        ok($I0)
        $S0 = typeof $P0
        is($S0, "ResizablePMCQueue")
    }
}

sub op_does() {
    Q:PIR {
        $P0 = new ['ResizablePMCQueue']
        $I0 = does "queue"
        ok($I0)
        $I0 = does "jibbajabba"
        not $I0
        ok($I0)
    }
}
