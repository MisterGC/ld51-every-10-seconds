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
        id: _spawner
        repeat: running; interval: 1000; running: gameScene.running
        onTriggered: {
            let color = _colorPalette[_asteroidFactory.stage % _asteroidFactory._colorPalette.length]
            for (let i=0; i < _asteroidsPerSeconds; ++i)
            {
                let e = _asteroidComp.createObject(gameScene.room, {"color": color});
                e.Component.destruction.connect(_ => {_spawner.onAsteroidDestroyed();});
                _numAsteroids++;
                //console.log("# Asteroids " + _numAsteroids)
            }
        }
        function onAsteroidDestroyed(){
            _numAsteroids--;
            //console.log("# Asteroids " + _numAsteroids)
        }
    }

    on_NumAsteroidsChanged: {
        if(_numAsteroids == 0)
           _spawner.running = true;
    }


    Timer{
        id: _difficulty
        repeat: true; interval: 10000; running: _spawner.running
        onTriggered: {
            _spawner.running = false;
            _asteroidsPerSeconds++;
            stage++;
            //console.log("NEW Stage: " + stage)
        }
    }


    property real yDirDesire: theGameCtrl.axisY
    linearVelocity.y: 0//yDirDesire * veloCompMax


    Component
    {
        id: _asteroidComp
        Asteroid{
            xWu: _asteroidFactory.xWu + Math.random() * (_asteroidFactory.widthWu - widthWu)
            yWu: _asteroidFactory.yWu - 2 * _asteroidFactory.heightWu
            linearVelocity.y: 10 + Math.random() * (_asteroidFactory.stage + 1) - theGameCtrl.axisY * 10
        }
    }
}
