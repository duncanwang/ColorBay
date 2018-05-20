pragma solidity ^0.4.18;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Ownable {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

interface token {
    function transfer(address receiver, uint amount);
}

contract ColorBaySale is Ownable {
    using SafeMath for uint256;
    address public beneficiary;
    uint public fundingGoal;
    uint public amountRaised;
    uint public deadline;
    uint public price;
    token public tokenReward;
    mapping(address => uint256) public balanceOf;
    bool public fundingGoalReached = false;
    bool public crowdsaleClosed = false;

    event GoalReached(address recipient, uint totalAmountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution);


    address[] public funder;

    modifier afterDeadline() {
      require(now >= deadline);
      _;
    }

    constructor(
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint finneyCostOfEachToken,
        address addressOfTokenUsedAsReward) public {
            beneficiary = ifSuccessfulSendTo;
            fundingGoal = fundingGoalInEthers.mul(1 ether);
            deadline = now + durationInMinutes.mul(1 minutes);
            price = finneyCostOfEachToken.mul(1 finney);
            tokenReward = token(addressOfTokenUsedAsReward);
    }

    event LogPay(address sender, uint value, uint blance, uint amount, bool isClosed);
    function () public payable {
        require(!crowdsaleClosed);
        funder.push(msg.sender);
        balanceOf[msg.sender] = balanceOf[msg.sender].add(msg.value);
        amountRaised = amountRaised.add(msg.value);
        if(amountRaised >= fundingGoal) {
            crowdsaleClosed = true;
            fundingGoalReached = true;
        }
        emit LogPay(msg.sender, msg.value, balanceOf[msg.sender], amountRaised, crowdsaleClosed);
    }

    function getThisBalance() public constant returns (uint) {
        return address(this).balance;
    }

    function getNow() public constant returns (uint, uint) {
        return (now, deadline);
    }

    function setDeadline(uint minute) public onlyOwner {
        deadline = minute.mul(1 minutes).add(now);
    }

    function safeWithdrawal() public onlyOwner afterDeadline {
        if(amountRaised >= fundingGoal) {
            crowdsaleClosed = true;
            fundingGoalReached = true;
            emit GoalReached(beneficiary, amountRaised);
        } else {
            crowdsaleClosed = false;
            fundingGoalReached = false;
        }
        uint i;
        if(fundingGoalReached) {
            if(amountRaised > fundingGoal && funder.length>0) {
                address returnFunder = funder[funder.length.sub(1)];
                uint overFund = amountRaised.sub(fundingGoal);
                if(returnFunder.send(overFund)) {
                    balanceOf[returnFunder] = balanceOf[returnFunder].sub(overFund);
                    amountRaised = fundingGoal;
                }
            }
            for(i = 0; i < funder.length; i++) {
                tokenReward.transfer(funder[i], balanceOf[funder[i]].mul(1 ether).div(price));
                balanceOf[funder[i]] = 0;
            }
            if (beneficiary.send(amountRaised)) {
                emit FundTransfer(beneficiary, amountRaised, false);
            } else {
                fundingGoalReached = false;
            }

        } else {
            for(i = 0; i < funder.length; i++) {
                if (balanceOf[funder[i]] > 0 && funder[i].send(balanceOf[funder[i]])) {
                    amountRaised = 0;
                    balanceOf[funder[i]] = 0;
                    emit FundTransfer(funder[i], balanceOf[funder[i]], false);
                }
            }
        }
    }

}
