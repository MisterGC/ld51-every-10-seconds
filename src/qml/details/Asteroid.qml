// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtMultimedia
import Box2D
import Clayground.Physics
import Clayground.Svg

RectBoxBody
{
    id: enemy

    color: "white"
    categories: collCat.asteroid
    collidesWith: collCat.staticGeo | collCat.player
    bodyType: Body.Dynamic
    widthWu: 3
    heightWu: 3
}
