import QtQuick 2.0
import QtTest 1.0
import Mana 1.0

TestCase {
    name: "accountClientTest"

    Component {
        id: accountClient

        AccountClient { }
    }

    SignalSpy {
        id: spy
    }

    function test_test()
    {
        var client = accountClient.createObject(null, {});
        console.warn(client.connected)
        client.connect("server.sourceoftales.org", 9601);
        client.service();
    }
}
