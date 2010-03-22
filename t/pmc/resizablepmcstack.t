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

method test_VTABLE_push_pmc() {
    assert_throws_nothing("push throws", {
        Q:PIR {
            $P0 = new ['ResizablePMCStack']
            $P1 = box 1
            push $P0, $P1
        }
    });
}

method test_VTABLE_pop_pmc() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack']
        $P1 = box 1
        push $P0, $P1
        $P2 = pop $P0
        assert_same($P1, $P2, "pushing and popping create different PMCs")
    }
}

method test_VTABLE_elements() {
    Q:PIR {
        $P0 = new ['ResizablePMCStack']
        $I0 = elements $P0
        assert_equal($I0, 0, "new RPS is empty")

        $P1 = box 1
        push $P0, $P1
        $I0 = elements $P0
        assert_equal($I0, 1, "RPS with one element in it has non-1 size")

        $P2 = pop $P0
        $I0 = elements $P0
        assert_equal($I0, 0, "empty RPS is empty")
    }
}

method test_METHOD_to_array() {
    todo("Tests Needed!");
}

method test_METHOD_total_mem_size() {
    todo("Tests Needed!");
}

method test_METHOD_clear() {
    todo("Tests Needed!");
}

