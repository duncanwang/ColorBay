var Colorbay = artifacts.require("./Colorbay.sol");


module.exports = function(deployer) {
    //uint256 initialSupply, string tokenName, string tokenSymbol
    deployer.deploy(Colorbay, '1000000000', 'Colorbay', 'CLB'); //注意，如果合约构造函数需要传递参数，从第二个位置开始增加参数 
};