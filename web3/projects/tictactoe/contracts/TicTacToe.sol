// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

contract TicTacToe {
  enum GameStatus {
    WIN,
    TIE,
    IN_PROGRESS,
    WAITING_FOR_OPPONENT
  }

  struct Game {
    address playerOne;
    address playerTwo;
    bool playerOneTurn;
    uint256 wager;
    bool gameStarted;
    GameStatus gameState;
    uint8[9] gameData;
    address winner;
  }

  uint8[3][8] private winningCombos = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];

  Game[] public games;

  event GameJoined(uint256 gameIndex, address playerAddress, uint256 wager);
  event MoveMade(uint256 gameIndex, uint8 playerMark, uint8 squareIndex);
  event GameOver(uint256 gameIndex, address winner, GameStatus result);

  function getBoardState(
    uint256 gameIndex
  ) public view returns (uint8[9] memory) {
    return games[gameIndex].gameData;
  }

  function getWaitingGameIndices() public view returns (uint256[] memory) {
    uint256 waitingGameCount = 0;

    // Determine the number of waiting games
    for (uint256 i = 0; i < games.length; i++) {
      if (games[i].gameState == GameStatus.WAITING_FOR_OPPONENT) {
        waitingGameCount++;
      }
    }

    // Create a new array to hold the waiting game indices
    uint256[] memory waitingGameIndices = new uint256[](waitingGameCount);

    // Loop through the games array and add waiting game indices to the new array
    uint256 waitingGameIndex = 0;
    for (uint256 i = 0; i < games.length; i++) {
      if (games[i].gameState == GameStatus.WAITING_FOR_OPPONENT) {
        waitingGameIndices[waitingGameIndex] = i;
        waitingGameIndex++;
      }
    }

    // Return the array of waiting game indices
    return waitingGameIndices;
  }

  function getGame(uint64 gameIndex) public view returns (Game memory) {
    return games[gameIndex];
  }

  function startGame() public payable {
    require(msg.value >= 20000000000000000, "You must wager atleast 0.02 ETH");
    uint8[9] memory gameData;
    games.push(
      Game(
        msg.sender,
        address(0),
        true,
        msg.value,
        false,
        GameStatus.WAITING_FOR_OPPONENT,
        gameData,
        address(0)
      )
    );
    uint256 gameIndex = games.length - 1;
    emit GameJoined(
      gameIndex,
      msg.sender,
      msg.value
    );
  }

  function joinGame(uint64 gameIndex) public payable {
    Game memory gameData = games[gameIndex];
    require(
      msg.value == gameData.wager,
      "You must wager the same as your opponent"
    );
    require(msg.sender != gameData.playerOne, "You cannot join your own game");
    games[gameIndex].playerTwo = msg.sender;
    games[gameIndex].gameState = GameStatus.IN_PROGRESS;
    games[gameIndex].gameStarted = true;
    emit GameJoined(
      gameIndex, 
      msg.sender,
      msg.value
    );
  }

  function createOrJoinGame() public payable returns (uint256) {
      // Look for a waiting game with the same wager as the input
      for (uint256 i = 0; i < games.length; i++) {
          if (games[i].gameState == GameStatus.WAITING_FOR_OPPONENT && msg.sender != games[i].playerOne && games[i].wager == msg.value) {
              joinGame(uint64(i));
              return i;
          }
      }
      // No waiting game with the same wager was found, so create a new one
      startGame();
      uint256 gameIndex = games.length - 1;
      return gameIndex;
  }
  // This function takes a game index and a player boolean as inputs and returns the status of the game.
  function getGameState(uint64 gameIndex, bool playerOne) private view returns (GameStatus) {
      if(games[gameIndex].gameState == GameStatus.WAITING_FOR_OPPONENT){
        return GameStatus.WAITING_FOR_OPPONENT;
      }
      // Retrieve the game data for the given index.
      uint8[9] memory gameData = games[gameIndex].gameData;
      // Determine the player mark based on the player boolean.
      uint8 playerMark;
      if (playerOne) {
          playerMark = 1;
      } else {
          playerMark = 2;
      }
      // Initialize a boolean variable to track if a win is possible.
      bool winPossible = false;
      // Loop through all the winning combos to check for a possible win.
      for (uint8 comboIndex = 0; comboIndex < 8; comboIndex++) {
          // Retrieve the current winning combo.
          uint8[3] memory winningCombo = winningCombos[comboIndex];
          // Initialize variables to track how many squares match the current player, how many match the other player, and how many are blank.
          uint8 currentPlayerGameSquaresMatchingWinningCombo = 0;
          uint8 otherPlayerGameSquaresMatchingWinningCombo = 0;
          uint8 winningComboSquaresBlank = 0;
          // Loop through each square in the winning combo and update the above variables based on its value.
          for (uint8 comboSquareIndex = 0; comboSquareIndex < 3; comboSquareIndex++) {
              uint8 gameSquare = gameData[winningCombo[comboSquareIndex]];
              if (gameSquare == playerMark) {
                  currentPlayerGameSquaresMatchingWinningCombo += 1;
              } else if (gameSquare == 0) {
                  winningComboSquaresBlank += 1;
              } else {
                  otherPlayerGameSquaresMatchingWinningCombo += 1;
              }
          }
          // If all three squares in the winning combo match the current player's mark, return the "WIN" status.
          if (currentPlayerGameSquaresMatchingWinningCombo == 3) {
              return GameStatus.WIN;
          } else if (currentPlayerGameSquaresMatchingWinningCombo + winningComboSquaresBlank == 3 || 
                    otherPlayerGameSquaresMatchingWinningCombo + winningComboSquaresBlank == 3) {
              // If the current player can still win or the game can still be tied, set winPossible to true.
              winPossible = true;
          }
      }
      // If winPossible is true, return the "IN_PROGRESS" status. Otherwise, return the "TIE" status.
      if (winPossible) {
          return GameStatus.IN_PROGRESS;
      } else {
          return GameStatus.TIE;
      }
  }
  function makeMove(uint8 position, uint64 gameIndex) public {
    Game storage gameData = games[gameIndex];
    require(gameData.gameData[position] == 0, "That spot is already taken");
    require(gameData.gameState == GameStatus.IN_PROGRESS || gameData.gameState == GameStatus.WAITING_FOR_OPPONENT, "This game is over");

    address player = msg.sender;
    address currentPlayer = gameData.playerOneTurn
      ? gameData.playerOne
      : gameData.playerTwo;
    require(player == currentPlayer, "It is not your turn");

    uint8 playerMark = gameData.playerOneTurn ? 1 : 2;
    gameData.gameData[position] = playerMark;
    emit MoveMade(gameIndex, playerMark, position);
    gameData.playerOneTurn = !gameData.playerOneTurn;

    GameStatus gameState = getGameState(gameIndex, !gameData.playerOneTurn);
    gameData.gameState = gameState;
    if (gameState == GameStatus.WIN) {
      payable(player).transfer(gameData.wager * 2);
      emit GameOver(gameIndex, player, gameState);
      gameData.winner = player;
    } else if (gameState == GameStatus.TIE) {
      payable(gameData.playerOne).transfer(gameData.wager);
      payable(gameData.playerTwo).transfer(gameData.wager);
      emit GameOver(gameIndex, player, gameState);
    }
  }
}
