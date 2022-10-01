// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtQuick.Window

Window {
    visible: true
    visibility: Window.FullScreen
    title: qsTr("Deep In Colorful Space")
    GameApp {}
    Component.onCompleted: if(Qt.platform.pluginName === "minimal") Qt.quit()
}
