pragma solidity ^0.4.16;

/* 公共函数库 */
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
    function Ownable() public {
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
        /* 如果新管理员地址为空就抛出异常 */
        require(newOwner != address(0));
        /* 写入转让日志 */
        OwnershipTransferred(owner, newOwner);
        /* 修改管理员 */
        owner = newOwner;
    }

}

interface token {
    function transfer(address receiver, uint amount);
}

contract ColorBaySaleTest is Ownable {
    /* 导入安全运算库 */
    using SafeMath for uint256;

    address public beneficiary;  // 募资成功后的收款方
    uint public fundingGoal;   // 募资额度
    uint public amountRaised;   // 参与数量
    uint public deadline;      // 募资截止期

    uint public price;    //  token 与以太坊的汇率 , token卖多少钱
    token public tokenReward;   // 要卖的token

    mapping(address => uint256) public balanceOf;

    bool fundingGoalReached = false;  // 众筹是否达到目标
    bool crowdsaleClosed = false;   //  众筹是否结束

    /**
    * 事件可以用来跟踪信息
    **/
    event GoalReached(address recipient, uint totalAmountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution);

    /**
     * 构造函数, 设置相关属性
     */
    function ColorBaySaleTest(
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint finneyCostOfEachToken,
        address addressOfTokenUsedAsReward) {
            beneficiary = ifSuccessfulSendTo;
            fundingGoal = fundingGoalInEthers.mul(1 ether);
            deadline = now + durationInMinutes.mul(1 minutes);
            price = finneyCostOfEachToken.mul(1 finney);
            tokenReward = token(addressOfTokenUsedAsReward);   // 传入已发布的 token 合约的地址来创建实例
    }

    /**
     * 修改截止时间
     */
    function setTime(uint time) public onlyOwner returns (bool) {
        deadline = now.add(time.mul(1 minutes));
        return true;
    }

    /**
     * 修改募资总额
     */
    function setFundingGoal(uint numbers) public onlyOwner returns (bool) {
        require(numbers > 0);
        fundingGoal = numbers;
        return true;
    }

    /**
     * 无函数名的Fallback函数，
     * 在向合约转账时，这个函数会被调用
     */
    function () payable {
        require(!crowdsaleClosed);
        uint amount = msg.value;
        balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
        amountRaised = amountRaised.add(amount);
        tokenReward.transfer(msg.sender, SafeMath.div(amount.mul(1 ether), price));
        FundTransfer(msg.sender, amount, true);
    }

    /**
    *  定义函数修改器modifier（作用和Python的装饰器很相似）
    * 用于在函数执行前检查某种前置条件（判断通过之后才会继续执行该方法）
    * _ 表示继续执行之后的代码
    **/
    modifier afterDeadline() { if (now >= deadline) _; }

    /**
     * 判断众筹是否完成融资目标， 这个方法使用了afterDeadline函数修改器
     *
     */
    function checkGoalReached() afterDeadline {
        if (amountRaised >= fundingGoal) {
            fundingGoalReached = true;
            GoalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
    }


    /**
     * 完成融资目标时，融资款发送到收款方
     * 未完成融资目标时，执行退款
     *
     */
    function safeWithdrawal() afterDeadline {
        if (!fundingGoalReached) {
            uint amount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
            if (amount > 0) {
                if (msg.sender.send(amount)) {
                    FundTransfer(msg.sender, amount, false);
                } else {
                    balanceOf[msg.sender] = amount;
                }
            }
        }

        if (fundingGoalReached && beneficiary == msg.sender) {
            if (beneficiary.send(amountRaised)) {
                FundTransfer(beneficiary, amountRaised, false);
            } else {
                //If we fail to send the funds to beneficiary, unlock funders balance
                fundingGoalReached = false;
            }
        }
    }
}
