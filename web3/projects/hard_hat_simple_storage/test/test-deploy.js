const { ethers } = require("hardhat")
const { expect, assert } = require("chai")
describe("SimpleStorage", () => {
  let simpleStorageFactory, simpleStorage;
  beforeEach(async function () {
    simpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
    simpleStorage = await simpleStorageFactory.deploy()
  })

  it("Should start with a favorite number of 0", async function () {
    const currentValue = await simpleStorage.retrieve()
    const expectedValue = "0"
    assert.equal(currentValue.toString(), expectedValue)
  })

  it("should update when we call store", async function(){
    const expectedValue = "7"
    const transactionResponse = await simpleStorage.store(expectedValue)
    await transactionResponse.wait(1)
    const currentValue = await  simpleStorage.retrieve()
    assert.equal(currentValue.toString(), expectedValue)
  })

  it("should add a person", async function(){
    let name = "scott"
    let favoriteNumber = 5
    let transactionResponse = await simpleStorage.addPerson("scott", 5)
    await transactionResponse.wait(1)
    let person = await simpleStorage.people(0)
    assert.equal(person['name'], name)
    assert.equal(person['favoriteNumber'], favoriteNumber)
  })
})