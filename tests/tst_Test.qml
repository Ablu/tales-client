import QtQuick 2.0
import QtTest 1.0

TestCase {
    name: "testtest"

    function test_test()
    {
        compare(true, true, "right!!!");
    }

    function test_testtest()
    {
        compare(true, false, "right!!!");
    }
}
