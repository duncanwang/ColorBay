pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol'; //StandardToken、Pausable
import 'openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol'; //StandardToken、Ownable
import 'openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol'; //BasicToken


/**
 * @title Colorbay Token
 * @dev Global digital painting asset platform token.
 */
contract Colorbay is PausableToken, MintableToken, BurnableToken {
    using SafeMath for uint256;

    string public name = "Colorbay Token";
    string public symbol = "CLB";
    uint256 public decimals = 18;
    uint256 INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));

    event UpdatedTokenInformation(string name, string symbol);

    mapping (address => bool) public frozenAccount;
    event FrozenFunds(address target, bool frozen);

    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = totalSupply_;
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    function() public payable {
      revert(); //if ether is sent to this address, send it back.
    }  

    function transfer(address _to, uint256 _value) public returns (bool)
    {
        require(!frozenAccount[msg.sender]);
        return super.transfer(_to, _value);
    }


    function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
    {
        require(!frozenAccount[msg.sender]);
        return super.transferFrom(_from, _to, _value);
    }

    function freezeAccount(address _to, bool freeze) public onlyOwner {
        frozenAccount[_to] = freeze;
        emit FrozenFunds(_to, freeze);
    }     
    
    /**
     * @dev Update the symbol.
     * @param _tokenSymbol The symbol name.
     */
    function setTokenInformation(string _tokenName, string _tokenSymbol) public onlyOwner {
        name = _tokenName;
        symbol = _tokenSymbol;
        emit UpdatedTokenInformation(name, symbol);
    } 

}

