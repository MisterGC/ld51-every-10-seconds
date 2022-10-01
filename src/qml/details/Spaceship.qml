// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtMultimedia
import Box2D
import Clayground.Physics
import Clayground.Svg

RectBoxBody
{
    id: player
    color: "white"

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

    readonly property real veloCompMax: 60
    property real xDirDesire: theGameCtrl.axisX
    linearVelocity.x: xDirDesire * veloCompMax

    linearVelocity.y: 0

    Rectangle {
        width: player.width; height: player.height * .15
        anchors {top: player.top; horizontalCenter: player.horizontalCenter}
        Rectangle {
            width: parent.width * 1.3; height: parent.height
            anchors {top: parent.bottom; horizontalCenter: parent.horizontalCenter}
        }
        Rectangle {
            width: parent.width * .5; height: parent.height
            anchors {bottom: parent.top; horizontalCenter: parent.horizontalCenter}
        }
    }

    Rectangle {
        width: player.width * 1.8; height: player.height * .25
        anchors {bottom: player.bottom; horizontalCenter: player.horizontalCenter}
        Rectangle {
            width: parent.width * 0.8; height: parent.height * .7
            anchors {bottom: parent.top; horizontalCenter: parent.horizontalCenter}
        }
    }
}
