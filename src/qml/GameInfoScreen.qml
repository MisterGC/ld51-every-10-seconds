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
        anchors {
            bottom: _scoreInfos.top;
            bottomMargin: height * .2
            horizontalCenter: parent.horizontalCenter}
        Text {color: "white"; text: "DEEP IN"; font.pixelSize: .1 * _infoScreen.height;
             anchors.horizontalCenter: parent.horizontalCenter}
        Text {color: gameState.cORANGE; text: "COLORFUL";
              font.pixelSize: .08 * _infoScreen.height
              anchors.horizontalCenter: parent.horizontalCenter}
        Text {color: "white"; text: "SPACE";
              font.pixelSize: .1 * _infoScreen.height
             anchors.horizontalCenter: parent.horizontalCenter}
    }

    Column {
        id: _scoreInfos
        anchors.centerIn: parent
        Text {
            color: "white";
            text: "Highscore: " +
                  (gameState._highScore / 1000).toFixed(2) +
                  " sec"
            font.pixelSize: .03 * _infoScreen.height
            }
        Text {visible: gameState.score > 0;
            color: "white"; text: "Last Score: " +
                                    (gameState.score / 1000).toFixed(2) +
                                    " sec"

        }

    }

    Text {
        text:
            "Control your spaceship by using the keys <i>A</i> and <i>D</i><br>" +
            "Try to survive as long as possible - press any key to start.<br>"
        anchors { horizontalCenter: parent.horizontalCenter
                  top: _scoreInfos.bottom; topMargin: 2 * height
        }
        color: "white"
    }
    Component.onCompleted: forceActiveFocus();
    signal startRequested()
    Keys.onPressed: startRequested()
}
