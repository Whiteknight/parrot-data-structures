#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(1);
    ok(19);
    load_linalg_group();

    op_new();
    op_does();
    op_typeof();
    vtable_set_integer_native();
    vtable_push_pmc();
    vtable_shift_pmc();
    vtable_elements();
    vtable_get_bool();
    vtable_get_integer();
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
        push_eh new_sanity_failure
        $P0 = new ['FixedPMCQueue']
        ok(1)
        goto new_sanity_end
      new_sanity_failure:
        ok(0)
        new_sanity_end:

        $I0 = isnull $P0
        is($I0, 1)
    }
}

sub op_does() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue']
        $I0 = does $P0, 'queue'
        is($I0, 1)
        $I0 = does $P0, "jibbajabba"
        is($I0, 0)
    }
}

sub op_typeof() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue']
        $S0 = typeof $P0
        is($S0, 'FixedPMCQueue')
    }
}

sub vtable_set_integer_native() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue']
        push_eh set_integer_sanity_error
        $P0 = 5
        ok(1)
        goto set_integer_sanity_end
      set_integer_sanity_error:
        ok(0)
      set_integer_sanity_end:
    }
}

sub vtable_push_pmc() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue']
        $P0 = 5
        $P1 = box 1
        push_eh push_pmc_sanity_error
        push $P0, $P1
        ok(1)
        goto push_pmc_sanity_end
      push_pmc_sanity_error:
        ok(0)
      push_pmc_sanity_end:
    }
}

sub vtable_shift_pmc() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue']
        $P0 = 5
        $P1 = box 1
        push $P0, $P1
        $P2 = shift $P0
        is($P1, $P2)
    }
}

sub vtable_elements() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue']
        $I0 = elements $P0
        is($I0, 0)

        $P0 = 5
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
        $P0 = new ['FixedPMCQueue']
        $I0 = istrue $P0
        is($I0, 0)

        $P0 = 5
        $I0 = istrue $P0
        is($I0, 0)

        $P1 = box 1
        push $P0, $P1
        $I0 = istrue $P0
        is($I0, 1)

        $P2 = shift $P0
        $I0 = istrue $P0
        is($I0, 0)
    }
}

sub vtable_get_integer() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue']
        $I0 = $P0
        is($I0, 0)

        $P0 = 5
        $I0 = $P0
        is($I0, 5)
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

