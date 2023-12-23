const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect, assert } = require("chai");
describe("TicTacToe", function () {
  let ticTacToe;
  let playerOne;
  let playerTwo;
  let gameIndex;

  beforeEach(async function () {
    const TicTacToe = await ethers.getContractFactory("TicTacToe");
    ticTacToe = await TicTacToe.deploy();
    await ticTacToe.deployed();

    [playerOne, playerTwo] = await ethers.getSigners();
    await ticTacToe.connect(playerOne).createOrJoinGame({ value: ethers.utils.parseEther("0.02") });
    const waitingGameIndices = await ticTacToe.getWaitingGameIndices();
    gameIndex = waitingGameIndices[0];
    transaction = await ticTacToe.connect(playerTwo).createOrJoinGame({ value: ethers.utils.parseEther("0.02") });
  });

  it("should start a new game and return game data correctly", async function () {
    const gameData = await ticTacToe.getGame(gameIndex);
    expect(gameData.playerOne).to.equal(playerOne.address);
    expect(gameData.playerTwo).to.equal(playerTwo.address);
    expect(gameData.playerOneTurn).to.equal(true);
    expect(gameData.wager).to.equal(ethers.utils.parseEther("0.02"));
    expect(gameData.gameStarted).to.equal(true);
    expect(gameData.gameState).to.equal(2);
    expect(gameData.gameData).to.deep.equal([
      0, 0, 0,
      0, 0, 0,
      0, 0, 0,
    ]);
  });

  it("should not allow a player to join a game with insufficient funds", async function () {
    const [insufficientFundsPlayer] = await ethers.getSigners();
    await expect(
      ticTacToe.connect(insufficientFundsPlayer).joinGame(gameIndex, { value: ethers.utils.parseEther("0.01") })
    ).to.be.revertedWith("You must wager the same as your opponent");
  });

  it("should not allow a player to make a move on an occupied square", async function () {
    await expect(
      ticTacToe.connect(playerOne).makeMove(0, gameIndex)
    ).to.not.be.reverted;
    await expect(
      ticTacToe.connect(playerTwo).makeMove(0, gameIndex)
    ).to.be.revertedWith("That spot is already taken");
  });

  it("should declare the correct game state when there is a winner", async function () {
    await ticTacToe.connect(playerOne).makeMove(0, gameIndex);
    await ticTacToe.connect(playerTwo).makeMove(3, gameIndex);
    await ticTacToe.connect(playerOne).makeMove(1, gameIndex);
    await ticTacToe.connect(playerTwo).makeMove(4, gameIndex);
    await ticTacToe.connect(playerOne).makeMove(2, gameIndex);
    const gameData = await ticTacToe.getGame(gameIndex);
    expect(gameData.gameState).to.equal(0);
  });

});