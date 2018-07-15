pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol'; //SafeMath、Crowdsale


contract ColorbayCrowdsale is TimedCrowdsale {
    
    constructor(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, ERC20 _token) public {
        require(_openingTime >= block.timestamp);
        require(_closingTime >= _openingTime);

        require(_rate > 0);
        require(_wallet != address(0));
        require(_token != address(0));

        openingTime = _openingTime;
        closingTime = _closingTime;

        rate = _rate;
        wallet = _wallet;
        token = _token;
    }


}