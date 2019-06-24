import Felgo 3.0
import QtQuick 2.0

// EMPTY SCENE

Scene{
    id:scene
   // activeScene: Scene
    opacity: 0

    signal titleScenePressed()
    property int score
    property  double coefficient


    BackgroundImage{
        id:gamebackground
        source: "../assets/JuicyBackground.png"
        anchors.centerIn: scene.gameWindowAnchorItem
    }

    EntityManager {
       id: entityManager
       entityContainer: gameArea
    }
    Image {
               id:home
               width: 52
               height: 45
               source: "../assets/HomeButton.png"
               anchors.bottom: parent.bottom
               anchors.left: parent.left
               MouseArea{
                   anchors.fill: parent
                   onClicked: titleScenePressed()

             }
             visible: opacity > 0
             enabled: opacity == 1

             Behavior on opacity {
                 PropertyAnimation{ duration: 200}
             }


           }
    Text{
        font.family: gameFont.name
        font.pixelSize: 12
        color: "red"
        text: scene.score
        anchors.horizontalCenter: parent.horizontalCenter
        y:445
    }
    GameArea {
       id: gameArea
       anchors.horizontalCenter: scene.horizontalCenter
       blockSize: 20
       y: 21
       onNextGame: nextGameWindow.show()
       onGameOver: gameOverWindow.show()
     }
   NextGameWindow {
           id: nextGameWindow
           y: 90
           opacity: 0
           anchors.horizontalCenter: scene.horizontalCenter
           onNewGameClicked: scene.startGame()
         }
   GameOverWindow {
           id: gameOverWindow
           y: 90
           opacity: 0
           anchors.horizontalCenter: scene.horizontalCenter
           onNewGameClicked: scene.restartGame()
         }


     function startGame() {
       nextGameWindow.hide()
       gameOverWindow.hide()
       gameArea.initializeField()
       scene.score = 0
     }
     function restartGame() {
       gameArea.maxTypes = 2
       nextGameWindow.hide()
       gameOverWindow.hide()
       gameArea.initializeField()
       scene.score = 0
     }
  }


