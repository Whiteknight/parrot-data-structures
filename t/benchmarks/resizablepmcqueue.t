#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(1);

    load_linalg_group();
    RPQ_push_shift_10000_items();
    RPA_push_shift_10000_items();
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

sub RPQ_push_shift_10000_items() {
    Q:PIR {
        $P0 = new ['ResizablePMCQueue']
        $P1 = new ['Integer']
        $P1 = 5
        $I0 = 10000
        $N0 = time
      push_loop_top:
        push $P0, $P1
        $I0 = $I0 - 1
        if $I0 == 0 goto push_loop_bottom
        goto push_loop_top
      push_loop_bottom:
        $N1 = time
        $I0 = 10000
      shift_loop_top:
        $P2 = shift $P0
        $I0 = $I0 - 1
        if $I0 == 0 goto shift_loop_bottom
        goto shift_loop_top
      shift_loop_bottom:
        $N2 = time
        $N3 = $N1 - $N0
        $N4 = $N2 - $N1
        $N5 = $N2 - $N0
        print "(RPQ) Time for 10000 pushes: "
        say $N3
        print "(RPQ) Time for 10000 shifts: "
        say $N4
        print "(RPQ) Total time: "
        say $N5
    }
}

sub RPA_push_shift_10000_items() {
    Q:PIR {
        $P0 = new ['ResizablePMCArray']
        $P1 = new ['Integer']
        $P1 = 5
        $I0 = 10000
        $N0 = time
      push_loop_top:
        push $P0, $P1
        $I0 = $I0 - 1
        if $I0 == 0 goto push_loop_bottom
        goto push_loop_top
      push_loop_bottom:
        $N1 = time
        $I0 = 10000
      shift_loop_top:
        $P2 = shift $P0
        $I0 = $I0 - 1
        if $I0 == 0 goto shift_loop_bottom
        goto shift_loop_top
      shift_loop_bottom:
        $N2 = time
        $N3 = $N1 - $N0
        $N4 = $N2 - $N1
        $N5 = $N2 - $N0
        print "(RPA) Time for 10000 pushes: "
        say $N3
        print "(RPA) Time for 10000 shifts: "
        say $N4
        print "(RPA) Total time: "
        say $N5
    }
}

