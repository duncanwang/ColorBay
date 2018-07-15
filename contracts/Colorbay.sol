pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol'; //StandardToken、Pausable
import 'openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol'; //StandardToken、Ownable
import 'openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol'; //BasicToken

contract Colorbay is PausableToken,MintableToken,BurnableToken {
    string public name;
    string public symbol;
    uint256 public decimals = 18;
    
    //"1000000000","Colorbay","CLB"
    constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
        totalSupply_ = initialSupply * 10 ** uint256(decimals);
        balances[msg.sender] = totalSupply_;
        name = tokenName;
        symbol = tokenSymbol;
    }

}

