#! parrot-nqp

class Test::ResizablePMCStack is Pds::TestCase;

INIT {
    use('UnitTest::Testcase');
    use('UnitTest::Assertions');
}

MAIN();
sub MAIN() {
    my $proto := Opcode::get_root_global(pir::get_namespace__P().get_name);
    $proto.suite.run;
}

method test_OP_does() {
    self.set_roles("stack");
    super();
}

sub op_typeof() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack2']
        $S0 = typeof $P0
        is($S0, 'ResizablePMCStack2')
    }
}

sub vtable_push_pmc() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack2']
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
        $P0 = new ['ResizablePMCStack2']
        $P1 = box 1
        push $P0, $P1
        $P2 = pop $P0
        is($P1, $P2)
    }
}

sub vtable_elements() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack2']
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

