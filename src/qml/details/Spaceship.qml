// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtMultimedia
import Box2D
import Clayground.Physics
import Clayground.Svg

RectBoxBody
{
    id: player

    bodyType: Body.Dynamic
    property int shield: 1

    Component.onCompleted: {
        PhysicsUtils.connectOnEntered(fixtures[0], _onCollision)
    }
    function _onCollision(entity) { if (entity instanceof Asteroid) shield--;}

    widthWu: heightWu
    categories: collCat.player
    collidesWith: collCat.staticGeo | collCat.enemy

    readonly property real veloCompMax: 25
    property real xDirDesire: theGameCtrl.axisX
    linearVelocity.x: xDirDesire * veloCompMax

    linearVelocity.y: 0
}
