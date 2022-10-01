// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import Clayground.Physics

RectBoxBody
{
    id: _asteroidFactory
    Timer{
        id: _spawner
        repeat: true; interval: 1000; running: gameScene.running
        property int numAsteroids: 0
        property int maxAsteroids: 10
        onTriggered: {
            if (numAsteroids < maxAsteroids){
                let e = _asteroidComp.createObject(gameScene.room);
                e.Component.destruction.connect(_ => {_spawner.onAsteroidDestroyed();});
                numAsteroids++;
            }
        }
        function onAsteroidDestroyed(){numAsteroids--;}
    }


    Component
    {
        id: _asteroidComp
        Asteroid{
            xWu: _asteroidFactory.xWu + Math.random() * (_asteroidFactory.widthWu - widthWu)
            yWu: _asteroidFactory.yWu - 2 * _asteroidFactory.heightWu
            linearVelocity.y: 10
        }
    }
}
