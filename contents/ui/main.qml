import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.plasma5support 2.0 as Plasma5Support

PlasmoidItem {
    id: root
    width: 40
    height: 40
    property bool caffeineEnabled: false

    Plasma5Support.DataSource {
        id: execSource
        engine: "executable"
        onNewData: (sourceName, data) => {
            disconnectSource(sourceName)
            console.log("Executed:", sourceName)
            console.log("Output:", data[sourceName]?.stdout || "")
        }

        function run(cmd) {
            connectSource("bash -c \"" + cmd + "\"")
        }
    }

    Image {
        id: icon
        anchors.centerIn: parent
        width: 32
        height: 32
        source: caffeineEnabled ? "../icons/enabled.svg" : "../icons/disabled.svg"
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            caffeineEnabled = !caffeineEnabled
            icon.source = caffeineEnabled ? "../icons/enabled.svg" : "../icons/disabled.svg"

            if (caffeineEnabled) {
                execSource.run("systemd-inhibit --what=idle:sleep --why='Caffeine Mode' sleep 36000")
            } else {
                execSource.run("pkill -f 'systemd-inhibit --what=idle:sleep'")
            }
        }
    }
}
