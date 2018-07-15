pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol'; //StandardToken、Pausable
import 'openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol'; //StandardToken、Ownable
import 'openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol'; //BasicToken

contract Colorbay is PausableToken, MintableToken, BurnableToken {
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint256 public decimals = 18;
    
    //"1000000000","Colorbay","CLB"
    constructor(uint256 _initialSupply, string _tokenName, string _tokenSymbol) public {
        totalSupply_ = _initialSupply * 10 ** uint256(decimals);
        balances[msg.sender] = totalSupply_;
        name = _tokenName;
        symbol = _tokenSymbol;
    }

    /**
     * @dev Update the symbol.
     * @param _tokenSymbol The symbol name.
     */
    function setSymbol(string _tokenSymbol) public onlyOwner returns (bool) {
        symbol = _tokenSymbol;
        return true;
    }

    function() payable {
      revert();
    }

    /**
     * @dev mint timelocked tokens
     */
    function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
        onlyOwner canMint returns (TokenTimelock) {

        TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
        mint(timelock, _amount);

        return timelock;
    }

}

