#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(27);
    load_linalg_group();

    op_new();
    op_does();
    op_typeof();
    vtable_set_integer_native();
    vtable_push_pmc();
    vtable_push_pmc_overflow();
    vtable_shift_pmc();
    vtable_shift_pmc_underflow();
    vtable_elements();
    vtable_get_bool();
    vtable_get_integer();
    method_capacity();
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
        say "Missing dynext/pds_group"
        exit 1
     has_pds_group:
    };
}

sub op_new() {
    Q:PIR {
        $I0 = 0
        push_eh new_sanity_failure
        $P0 = new ['FixedPMCQueue3']
        $I0 = 1
      new_sanity_failure:
        pop_eh
        ok($I0, "Can create FPQ")

        $I0 = isnull $P0
        todo($I0, "... should be Null (or not!?)")
    }
}

sub op_does() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $I0 = does $P0, 'queue'
        is($I0, 1, "Does 'queue'")
        $I0 = does $P0, "jibbajabba"
        is($I0, 0, " ... but not 'jibbajabba'")
    }
}

sub op_typeof() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $S0 = typeof $P0
        is($S0, 'FixedPMCQueue3', "Isa 'FixedPMCQueue3'")
    }
}

sub vtable_set_integer_native() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $I0 = 0
        push_eh set_integer_sanity_error
        $P0 = 5
        $I0 = 1
      set_integer_sanity_error:
        pop_eh
        ok($I0, "Can set capacity (to 5)")
    }
}

sub vtable_push_pmc() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $I1 = 5
        $P0 = $I1
        $P1 = box 1
        $I0 = 0
        push_eh push_pmc_sanity_error
      L1:
        push $P0, $P1
        dec $I1
        gt $I1, 0, L1
        $I0 = 1
      push_pmc_sanity_error:
        pop_eh
        ok($I0, "Can push up to capacity onto queue")
    }
}

sub vtable_push_pmc_overflow() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $I1 = 5
        $P0 = $I1
        $P1 = box 1
      L1:
        push $P0, $P1
        dec $I1
        gt $I1, 0, L1
        $I0 = 1
        push_eh push_pmc_overflow
        push $P0, $P1
        $I0 = 0
      push_pmc_overflow:
        pop_eh
        ok($I0, "Can't push onto full queue (throws exception)")
    }
}

sub vtable_shift_pmc() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $P0 = 5
        $P1 = box 1
        push $P0, $P1
        $P2 = shift $P0
        is($P1, $P2, "Push then shift gets original value back")
    }
}

sub vtable_shift_pmc_underflow() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $P0 = 5
        $P2 = shift $P0
        $I0 = isnull $P2
        ok($I0, "Shift on empty queue returns Null")
    }
}

sub vtable_elements() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $I0 = elements $P0
        is($I0, 0, ".elements() initially 0")

        $P0 = 5
        $I0 = elements $P0
        is($I0, 0, "        ... still empty after setting capacity")

        $P1 = box 1
        push $P0, $P1
        $I0 = elements $P0
        is($I0, 1, "        ... is 1 after pushing 1 item")

        $P2 = shift $P0
        $I0 = elements $P0
        is($I0, 0, "        ... is 0 after shifting all items")
    }
}

sub vtable_get_bool() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $I0 = istrue $P0
        is($I0, 0, "Boolean initially false")

        $P0 = 5
        $I0 = istrue $P0
        is($I0, 0, "        ... still false after setting capacity")

        $P1 = box 1
        push $P0, $P1
        $I0 = istrue $P0
        is($I0, 1, "        ... is true after pushing 1 item")

        $P2 = shift $P0
        $I0 = istrue $P0
        is($I0, 0, "        ... is false after shifting all items")
    }
}

sub vtable_get_integer() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $I0 = $P0
        is($I0, 0, "Integer initially 0")

        $P0 = 5
        $I0 = $P0
        is($I0, 0, "        ... still empty after setting capacity")

        $P1 = box 1
        push $P0, $P1
        $I0 = $P0
        is($I0, 1, "        ... is 1 after pushing 1 item")

        $P2 = shift $P0
        $I0 = $P0
        is($I0, 0, "        ... is 0 after shifting all items")
    }
}

sub method_capacity() {
    Q:PIR {
        $P0 = new ['FixedPMCQueue3']
        $P1 = $P0.'capacity'()
        $I0 = isnull $P1
        ok($I0, ".capacity() initially null")
        $P0 = 5
        $I0 = $P0.'capacity'()
        is($I0, 5, "    ... changes to reflect capacity")
    }
}

sub method_to_array() {
    Q:PIR {
        todo(0, "test .to_array()")
    }
}

sub method_total_mem_size() {
    Q:PIR {
        todo(0, "test .total_mem_size()")
    }
}

sub method_clear() {
    Q:PIR {
        todo(0, "test .clear()")
    }
}

