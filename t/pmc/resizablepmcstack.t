#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(1);
    ok(11);

    load_pds_group();
    op_new();
    op_does();
    op_typeof();
    vtable_push_pmc();
    vtable_pop_pmc();
    vtable_elements();
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

sub load_pds_group() {
    Q:PIR {
        .local pmc pds
        pds = loadlib "./dynext/pds_group"
        if pds goto has_pds_group
        exit 1
     has_pds_group:
    };
}

sub op_new() {
    Q:PIR {
        push_eh op_new_sanity_error
        $P0 = new ['ResizablePMCStack']
        ok(1)
        goto op_new_sanity_end
      op_new_sanity_error:
        ok(0)
      op_new_sanity_end:
        pop_eh

        $I0 = isnull $P0
        is($I0, 0)
    }
}

sub op_does() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack']
        $I0 = does $P0, "stack"
        is($I0, 1)
        $I0 = does $P0, "jibbajabba"
        is($I0, 0)
    }
}

sub op_typeof() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack']
        $S0 = typeof $P0
        is($S0, 'ResizablePMCStack')
    }
}

sub vtable_push_pmc() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack']
        $P1 = box 1
        push_eh push_pmc_sanity_error
        push $P0, $P1
        ok(1)
        goto push_pmc_sanity_end
      push_pmc_sanity_error:
        ok(0)
      push_pmc_sanity_end:
        pop_eh
    }
}

sub vtable_pop_pmc() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack']
        $P1 = box 1
        push $P0, $P1
        $P2 = pop $P0
        is($P1, $P2)
    }
}

sub vtable_elements() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack']
        $I0 = elements $P0
        is($I0, 0)

        $P1 = box 1
        push $P0, $P1
        $I0 = elements $P0
        is($I0, 1)

        $P2 = pop $P0
        $I0 = elements $P0
        is($I0, 0)
    }
}

sub method_to_array() {
    Q:PIR {
        # TODO: This!
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

