#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(16);

    load_linalg_group();
    create_resizablepmcqueue();
    op_does();
    vtable_push_pmc();
    vtable_shift_pmc();
    vtable_elements();
    vtable_get_bool();
    method_to_array();
    method_total_mem_size();
    method_clear();
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
        $I0 = isnull $P0
        $I0 = not $I0
        ok($I0)
        $S0 = typeof $P0
        is($S0, "ResizablePMCQueue")
    }
}

sub op_does() {
    Q:PIR {
        $P0 = new ['ResizablePMCQueue']
        $I0 = does $P0, "queue"
        ok($I0)
        $I0 = does $P0, "jibbajabba"
        not $I0
        ok($I0)
    }
}

sub vtable_push_pmc() {
    Q:PIR {
        push_eh push_sanity_handler
        $P0 = new ['ResizablePMCQueue']
        $P1 = box 1
        push $P0, $P1
        ok(1, "can push")
        goto push_end
      push_sanity_handler:
        .get_results($P0)
        $S0 = $P0["message"]
        ok(0, $S0)
      push_end:
    }
}

sub vtable_shift_pmc() {
    Q:PIR {
        push_eh shift_sanity_handler
        $P0 = new ['ResizablePMCQueue']
        $P1 = box 42
        push $P0, $P1
        $P2 = shift $P0
        ok(1, "can shift")
        goto shift_sanity_end
      shift_sanity_handler:
        ok(0, "cannot shift");
      shift_sanity_end:
        pop_eh
        is($P1, $P2)

      push_eh shift_empty_handler
        $P0 = new ['ResizablePMCQueue']
        $P1 = shift $P0
        ok(0, "shifted empty queue")
        goto shift_empty_end
      shift_empty_handler:
        ok(1, "cannot shift empty queue")
      shift_empty_end:
    }
}

sub vtable_elements() {
    Q:PIR {
        $P0 = new ['ResizablePMCQueue']
        $I0 = elements $P0
        is($I0, 0)

        $P1 = box 1
        push $P0, $P1
        $I0 = elements $P0
        is($I0, 1)

        $P2 = shift $P0
        $I0 = elements $P0
        is($I0, 0)
    }
}

sub vtable_get_bool() {
    Q:PIR {
        # TODO: This!
    }
}

sub method_to_array() {
    Q:PIR {
        $P0 = new ['ResizablePMCQueue']
        $P1 = box 1
        push $P0, $P1
        $P2 = box 2
        push $P0, $P2
        $P3 = box 42
        push $P0, $P3

        $P4 = $P0.'to_array'()
        $I0 = elements $P4
        is($I0, 3)

        $S0 = typeof $P4
        is($S0, "ResizablePMCArray")

        $P5 = $P4[0]
        is($P5, $P1)
        $P6 = $P4[1]
        is($P6, $P2)
        $P7 = $P4[2]
        is($P7, $P3)
    }
}

sub method_total_mem_size() {
    Q:PIR {
        # TODO: This!
    }
}

sub method_clear() {
    Q:PIR {
        # TODO: This!
    }
}


