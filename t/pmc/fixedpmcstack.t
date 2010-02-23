#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(21);

    load_linalg_group();
    op_new();
    op_typeof();
    op_does();
    vtable_set_integer_native();
    vtable_get_integer_native();
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

sub load_linalg_group() {
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
        push_eh op_new_sanity
        $I0 = 0
        $P0 = new ['FixedPMCStack']
        $I0 = 1
      op_new_sanity:
        pop_eh
        ok($I0)
        $I0 = isnull $P0
        ok($I0)
    }
}

sub op_typeof() {
    Q:PIR {
        $P0 = new ['FixedPMCStack']
        $S0 = typeof $P0
        is($S0, "FixedPMCStack")
    }
}


sub op_does() {
    Q:PIR {
        $P0 = new ['FixedPMCStack']
        $I0 = does $P0, 'stack'
        ok($I0)
        $I0 = does $P0, 'jibbajabba'
        is($I0, 0)
    }
}


sub vtable_set_integer_native() {
    Q:PIR {
        push_eh set_integer_native_sanity
        $I0 = 0
        $P0 = new ['FixedPMCStack']
        $P0 = 5
        $I0 = 1
      set_integer_native_sanity:
        pop_eh
        ok($I0)
    }
}

sub vtable_get_integer_native() {
    Q:PIR {
        $P0 = new ['FixedPMCStack']
        $I0 = $P0
        is($I0, 0)

        $P0 = 5
        $I0 = $P0
        is($I0, 5)
    }
}

sub vtable_push_pmc() {
    Q:PIR {
        $P0 = new ['FixedPMCStack']
        $P0 = 5
        $P1 = box 1
        push_eh push_pmc_sanity
        $I0 = 0
        push $P0, $P1
        $I0 = 1
      push_pmc_sanity:
        pop_eh
        ok($I0, "push_pmc vtable does not exist")

        $P0 = new ['FixedPMCStack']
        $P0 = 5
        $P1 = box 1
        $I0 = 0
        push_eh push_pmc_overflow
        push $P0, $P1
        $I0 = $I0 + 1
        push $P0, $P1
        $I0 = $I0 + 1
        push $P0, $P1
        $I0 = $I0 + 1
        push $P0, $P1
        $I0 = $I0 + 1
        push $P0, $P1
        $I0 = $I0 + 1
        push $P0, $P1
        $I0 = $I0 + 1
        ok(0, "push_pmc did not overflow")
        goto push_pmc_overflow_end
      push_pmc_overflow:
        is($I0, 5, "push_pmc successfully overflowed")
      push_pmc_overflow_end:
    }
}

sub vtable_pop_pmc() {
    Q:PIR {
        $P0 = new ['FixedPMCStack']
        $P0 = 2
        $P1 = box 1
        push $P0, $P1
        $P2 = pop $P0
        is($P1, $P2)
    }
}

sub vtable_elements() {
    Q:PIR {
        $P0 = new ['FixedPMCStack']
        $I0 = elements $P0
        is($I0, 0)

        $P0 = 2
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
        $P0 = new ['FixedPMCStack']
        $P0 = 5
        $P1 = box 1
        push $P0, $P1
        $P2 = box 2
        push $P0, $P2
        $P3 = box 42
        push $P0, $P3

        $P4 = $P0.'to_array'()
        $I0 = $P4
        is($I0, 5)

        $P5 = $P4[0]
        is($P5, $P1)
        $P6 = $P4[1]
        is($P6, $P2)
        $P7 = $P4[2]
        is($P7, $P3)
        $P8 = $P4[3]
        $I0 = isnull $P8
        is($I0, 1)
        $P9 = $P4[4]
        $I0 = isnull $P9
        is($I0, 1)

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


