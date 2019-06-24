import Felgo 3.0
import QtQuick 2.0

GameWindow{
    id:gameWindow
    activeScene: Scene

    screenWidth:640
    screenHeight: 960

    onSplashScreenFinished: scene.startGame()

       // for dynamic creation of entities
       EntityManager {
          id: entityManager
          entityContainer: gameArea
       }

    FontLoader{
    id:gameFont
    source: "../assets/fonts/akaDylan Plain.ttf"
}
 Scene{
    id:scene
    width: 320
    height: 480
    property  int score
    property  double coefficient

    BackgroundImage {
           source: "../assets/JuicyBackground.png"
           anchors.centerIn: scene.gameWindowAnchorItem
         }


         Text {

           font.family: gameFont.name
           font.pixelSize: 25
           color: "red"
           text: scene.score

           anchors.horizontalCenter: parent.horizontalCenter
           y: 435
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
   GameOverWinodw {
           id: gameOverWindow
           y: 90
           opacity: 0
           anchors.horizontalCenter: scene.horizontalCenter
           onNewGameClicked: scene.restartGame()
         }

     // initialize game
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
}

