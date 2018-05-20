pragma solidity ^0.4.18;

library SafeMath {

    /* 加法 */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    /* 减法 */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /* 乘法 */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /* 除法 */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

}

/**
 * @dev 合约管理员
 * 登记合约管理员地址，并可实现管理员转让
 */
contract Ownable {
    /* 管理员钱包地址 */
    address public owner;

    /* 转让管理员日志 */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev 设置合约创建者为合约管理员
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
    * @dev 仅限合约管理员操作
    */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    /**
    * @dev 将合约管理员权限转让给新管理员
    * @param newOwner 新管理员钱包地址
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
    /* 导入安全运算库 */
    using SafeMath for uint256;

    /* 募资成功后的收款方 */
    address public beneficiary;
    /* 募资额度 */
    uint public fundingGoal;
    /* 已募资额度 */
    uint public amountRaised;
    /* 募资截止期 */
    uint public deadline;
    /* token与以太坊的汇率，token卖多少钱 */
    uint public price;
    /* token实例，要卖的token */
    token public tokenReward;
    /* 投资人钱包地址、投资的ETH个数 */
    mapping(address => uint256) public balanceOf;

    /* 众筹是否达到目标 */
    bool fundingGoalReached = false;
    /* 众筹是否结束 */
    bool crowdsaleClosed = false;

    /* 事件：查询众筹是否达标 */
    event GoalReached(address recipient, uint totalAmountRaised);
    /* 事件：查询资金转移是否成功 */
    event FundTransfer(address backer, uint amount, bool isContribution);

    /* 投资人钱包地址列表，用于批量操作时遍历数组中 */
    address[] public funder;

    /* 判断众筹时间是否已经截止 */
    modifier afterDeadline() { if (now >= deadline) _; }

    constructor(
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint finneyCostOfEachToken,
        address addressOfTokenUsedAsReward) public {
            /* 募资成功后的收款方 */
            beneficiary = ifSuccessfulSendTo;
            /* 募资额度 */
            fundingGoal = fundingGoalInEthers.mul(1 ether);
            /* 募资截止期 */
            deadline = now + durationInMinutes.mul(1 minutes);
            /* token与以太坊的汇率：1:1000 */
            price = finneyCostOfEachToken.mul(1 finney);
            /* token实例，要卖的token */
            tokenReward = token(addressOfTokenUsedAsReward);
    }
    /* 定义事件：记录募资过程参数 */
    event LogPay(address sender, uint value, uint blance, uint amount, bool isClosed);
    function () public payable {
        require(!crowdsaleClosed);
        /* 登记投资人钱包地址 */
        funder.push(msg.sender);
        /* 登记投资人钱包地址、投资的ETH个数，自动换算成wei */
        balanceOf[msg.sender] = balanceOf[msg.sender].add(msg.value);
        /* 累加已募资额度 */
        amountRaised = amountRaised.add(msg.value);
        /* 如果募资达成了目标，则停止众筹 */
        if(amountRaised >= fundingGoal) {
            crowdsaleClosed = true;
            fundingGoalReached = true;
        }
        /* 事件：记录募资过程参数 */
        emit LogPay(msg.sender, msg.value, balanceOf[msg.sender], amountRaised, crowdsaleClosed);
    }

    /* 查看当前众筹合约地址募资ETH总数，用于调试，可去除 */
    function getThisBalance() public view returns (uint) {
        return this.balance;
    }

    /* 查看当前时间戳与众筹截止时间戳，用于调试，可去除 */
    function getNow() public view returns (uint, uint) {
        return (now, deadline);
    }

    /* 设置众筹截止时间到期或延长，用于调试，可去除 */
    function setDeadline(uint minute) public onlyOwner {
        deadline = minute.mul(1 minutes).add(now);
    }

    /**
     * 批量处理众筹情况
     * 如果成功，募资方收到ETH，投资人收到token
     * 如果失败，募资方退回ETH，投资人收回ETH，无token
     */
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
            /* 募资成功，如果有超额募资，退还ETH给最近一位投资人 */
            if(amountRaised > fundingGoal && funder.length>0) {
                address returnFunder = funder[funder.length.sub(1)];
                uint overFund = amountRaised.sub(fundingGoal);
                if(returnFunder.send(overFund)) {
                    balanceOf[returnFunder] = balanceOf[returnFunder].sub(overFund);
                    amountRaised = fundingGoal;
                }
            }
            /* 募资成功，批量给投资人转token */
            for(i = 0; i < funder.length; i++) {
                tokenReward.transfer(funder[i], balanceOf[funder[i]].mul(1 ether).div(price));
                balanceOf[funder[i]] = 0;
            }
            /* 募资成功，募资方收到ETH */
            if (beneficiary.send(amountRaised)) {
                emit FundTransfer(beneficiary, amountRaised, false);
            } else {
                fundingGoalReached = false;
            }

        } else {
            /* 募资失败，批量退回ETH给投资人 */
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
