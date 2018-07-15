
const ColorbayCrowdsale = artifacts.require('./ColorbayCrowdsale.sol');
const Colorbay = artifacts.require("./Colorbay.sol");

module.exports = function(deployer, network, accounts) {
    const openingTime = web3.eth.getBlock('latest').timestamp + 2; //部署合约后的2秒后开始
    const closingTime = openingTime + 86400 * 30; // 30天
    const rate = new web3.BigNumber(1000);
    const wallet = accounts[1];

    return deployer
        .then(() => {
            return deployer.deploy(Colorbay, '1000000000', 'Colorbay', 'CLB'); //注意，如果合约构造函数需要传递参数，从第二个位置开始增加参数 
        })
        .then(() => {
            return deployer.deploy(
                ColorbayCrowdsale,
                openingTime,
                closingTime,
                rate,
                wallet,
                Colorbay.address
            );
        });
};