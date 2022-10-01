// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import Clayground.Physics

RectBoxBody
{
    id: _asteroidFactory
    property int _asteroidsPerSeconds: stage
    property int _numAsteroids: 0
    property int stage: 1
    property var _colorPalette: [
        gameState.cBLUE,
        gameState.cGREEN,
        gameState.cORANGE,
        gameState.cRED,
        gameState.cYELLOW
    ]

    Timer{
        id: _asteroidSpawner
        repeat: running; interval: 500; running: gameScene.running
        onTriggered: {
            let color = _colorPalette[_asteroidFactory.stage % _asteroidFactory._colorPalette.length]
            for (let i=0; i < _asteroidsPerSeconds; ++i)
            {
                let e = _asteroidComp.createObject(gameScene.room, {"color": color});
                e.Component.destruction.connect(_ => {_asteroidSpawner.onAsteroidDestroyed();});
                _numAsteroids++;
                _starComp.createObject(gameScene.room);
                //console.log("# Asteroids " + _numAsteroids)
            }
        }
        function onAsteroidDestroyed(){
            _numAsteroids--;
            //console.log("# Asteroids " + _numAsteroids)
        }
    }

    Timer{
        id: _starSpawner
        repeat: running; interval: 100; running: gameScene.running
        onTriggered: {
                        _starComp.createObject(gameScene.room);
        }
    }

    on_NumAsteroidsChanged: {
        if(_numAsteroids == 0)
           _asteroidSpawner.running = true;
    }


    Timer{
        id: _difficulty
        repeat: true; interval: 10000; running: _asteroidSpawner.running
        onTriggered: {
            _asteroidSpawner.running = false;
            _asteroidsPerSeconds++;
            stage++;
            //console.log("NEW Stage: " + stage)
        }
    }

    Component
    {
        id: _asteroidComp
        Asteroid{
            xWu: _asteroidFactory.xWu + Math.random() * (_asteroidFactory.widthWu - widthWu)
            yWu: _asteroidFactory.yWu - 2 * _asteroidFactory.heightWu
            linearVelocity.y: 15 + Math.random() * (_asteroidFactory.stage + 1) - theGameCtrl.axisY * 15
        }
    }

    Component
    {
        id: _starComp
        Star{
            xWu: _asteroidFactory.xWu + Math.random() * (_asteroidFactory.widthWu - widthWu)
            yWu: _asteroidFactory.yWu - 2 * _asteroidFactory.heightWu
            linearVelocity.y: 3 + Math.random() - theGameCtrl.axisY * 5
        }
    }
}
