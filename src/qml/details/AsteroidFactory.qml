// (c) serein.pfeiffer@gmail.com - zlib license, see "LICENSE" file

import QtQuick
import Clayground.Physics

RectBoxBody
{
    id: _asteroidFactory
    color: "transparent"
    property int _asteroidsPerSeconds: 2 + stage
    property int _numAsteroids: 0
    property int stage: 1
    readonly property color stageColor: _colorPalette[stage % _colorPalette.length]
    property var _colorPalette: [
        gameState.cBLUE,
        gameState.cGREEN,
        gameState.cORANGE,
        gameState.cRED,
        gameState.cYELLOW
    ]
    readonly property bool spawnsAsteroids: _asteroidSpawner.running

    Timer{
        id: _asteroidSpawner
        repeat: running; interval: 500; running: gameScene.running
        onTriggered: {
            for (let i=0; i < _asteroidsPerSeconds *(interval/1000); ++i)
            {
                let e = _asteroidComp.createObject(gameScene.room, {
                                                       "color": _asteroidFactory.stageColor,
                                                       "myStage": stage
                                                   });
                e.Component.destruction.connect(_ => {_asteroidSpawner.onAsteroidDestroyed();});
                _numAsteroids++;
                _starComp.createObject(gameScene.room);
            }
        }
        function onAsteroidDestroyed(){
            _numAsteroids--;
        }
    }

    Timer{
        id: _starSpawner
        repeat: running; interval: 150; running: gameScene.running
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
        }
    }

    Component
    {
        id: _asteroidComp
        Asteroid{
            xWu: _asteroidFactory.xWu + Math.random() * (_asteroidFactory.widthWu - widthWu)
            yWu: _asteroidFactory.yWu - 2 * _asteroidFactory.heightWu
            linearVelocity.y: relevant ? 15 + _asteroidFactory.stage : 100
        }
    }

    Component
    {
        id: _starComp
        Star{
            xWu: _asteroidFactory.xWu + Math.random() * (_asteroidFactory.widthWu - widthWu)
            yWu: _asteroidFactory.yWu - 2 * _asteroidFactory.heightWu
            linearVelocity.y: 3 + Math.random()
        }
    }
}
