#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(1);
    ok(1);
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
        # TODO: This!
    }
}

sub op_does() {
    Q:PIR {
        # TODO: This!
    }
}

sub op_typeof() {
    Q:PIR {
        # TODO: This!
    }
}

sub vtable_set_integer_native() {
    Q:PIR {
        # TODO: This!
    }
}

sub vtable_push_pmc() {
    Q:PIR {
        # TODO: This!
    }
}

sub vtable_shift_pmc() {
    Q:PIR {
        # TODO: This!
    }
}

sub vtable_elements() {
    Q:PIR {
        # TODO: This!
    }
}

sub vtable_get_bool() {
    Q:PIR {
        # TODO: This!
    }
}

sub vtable_get_integer() {
    Q:PIR {
        # TODO: This!
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

