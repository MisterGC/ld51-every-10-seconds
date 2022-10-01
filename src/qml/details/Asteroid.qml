// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtMultimedia
import Box2D
import Clayground.Physics
import Clayground.Svg

RectBoxBody
{
    id: _asteroid

    categories: collCat.asteroid
    collidesWith: collCat.staticGeo | collCat.player
    bodyType: Body.Dynamic
    widthWu: 3 + Math.random()
    heightWu: widthWu

    Component.onCompleted:
    {
        let numCraters = 10
        let i = 0;
        for (i = 0; i<numCraters; ++i) {
            _craterComp.createObject(_asteroid)
        }
   }

    Component
    {
        id: _craterComp
        Rectangle
        {
            width: _asteroid.width * (.2 + Math.random() * .3)
            height: width
            color: Math.random() > .5 ?
                Qt.darker(_asteroid.color, 1.2 + .5 * Math.random() ) :
                Qt.lighter(_asteroid.color, 1.2 + .5 * Math.random() )
            x: -width * .5 + Math.random() * (_asteroid.width + width * .5)
            y: -height * .5 + Math.random() * (_asteroid.height + height * .5)
            rotation: Math.random() * 360
        }
    }

}
