// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtMultimedia
import Box2D
import Clayground.Physics
import Clayground.Svg

RectBoxBody
{
    id: _star

    color: "white"
    categories: collCat.asteroid
    collidesWith: collCat.staticGeo
    bodyType: Body.Dynamic
    widthWu: .1 + Math.random() * .2
    heightWu: widthWu //* linearVelocity.y * .3
}
