/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */
//module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
//};

var HDWalletProvider = require("truffle-hdwallet-provider");
var infura_apikey = "***"; // infura apikey
var mnemonic = "loan wasp endless couch melt develop cabbage sock deny tackle fringe history"; // 你以太坊钱包的 mnemonic ，可以从 Metamask 当中导出，mnemonic 可以获取你钱包的所有访问权限，请妥善保存，在开发中切勿提交到 git

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*'
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/" + infura_apikey)
      },
      network_id: '3',
      gas: 3012388,
      gasPrice: 30000000000
    },
    mainnet: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://mainnet.infura.io/" + infura_apikey)
      },
      network_id: '1',
      gas: 4500000,
      gasPrice: 10000000000
    }
    
  }
};

/*
 * 选择服务提供商
 * Mainnet	生产网络	https://mainnet.infura.io/
 * Ropsten	测试网络	https://ropsten.infura.io/
 * INFURAnet	测试网络	https://infuranet.infura.io/
 * Kovan	测试网络	https://kovan.infura.io/
 * Rinkeby	测试网络	https://rinkeby.infura.io/
 * IPFS	网关	https://ipfs.infura.io
 */
