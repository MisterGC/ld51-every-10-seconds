// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import Box2D
import Clayground.Physics
import Clayground.Svg

RectBoxBody
{
    bodyType: Body.Static
    color: "black"
    active: false // no need for physics
}
