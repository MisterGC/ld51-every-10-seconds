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

ClayWorld {
    id: gameScene

    Component.onCompleted: map = assets.scene(gameState.level)

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
    property var player: null
    onPlayerChanged: if (player) running = Qt.binding(_ => {return player.isAlive;})

    onMapAboutToBeLoaded: {player = null;}
    onMapLoaded: {
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
            player.color = "#d45500";
        }
    }

    Keys.forwardTo: theGameCtrl
    GameController { id: theGameCtrl; anchors.fill: parent }

}
