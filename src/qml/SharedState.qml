import QtQuick
import QtQuick.LocalStorage
import Clayground.Common
import Clayground.Storage

import "details"

Item {
    id: gameState

    Component.onCompleted: load();

    // PROGRESS/SCORE/ACHIEVEMENTS
    property string level: "level"
    property int score: 0
    property int _highScore: 0

    // SOUND/MUSIC
    property bool muteSound: false
    property bool muteMusic: false

    //VISUAL
    property int fontPixelSize: 10
    property int safeTopMargin: 10
    property int buttonWidth: 100
    property string screenBgColor: "#96d6d5ff"

    // Color pallette
    readonly property color cBLUE: "#0881cd"
    readonly property color cGREEN: "#00bc58"
    readonly property color cYELLOW: "#fcf532"
    readonly property color cORANGE: "#f6a229"
    readonly property color cRED: "#ef281e"
    readonly property color cBLACK: "#1a1a1a"
    readonly property color cWHITE: "#fcfcfc"

    // PERSISTENCE
    function load() {gameStorage.load();}
    function save() {gameStorage.save();}

    // This store is created in an app home dir
    KeyValueStore {
        id: gameStorage
        name: "game-storage"
        readonly property string _cHIGH_SCORE: "highscore";

        function initOnDemand(force) {
            if (!has(_cHIGH_SCORE)) {
                gameStorage.set(_cHIGH_SCORE, 0);
            }
        }

        function load() {
            initOnDemand();
            gameState._highScore = gameStorage.get(_cHIGH_SCORE);
        }

        function save() {
            if (score > _highScore) _highScore = score;
            gameStorage.set(_cHIGH_SCORE, gameState._highScore);
        }
    }
}

