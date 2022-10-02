// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import Clayground.Physics

RectBoxBody
{
    color: "transparent"
    Component.onCompleted: PhysicsUtils.connectOnEntered(fixtures[0], _onEntered)
    categories: collCat.staticGeo
    collidesWith: collCat.asteroid
    function _onEntered(entity) { entity.destroy(); }
}
