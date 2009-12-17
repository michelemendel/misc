require 'my_test'
require 'test/unit'

puts "Before Class"

class TestTest < Test::Unit::TestCase
    def test_test
        puts "Starting test"
        t = MyTest.new
        assert_equal(1, 1)
        assert_equal(Object, MyTest.superclass)
        assert_equal(MyTest, t.class)
        t.add(1)
        t.add(2)
        assert_equal([1,2], t.instance_eval("@arr"))
    end
end
puts "After Class"