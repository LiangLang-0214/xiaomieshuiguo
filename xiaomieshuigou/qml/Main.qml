import Felgo 3.0
import QtQuick 2.0

GameWindow{
    id:gameWindow
    activeScene: Scene

    screenWidth:640
    screenHeight: 960

    //onSplashScreenFinished: scene.startGame()
    FontLoader{
    id:gameFont
    source: "../assets/fonts/akaDylan Plain.ttf"
}
    EntityManager {
       id: entityManager
       entityContainer: gameScene
    }
    TitleScene{
        id:titleWindow
        onPlayClicked :{
            gameWindow.state = "game"
            gameScene.restartGame()
        }
        onContinuePlay: {
            gameWindow.state = "game"
            gameScene.startGame()
        }
    }
    GameScene{
        id:gameScene
            onTitleScenePressed:{
            gameWindow.state = "menu"
            //gameScene.stop()
        }
    }

    state:"meun"

    states:[
        State{
            name:"meun"
            PropertyChanges{
                target: titleWindow
                opacity:1
            }
        },
        State{
            name:"game"
            PropertyChanges{
                target:gameScene
                opacity:1
            }
        }

    ]
}


