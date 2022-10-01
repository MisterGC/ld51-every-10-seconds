// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import Box2D
import Clayground.Physics

RectBoxBody
{
    bodyType: Body.Static
    color: "black"
    categories: collCat.staticGeo
    collidesWith: collCat.player
}
