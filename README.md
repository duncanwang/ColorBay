# ColorBay 
## 基于Ethereum开发的全球数字绘画资产平台

### 合约目录
```
contracts
    ├── Colorbay.sol	    通证合约
    ├── Colorbay.min.sol	通证合约压缩版
    ├── ColorbayCrowdsale.sol	    众筹合约
    └── ColorbayCrowdsale.min.sol	众筹合约压缩版
```

### 安装说明
更新中...

### 修改日志
Crowdsale.sol 122行，修改require(_weiAmount != 0);为require(_weiAmount >= 0.01 ether);
激励分配表可用注释的形式写到合约中，参考Loopring (LRC)

### 参考
Zilliqa (ZIL)币
https://etherscan.io/address/0x05f4a42e251f2d52b8ed15e9fedaacfcef1fad27#code
点评：参考了zeppelin，但主合约中的changeAdmin有点画蛇添足

Aeternity (AE)币
https://etherscan.io/address/0x5ca9a71b1d01849c0a95490cc00559717fcf0d1d#code
点评：冻结2年，才可以交易
uint nYears = 2;
transferableUntil = now + (60 * 60 * 24 * 365 * nYears);
...
assert(now <= transferableUntil);

Maker (MKR)币
https://etherscan.io/address/0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2#code
点评：参考了DAPPHUB，setName可以修改代币简称，可增燃

BAT (BAT)币
https://etherscan.io/address/0x0d8775f648430679a709e98d2b0cb6250d2887ef#code
点评：众筹和基础合约在一起，5KW做为众筹池，可结束众筹拿到ETH，可退还ETH

Reputation (REP)币
https://etherscan.io/address/0x1985365e9f78359a9B6AD760e32412f4a445E862#code
点评：居然没有验证token代码，也就是源码是不显示的，但交易正常

Bytom (BTM)币
https://etherscan.io/address/0xcb97e65f07da24d46bcdd078ebebd7c6e6e3d750#code
点评：具有扩展性的函数approveAndCall，手工签名，值得借鉴

Pundi X Token (NPXS)币
https://etherscan.io/address/0xa15c7ebe1f07caf6bff097d8a589fb8ac49ae5b3#code
点评：主要是众筹合约，通过增发的形式来发行代币，有转账通知transferAndCall，参考了zeppelin

 Walton (WTC)币
 https://etherscan.io/address/0xb7cb1c96db6b22b0d3d9536e0108d062bd488f74#code
 点评：典型ERC20合约，简洁

Golem (GNT)币
 https://etherscan.io/address/0xa74476443119A942dE498590Fe1f2454d7D4aC0d#code
点评：兑换比例1:1000，有合约升级功能migrate，也可以理解成映射功能，有预挖矿，按时间锁定6个月，众筹（结束、退还）
unlockedAt = now + 6 * 30 days;

RHOC (RHOC)币
https://etherscan.io/address/0x168296bb09e24a88805cb9c33356536b980d3fc5#code
点评：典型ERC20合约，简洁，安全库，禁用了匿名回调函数

Populous (PPT)币
https://etherscan.io/address/0xd4fa1460f537bb9085d22c7bccb5dd450ef28e3a#code
点评：有合约升级功能UpgradeAgent，比较详细，增发，众筹

StatusNetwork (SNT)币
https://etherscan.io/address/0x744d70fdbe2ba4cf95131626614a1763df805b9e#code
点评：TokenController功能挺强大，有点小复杂
/// @dev Internal function to determine if an address is a contract
    /// @param _addr The address being queried
    /// @return True if `_addr` is a contract
    function isContract(address _addr) constant internal returns(bool) {
        uint size;
        if (_addr == 0) return false;
        assembly {
            size := extcodesize(_addr)
        }
        return size>0;
    }

 DGD (DGD)币
 https://etherscan.io/address/0xe0b7927c4af23765cb51314a0e0521a9645f0e2a#code
 点评：基础合约、众筹、配置接口，好像也是为了升级做了许多代码

 IOSToken (IOST)币
 https://etherscan.io/address/0xfa1a856cfa3409cfa145fa4e20eb270df3eb21ab#code
 点评：典型ERC20合约，简洁，RegularToken，UnboundedRegularToken 
contract IOSToken is UnboundedRegularToken {...}

HuobiToken (HT)币
https://etherscan.io/address/0x6f259637dcd74c767781e37bc6133cd6a68aa161#code
点评：跟IOST币的合约有点相似，都有RegularToken，UnboundedRegularToken 

AION (AION)币
https://etherscan.io/address/0x4CEdA7906a5Ed2179785Cd3A40A69ee8bc99C466#code
点评：运算库中没有除法函数，把所有事件写到了一个独立合约EventDefinitions，有索赔（用户自己操作），要研究一下索赔

Nebulas (NAS)币
https://etherscan.io/address/0x5d65D971895Edc438f465c17DB6992698a52318D#code
点评：众筹和基础合约在一起，有升级合约接口migrate

 Loopring (LRC)币
https://etherscan.io/address/0xef68e7c694f40c8202821edf525de3782458639f#code
点评：众筹和基础合约在一起，最低筹集5w ETH,最高12w ETH，兑换比例1:5000

