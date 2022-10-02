// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Particles
import Box2D
import Clayground.GameController
import Clayground.World
import Clayground.Behavior

import "details"
Item {
    property alias running: gameScene.running

    onRunningChanged: if (!running) _gameOverTimer.start()
    Timer {id: _gameOverTimer; interval: 2000; onTriggered: gameOver()}
    signal gameOver()

    Keys.forwardTo: theGameCtrl

    Text {
        z: 99
        Timer { interval: 100;
            running: gameScene.running && (gameScene.gameController ?
                                               gameScene.gameController.spawnsAsteroids :
                                               false)
            repeat: true
            onTriggered: gameState.score += 100;
        }
        anchors {right: parent.right; top: parent.top}
        text: (gameState.score / 1000.0).toFixed(1)
        color: "white"
        font.pixelSize: parent.height * .05
        font.family: "Monospace"
        Rectangle {
            z: -1
            anchors.centerIn: parent
            color: "black"
            width: parent.width * 1.3
            height: parent.height * 1.3
        }
        Text {
            anchors {top: parent.bottom; horizontalCenter: parent.horizontalCenter}
            color: "white"
            text: (gameState._highScore / 1000.0).toFixed(1)
            font.family: "Monospace"
        }
    }

    Text {
        id: _stageText
        anchors.centerIn: parent
        z: 99; font.bold: true
        text: "Stage " + (gameScene.gameController ? gameScene.gameController.stage : "?")
        color: gameScene.gameController ? gameScene.gameController.stageColor : "white"
        font.pixelSize:  gameScene.player ? gameScene.player.height : 1
        onColorChanged:  _showStage.start();
        SequentialAnimation{
            id: _showStage
            PauseAnimation { duration: 500 }
            NumberAnimation {target: _stageText; property: "opacity"; duration: 200; from: 0; to: 1}
            PauseAnimation { duration: 1500 }
            NumberAnimation {target: _stageText; property: "opacity"; duration: 200; from: 1; to: 0}
        }
    }

    ClayWorld {
        id: gameScene
        anchors.fill: parent

        Component.onCompleted:
        {
            map = assets.scene(gameState.level)
            forceActiveFocus();
        }

        // RENDER SETTINGS
        pixelPerUnit: width / gameScene.worldXMax

        // SCENE CREATION CFG: Map Entity Types -> Components to be intialized
        components: new Map([
                                ['Player', c1],
                                ['Floor', c2],
                                ['SpaceBoundary', c3],
                                ['AsteroidFactory', c4],
                                ['AsteroidDestructor', c5]
                            ])
        Component { id: c1; Spaceship {} }
        Component { id: c2; SpaceBackground {} }
        Component { id: c3; SpaceBoundary {} }
        Component { id: c4; AsteroidFactory {} }
        Component { id: c5; AsteroidDestructor {} }


        // PHYSICS SETTINGS
        gravity: Qt.point(0,0)
        timeStep: 1/60.0
        physicsDebugging: false
        QtObject {
            id: collCat
            readonly property int staticGeo: Box.Category1
            readonly property int player: Box.Category2
            readonly property int asteroid: Box.Category3
            readonly property int noCollision: Box.None
        }

        running: false
        property Spaceship player: null
        onPlayerChanged: if (player) running = Qt.binding(_ => {return player.isAlive;})

        property AsteroidFactory gameController: null

        onMapAboutToBeLoaded: {player = null;}
        onMapLoaded: {
            gameState.score = 0;
            theGameCtrl.selectKeyboard(Qt.Key_S,
                                       Qt.Key_W,
                                       Qt.Key_A,
                                       Qt.Key_D,
                                       Qt.Key_J,
                                       Qt.Key_K);
            gameScene.observedItem = player;
            gameState.fontPixelSize = player.height * .4
            gameMusic.playLooped("level_music");
        }

        onMapEntityCreated: (obj, groupId, compName) => {
                                if (obj instanceof Spaceship) {
                                    player = obj;
                                    player.fullThrottle = Qt.binding(_ =>
                                     {return (gameController ? !gameController.spawnsAsteroids : false);}
                                    )
                                }
                                if (obj instanceof AsteroidFactory) gameController = obj;
                            }

        Keys.forwardTo: theGameCtrl
        GameController { id: theGameCtrl; anchors.fill: parent }

    }

}
