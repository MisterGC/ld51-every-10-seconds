// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtMultimedia
import Box2D
import Clayground.Physics
import Clayground.Svg
import QtQuick.Particles

RectBoxBody
{
    id: player
    color: "lightgrey"

    bodyType: Body.Dynamic
    categories: collCat.player
    collidesWith: collCat.staticGeo | collCat.asteroid

    property int shield: 1
    readonly property bool isAlive: shield > 0

    Component.onCompleted: {
        PhysicsUtils.connectOnEntered(fixtures[0], _onCollision)
    }
    function _onCollision(entity) { if (entity instanceof Asteroid) shield--;}

    widthWu: heightWu

    readonly property real veloCompMax: 20
    property real xDirDesire: theGameCtrl.axisX
    property real yDirDesire: theGameCtrl.axisY

    GameSound{
        id: _engineSound
        sound:"engine"
        loops: SoundEffect.Infinite
    }
    onYDirDesireChanged: {
        console.log("Check da sound " + _engineSound.status + " " + SoundEffect.Loading)
        if (Math.abs(yDirDesire) > 0.1)
        {
            console.log("Play it ");
           _engineSound.play();
        }
        else
        {
            console.log("Stop it");
            _engineSound.stop();
        }
    }

    linearVelocity.x: xDirDesire * veloCompMax

    Rectangle {
        color: Qt.lighter("lightgrey", 1.1)
        width: player.width; height: player.height * .15
        anchors {top: player.top; horizontalCenter: player.horizontalCenter}
        Rectangle {
            color: parent.color
            width: parent.width * 1.3; height: parent.height
            anchors {top: parent.bottom; horizontalCenter: parent.horizontalCenter}
        }
        Rectangle {
            color: parent.color
            width: parent.width * .5; height: parent.height
            anchors {bottom: parent.top; horizontalCenter: parent.horizontalCenter}
        }
    }

    Rectangle {
        color: xDirDesire < -.1 ? Qt.darker("grey", 1.2) :
               xDirDesire > .1 ? Qt.lighter("grey", 1.2) : "grey"
        z: -1
        width: player.width *  (Math.abs(xDirDesire) > .1 ? .85 : 1)
        height: player.height * .25
        anchors {bottom: player.bottom; right: player.horizontalCenter}
        Rectangle {
            color: parent.color
            width: parent.width * 0.8; height: parent.height * .7
            anchors {bottom: parent.top; horizontalCenter: parent.horizontalCenter}
        }
    }

    Rectangle {
        color: xDirDesire > .1 ? Qt.darker("grey", 1.2) :
               xDirDesire < -.1 ? Qt.lighter("grey", 1.2) : "grey"
        z: -1
        width: player.width *  (Math.abs(xDirDesire) > .1 ? .85 : 1)
        height: player.height * .25
        anchors {bottom: player.bottom; left: player.horizontalCenter}
        Rectangle {
            color: parent.color
            width: parent.width * 0.8; height: parent.height * .7
            anchors {bottom: parent.top; horizontalCenter: parent.horizontalCenter}
        }
    }


    ParticleSystem {
        anchors {horizontalCenter: player.horizontalCenter; top: player.bottom}
        Emitter {
            id: _emitter
            enabled: true
            anchors.centerIn: parent
            lifeSpan: 150 - yDirDesire * 100
            endSize: 1
            emitRate: 15
            velocity: AngleDirection{
                magnitude: player.height * 2; angle: 90
                angleVariation: 5; }
        }

        ItemParticle {
            delegate: Rectangle {
                width: player.width *.4 + player.width * .1 * Math.random()
                height: width
                color:  gameState.cORANGE
                //rotation: Math.random() * 20
            }
        }
    }
}
