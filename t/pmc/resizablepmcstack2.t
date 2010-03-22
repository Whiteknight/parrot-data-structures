#! parrot-nqp

class Test::ResizablePMCStack2 is Pds::TestCase::ResizableStack;

INIT {
    use('UnitTest::Testcase');
    use('UnitTest::Assertions');
}

MAIN();
sub MAIN() {
    my $proto := Opcode::get_root_global(pir::get_namespace__P().get_name);
    $proto.suite.run;
}

method create() {
    return (Parrot::new("ResizablePMCStack2"));
}
