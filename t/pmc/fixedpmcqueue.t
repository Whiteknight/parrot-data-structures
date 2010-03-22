#! parrot-nqp

class Test::FixedPMCQueue is Pds::TestCase;

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
    self.set_roles("queue");
    super();
}

method test_VTABLE_set_integer_native() {
    assert_throws_nothing("set_integer_native throws", {
        my $f := Parrot::new("FixedPMCQueue");
        pir::set__PI($f, 5);
    });
}

method test_VTABLE_push_pmc() {
    assert_throws_nothing("push_pmc throws", {
        my $f := Parrot::new("FixedPMCQueue");
        pir::set__PI($f, 5);
        my $i := pir::box__PI(1);
        pir::push__PP($f, $i);
    });
}

method test_VTABLE_shift_pmc() {
    my $f := Parrot::new("FixedPMCQueue");
    pir::set__PI($f, 5);
    pir::push__PP($f, pir::box__PI(1));
    my $j := pir::shift__PP($f);
    assert_equal($i, $j, "push/shift is destructive");
}

method test_VTABLE_elements() {
    my $f := Parrot::new("FixedPMCQueue");
    assert_equal(pir::elements__IP($f), 0, "new FPQ is not empty");

    pir::set__PI($f, 5);
    assert_equal(pir::elements__IP($f), 0, "empty FPQ is not empty");

    pir::push__PP($f, pir::box__PI(1));
    assert_equal(pir::elements__IP($f), 1, "non-empty FPQ is empty");

    pir::shift__PP($f);
    assert_equal(pir::elements__IP($f), 0, "empty FPQ is not empty again");
}

method test_VTABLE_get_bool() {
    my $f := Parrot::new("FixedPMCQueue");
    assert_false($f, "empty FPQ is not false");

    pir::set__PI($f, 5);
    assert_false($Pf, "setting storage made this true");

    pir::push__PP($f, pir::box__PI(1));
    assert_true($f, "non-empty FPQ is not true");

    pir::shift__PP($f);
    assert_false($f, "empty FPQ is not false");
}

method test_VTABLE_get_integer() {
    my $f := Parrot::new("FixedPMCQueue");
    assert_equal(int($f), 0, "empty FPQ does not have zero size");

    pir::set__PI($f, 5);
    assert_equal(int($f), 5, "cannot get reading of allocated storage");
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

