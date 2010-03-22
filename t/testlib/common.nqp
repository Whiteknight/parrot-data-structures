
INIT {
    use('UnitTest::Testcase');
    use('UnitTest::Assertions');
}

class Pds::Testcase is UnitTest::Testcase {
    method is_resizable() {
        return (0);
    }

    method create() {
        Exception::MethodNotFound.new(
            :message("Must subclass create() in your test class")
        ).throw;
    }

    method set_integer($f, $x) {
        Q:PIR {
            $P0 = find_lex '$f'
            $P1 = find_lex '$x'
            $I0 = $P1
            $P0 = $I0
        }
    }

    method push_pmc($f, $x) {
        Q:PIR {
            $P0 = find_lex '$f'
            $P1 = find_lex '$x'
            push $P0, $P1
        }
    }

    has @!roles;

    ##### TEST METHODS #####

    method test_OP_new() {
        assert_throws_nothing("Cannot create data structure", {
            my $m := self.create();
            assert_not_null($m, "Could not create a data structure");
        });
    }

    method test_OP_does() {
        fail("This test must be overridden in a subclass");
    }

    method test_OP_does_NOT() {
        my $m := self.create();
        assert_false(pir::does($m, "gobbledegak"), "Does gobbledegak");
    }

    method test_VTABLE_elements_EMPTY() {
        my $f := self.create();
        my $s := pir::typeof__SP($f);
        assert_equal(pir::elements__IP($f), 0, "new $s is not empty");
    }

    method test_VTABLE_elements() {
        fail("This test must be overridden in a subclass");
    }

    method test_VTABLE_get_bool() {
        fail("This test must be overridden in a subclass");
    }

    method test_METHOD_total_mem_size() {
        fail("This test must be overridden in a subclass");
    }

    method test_METHOD_clear() {
        fail("This test must be overridden in a subclass");
    }

    method test_METHOD_to_array() {
        my $f := self.create();
        if (!self.is_resizable) { self.set_integer($f, 5); }
        self.push_pmc($f, 1);
        self.push_pmc($f, 2);
        self.push_pmc($f, 3);
        self.push_pmc($f, 4);
        my $a := $f.to_array();
        if (self.is_resizable) {
            assert_instance_of($a, "ResizablePMCArray", "Incorrect array type");
        } else {
            assert_instance_of($a, "FixedPMCArray", "Incorrect array type");
        }
        my $arraylen := pir::elements__IP($a);
        assert_equal($arraylen, 4, "array does not have the right number of elements. Want 4, have $arraylen");
        assert_equal($a[0], 1, "element 0 incorrect");
        assert_equal($a[1], 2, "element 1 incorrect");
        assert_equal($a[2], 3, "element 2 incorrect");
        assert_equal($a[3], 4, "element 3 incorrect");
    }
}

# Parent class for testing stack-like structures
class Pds::Testcase::Stack is Pds::Testcase {
    method test_OP_does() {
        my $f := self.create();
        assert_true(pir::does__IP($f, "stack"), "Stack does not do stack");
    }

    method test_VTABLE_elements() {
        my $f := self.create();

        if (!self.is_resizable) { self.set_integer($f, 5); }

        self.push_pmc($f, pir::box__PI(1));
        assert_equal(pir::elements__IP($f), 1, "pushing doesn't give us an element");

        pir::pop__PP($f);
        assert_equal(pir::elements__IP($f), 0, "empty stack is not is not empty");
    }

    method test_VTABLE_push_pmc_SANITY() {
        assert_throws_nothing("push_pmc throws something", {
            my $f := self.create();
            if (!self.is_resizable) { self.set_integer($f, 5); }
            self.push_pmc($f, pir::box__PI(1));
        });
    }

    method test_VTABLE_pop_pmc() {
        my $f := self.create();
        if (!self.is_resizable) { self.set_integer($f, 5); }
        my $i := pir::box__PI(1);
        self.push_pmc($f, $i);
        my $j := pir::pop__PP($f);
        assert_same($i, $j, "push/pop returns the same PMC");
    }

    method test_VTABLE_get_bool() {
        my $f := self.create();
        assert_false($f, "empty struct is not false");

        if (!self.is_resizable) {
            self.set_integer($f, 5);
            assert_false($f, "allocation does not change truth value");
        }
        self.push_pmc($f, pir::box__PI(1));
        assert_true($f, "non-empty struct is not true");

        pir::pop__PP($f);
        assert_false($f, "empty struct is not false");
    }

    method test_METHOD_total_mem_size() {
        todo("Tests Needed!");
    }

    method test_METHOD_clear() {
        todo("Tests Needed!");
    }
}

# Fixed-storage stack types
class Pds::Testcase::FixedStack is Pds::Testcase::Stack {
    method test_VTABLE_set_integer_native_SANITY() {
        assert_throws_nothing("Cannot set_integer_native", {
            my $f := self.create();
            self.set_integer($f, 5);
        });
    }

    method test_VTABLE_get_integer_native() {
        my $f := self.create();
        my $i := pir::set__IP($f);
        my $s := pir::typeof__SP($f);
        assert_equal($i, 0, "new $s is allocated");

        self.set_integer($f, 5);
        $i := pir::set__IP($f);
        assert_equal($i, 5, "does not have proper allocated storage");
    }
}

# Dynamically-expandable stack types
class Pds::Testcase::ResizableStack is Pds::Testcase::Stack {
    method is_resizable() {
        return (1);
    }
}

# Parent type for queue-like structures
class Pds::Testcase::Queue is Pds::Testcase {
    method test_OP_does() {
        my $f := self.create();
        assert_true(pir::does__IPS($f, "queue"), "Queue does not do queue");
    }

    method test_VTABLE_push_pmc() {
        assert_throws_nothing("push_pmc throws something", {
            my $f := self.create();
            if (!self.is_resizable) { self.set_integer($f, 5); }
            self.push_pmc($f, pir::box__PI(1));
        });
    }

    method test_VTABLE_shift_pmc() {
        my $f := self.create();
        if (!self.is_resizable) { self.set_integer($f, 5); }
        my $i := pir::box__PI(1);
        self.push_pmc($f, $i);
        my $j := pir::shift__PP($f);
        assert_equal($i, $j, "push/shift is destructive");
    }

    method test_VTABLE_elements() {
        my $f := self.create();
        if (!self.is_resizable) { self.set_integer($f, 5); }
        assert_equal(pir::elements__IP($f), 0, "new FPQ is not empty");

        self.push_pmc($f, pir::box__PI(1));
        assert_equal(pir::elements__IP($f), 1, "non-empty FPQ is empty");

        pir::shift__PP($f);
        assert_equal(pir::elements__IP($f), 0, "empty FPQ is not empty again");
    }

    method test_VTABLE_get_bool() {
        my $f := self.create();
        assert_false($f, "empty queue is not false");
        if (!self.is_resizable) {
            self.set_integer($f, 5);
            assert_false($f, "allocation does not change truth value");
        }
        self.push_pmc($f, pir::box__PI(1));
        assert_true($f, "non-empty queue is not true");

        pir::shift__PP($f);
        assert_false($f, "empty queue is not false");
    }

    method test_METHOD_total_mem_size() {
        todo("Tests Needed!");
    }

    method test_METHOD_clear() {
        todo("Tests Needed!");
    }
}

# Fixed-storage queue types
class Pds::Testcase::FixedQueue is Pds::Testcase::Queue {
    method test_VTABLE_set_integer_native() {
        assert_throws_nothing("set_integer_native throws", {
            my $f := Parrot::new("FixedPMCQueue");
            self.set_integer($f, 5);
        });
    }

    method test_VTABLE_get_integer() {
        my $f := Parrot::new("FixedPMCQueue");
        assert_equal(int($f), 0, "empty FPQ does not have zero size");

        self.set_integer($f, 5);
        assert_equal(int($f), 5, "cannot get reading of allocated storage");
    }
}

# Dynamically-resizable queue types
class Pds::Testcase::ResizableQueue is Pds::Testcase::Queue {
    method is_resizable() {
        return (1);
    }
}
