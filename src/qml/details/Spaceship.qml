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
    visible: isAlive
    onIsAliveChanged: {
        if (!isAlive){
            fullThrottle = false;
            _destructionSound.play();
            _destructionAnimComp.createObject(player.parent,
                                              {
                                                  "x": player.x,
                                                  "y": player.y,
                                                  "width": player.width,
                                                  "height": player.height
                                              }

                                              );
        }
    }

    Component.onCompleted: {
        PhysicsUtils.connectOnEntered(fixtures[0], _onCollision)
    }
    function _onCollision(entity) { if (entity instanceof Asteroid) shield--;}

    widthWu: heightWu

    readonly property real veloCompMax: 20
    property real xDirDesire: theGameCtrl.axisX
    property bool fullThrottle: false

    GameSound{
        id: _engineSound
        sound:"engine"
        loops: SoundEffect.Infinite
    }

    onFullThrottleChanged: {
//        if (fullThrottle) _engineSound.play();
//        else _engineSound.stop();
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
        z: -1
        Emitter {
            id: _emitter
            enabled: player.isAlive
            anchors.centerIn: parent
            lifeSpan: 50 + (fullThrottle ? 100 : 0)
            endSize: 1
            emitRate: 15
            velocity: AngleDirection{
                magnitude: player.height * 2; angle: 90
                angleVariation: 5; }
        }

        ItemParticle {
            delegate: Rectangle {
                width: player.width *.7 + player.width * .1 * Math.random()
                height: width
                color:  Qt.lighter(gameState.cBLUE, 1.6)
            }
        }
    }

    GameSound{
        id: _destructionSound
        sound:"crash"
        loops: SoundEffect.Infinite
    }

    Component {
        id: _destructionAnimComp

        ParticleSystem {
            id: _destructionAnim
            property int numParts: 30
            property real partBaseSize: height / Math.sqrt(numParts)
            Component.onCompleted: emitter.burst(numParts)
            Emitter {
                id: emitter
                enabled: false
                anchors.centerIn: parent
                lifeSpan: 5000
                velocity: AngleDirection{
                    magnitude: _destructionAnim.height
                    magnitudeVariation: magnitude * .3
                    angleVariation: 360
                }
            }
            ItemParticle {
                delegate: Rectangle {
                    width: _destructionAnim.partBaseSize +
                           Math.random() * (_destructionAnim.partBaseSize * .25)
                    height: width
                    readonly property real r: 0.5 + Math.random() * .5
                    color: Qt.rgba(r, r, r, 1)
                    rotation: Math.random() * 360
                }
            }
        }
    }
}
