import Felgo 3.0
import QtQuick 2.0

Item {

    id: gameArea

    width: blockSize * 13
    height: blockSize * 18

       property double blockSize
       property int rows: Math.floor(height / blockSize)
       property int columns: Math.floor(width / blockSize)
       property int maxTypes:2
       property double coefficient:1.15//xishu

       // array for handling game field
       property var field: []

       // game over signal

       signal nextGame()
       signal gameOver()


       // calculate field index
       function index(row, column) {
         return row * columns + column
       }

       // fill game field with blocks
       function initializeField() {
           if(gameArea.maxTypes<=7)
          gameArea.maxTypes++
         gameArea.coefficient =gameArea.coefficient - 0.1
         clearField()

         // fill field
         for(var i = 0; i < rows; i++) {
           for(var j = 0; j < columns; j++) {
             gameArea.field[index(i, j)] = createBlock(i, j)
           }
         }
       }

       // clear game field
       function clearField() {
         // remove entities
         for(var i = 0; i < gameArea.field.length; i++) {
           var block = gameArea.field[i]
           if(block !== null)  {
             entityManager.removeEntityById(block.entityId)
           }
         }
         gameArea.field = []
       }

       // create a new block at specific position
       function createBlock(row, column) {
         // configure block
         var entityProperties = {
           width: blockSize,
           height: blockSize,
           x: column * blockSize,
           y: row * blockSize,

           type: Math.floor(Math.random() * gameArea.maxTypes), // random type
           row: row,
           column: column
         }

         // add block to game area
         var id = entityManager.createEntityFromUrlWithProperties(
               Qt.resolvedUrl("Block.qml"), entityProperties)

         // link click signal from block to handler function
         var entity = entityManager.getEntityById(id)
         entity.clicked.connect(handleClick)

         return entity
       }

       //处理用户点击
       function handleClick(row, column, type) {

        var fieldCopy = field.slice()

       var blockCount = getNumberOfConnectedBlocks(fieldCopy,row,column,type)
           if(blockCount>=2){
               removeConnectedBlocks(fieldCopy)
               moveBlocksToBottom()
               var score = blockCount * (blockCount + 1) / 2
                      scene.score += score
               if(isNextGame()){
                   if(scene.score<=3600*gameArea.coefficient/ gameArea.maxTypes)
                       return gameOver()
                   else
                       return nextGame()
               }
               }
           }

       function getNumberOfConnectedBlocks(fieldCopy, row, column, type) {
               if(row>=rows||column>=columns||row<0||column<0)
                   return 0

               var block = fieldCopy[index(row,column)]
               if(block === null)
                   return 0
               if(block.type !== type)
                   return 0
               var count = 1
               fieldCopy[index(row, column)] = null
               count += getNumberOfConnectedBlocks(fieldCopy, row + 1, column, type)
                   count += getNumberOfConnectedBlocks(fieldCopy, row, column + 1, type)
                   count += getNumberOfConnectedBlocks(fieldCopy, row - 1, column, type)
                   count += getNumberOfConnectedBlocks(fieldCopy, row, column - 1, type)
               return count
       }
        function removeConnectedBlocks(fieldCopy) {
             for(var i = 0; i < fieldCopy.length; i++) {
               if(fieldCopy[i] === null) {
                 var block = gameArea.field[i]
                 if(block !== null) {
                   gameArea.field[i] = null
                  // entityManager.removeEntityById(block.entityId)
                    block.remove()
                 }
               }
             }
           }
        function moveBlocksToBottom() {
             // check all columns for empty fields
             for(var col = 0; col < columns; col++) {

               // start at the bottom of the field
               for(var row = rows - 1; row >= 0; row--) {

                 // find empty spot in grid
                 if(gameArea.field[index(row, col)] === null) {

                   // find block to move down
                   var moveBlock = null
                   for(var moveRow = row - 1; moveRow >= 0; moveRow--) {
                     moveBlock = gameArea.field[index(moveRow,col)]

                     if(moveBlock !== null) {
                       gameArea.field[index(moveRow,col)] = null
                       gameArea.field[index(row, col)] = moveBlock
                       moveBlock.row = row
                       moveBlock.fallDown(row - moveRow)
                       //moveBlock.y = row * gameArea.blockSize
                       break
                     }
                  }
               }
             }
        }
       }
        function isNextGame() {
            var nextGame = true
            var gameOver = true
            var score
            // copy field to search for connected blocks without modifying the actual field
            var fieldCopy = field.slice()

            // search for connected blocks in field
            for(var row = 0; row < rows; row++) {
              for(var col = 0; col < columns; col++) {

                // test all blocks
                var block = fieldCopy[index(row, col)]
                if(block !== null) {
                  var blockCount = getNumberOfConnectedBlocks(fieldCopy, row, col, block.type)

                  if(blockCount >= 2) {
                    nextGame = false
                    gameOver = false
                    break
                  }
                }

              }
            }
            if(scene.score<=3600*gameArea.coefficient/gameArea.maxTypes)
                return gameOver
            else
            return nextGame
          }


}

