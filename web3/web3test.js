const Web3 = require('web3');
const abiDecode = require('abi-decoder');
const web3_bsc = new Web3('wss://boldest-neat-breeze.bsc.discover.quiknode.pro/4dd9582d85bc4a4fcdcac8dfd34893696eaec0f9/');
web3_bsc.eth.subscribe('logs',async (error, result) => {
  let tx = await web3_bsc.eth.getTransaction(result['transactionHash']);
  web3_bsc.utils.hexToString(tx.input)
  let foo = abiDecode;
  debugger;
})