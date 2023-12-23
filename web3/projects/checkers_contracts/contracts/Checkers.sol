// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract CheckersGame {
  enum GameState { 
      NotStarted, // Game has not started
      InProgress, // Game is in progress
      RedWins,     // Red player has won
      BlackWins,   // Black player has won
      Draw         // The game ended in a draw
  }
  struct Game {
    address blackPlayer;
    address redPlayer;
    uint8[8][8] board;
    GameState state;
    uint256 wager;
  }

  Game[] public games;

  //Wager amount => array of game indices for the games array for unstarted games
  mapping(uint256 => uint64[]) public unstartedGamesByWager;

  function joinOrCreateGame(uint256 wager) public payable returns (uint256) {
      // Find the array of unstarted games with the specified wager amount
      uint64[] storage unstartedGames = unstartedGamesByWager[wager];
      
      // Check if there are any unstarted games with this wager amount
      if (unstartedGames.length > 0) {
          // Join an existing game
          uint256 gameIndex = unstartedGames[0];
          Game storage game = games[gameIndex];
          require(game.state == GameState.NotStarted, "Game has already started");
          require(msg.sender != game.redPlayer, "You are already the red player");
          require(msg.value == wager, "Invalid wager amount");
          
          // Assign the black player
          game.blackPlayer = msg.sender;
          game.state = GameState.InProgress;
          
          // Remove the game from the array of unstarted games
          unstartedGames[0] = unstartedGames[unstartedGames.length - 1];
          unstartedGames.pop();
          
          // Return the index of the game
          return gameIndex;
      } else {
          // Create a new game
          Game memory game = Game({
              blackPlayer: msg.sender,
              redPlayer: address(0),
              board: generateStartingBoard(),
              state: GameState.NotStarted,
              wager: wager
          });
          uint256 gameIndex = games.length;
          games.push(game);
          
          // Add the new game to the array of unstarted games
          unstartedGames.push(uint64(gameIndex));
          
          // Return the index of the new game
          return gameIndex;
      }
  }

  function generateStartingBoard() internal pure returns (uint8[8][8] memory) {
      // Generate a standard starting board for checkers
      uint8[8][8] memory board;
      for (uint i = 0; i < 8; i++) {
          for (uint j = 0; j < 8; j++) {
              if ((i + j) % 2 == 1) {
                  if (i < 3) {
                      board[i][j] = 1;
                  } else if (i > 4) {
                      board[i][j] = 2;
                  }
              }
          }
      }
      return board;
  }
}