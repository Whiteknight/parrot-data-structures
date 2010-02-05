#! parrot-nqp
our @ARGS;
MAIN();

sub MAIN () {
    load_test_more();
    plan(5);

    load_linalg_group();
    create_resizablepmcqueue();
    op_does();
    vtable_push();
    vtable_shift();
    vtable_elements();
    method_to_array();
    method_total_mem_size();
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

sub vtable_push() {
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

sub vtable_shift() {
    Q:PIR {
    }
}

sub vtable_elements() {
    Q:PIR {
    }
}

sub method_to_array() {
    Q:PIR {
    }
}

sub method_total_mem_size() {
    Q:PIR {
    }
}

