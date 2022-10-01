// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import QtMultimedia
import Box2D
import Clayground.Physics
import Clayground.Svg

LivingEntity
{
    id: enemy

    categories: collCat.enemy
    collidesWith: collCat.staticGeo | collCat.player
    bodyType: Body.Dynamic
    maxHealth: 1
    onHealthChanged: if (health < 0) enemy.destroy()
    visu.sprites: [
        Sprite {
            name: "enemy";
            source: assets.visual(sourceSvg + "/" + name)
            frameCount: 1
            frameRate: 1
        }
    ]

}
