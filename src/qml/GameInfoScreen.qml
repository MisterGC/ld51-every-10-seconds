// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Particles
import Box2D
import Clayground.GameController
import Clayground.World
import Clayground.Behavior
import Clayground.Common

Item {
    id: _infoScreen

    Column {
        id: _scoreInfos
        anchors.centerIn: parent
        Text {
            color: "white"; text: "Highscore: " +
                                    (gameState._highScore / 1000).toFixed(2) +
                                    " sec"
            }
        Text {visible: gameState.score > 0;
            color: "white"; text: "Last Score: " +
                                    (gameState.score / 1000).toFixed(2) +
                                    " sec"

        }

    }

    Text {
        text: "Press any key to start!"
        anchors { horizontalCenter: parent.horizontalCenter
                  top: _scoreInfos.bottom; topMargin: 2 * height
        }
        color: "white"
    }
    Component.onCompleted: forceActiveFocus();
    signal startRequested()
    Keys.onPressed: startRequested()
}
