const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { network } = require("hardhat") 
const { verify } = require("../utils/verify")

module.exports.default = async ({ getNamedAccounts, deployments }) =>{
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = network.config.chainId

  let ethUsdPriceFeedAddress;
  if(developmentChains.includes(network.name)){
    const ethUsdAggrgator = await deployments.get("MockV3Aggregator")
    ethUsdPriceFeedAddress = ethUsdAggrgator.address
  } else {
    ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
  }
  const args = [ethUsdPriceFeedAddress]
  const fundMe = await deploy("FundMe", {
    from: deployer,
    args: [ethUsdPriceFeedAddress],//constructor arguments
    log: true
  })
  // if(!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY){
  //   await verify(fundMe.address, args)
  // }
  log("----------------------------")
}  

module.exports.tags = ["all", "fundme"]