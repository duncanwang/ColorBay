pragma solidity ^0.4.18;

interface token {
    function transfer(address receiver, uint amount);
}

contract Crowdsale {

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

    /**
     * 构造函数, 设置相关属性
     */
    constructor(
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint durationInMinutes,
        uint finneyCostOfEachToken,
        address addressOfTokenUsedAsReward) {
            beneficiary = ifSuccessfulSendTo;
            fundingGoal = fundingGoalInEthers * 1 ether;
            deadline = now + durationInMinutes * 1 minutes;
            price = finneyCostOfEachToken * 1 finney;
            tokenReward = token(addressOfTokenUsedAsReward);   // 传入已发布的 token 合约的地址来创建实例
    }

    /**
     * 无函数名的Fallback函数，
     * 在向合约转账时，这个函数会被调用
     */
    function () payable {
        require(!crowdsaleClosed);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        /* amount需要乘以1 ether */
        tokenReward.transfer(msg.sender, amount * 1 ether / price);
        FundTransfer(msg.sender, amount, true);
    }

    /**
     *  定义函数修改器modifier（作用和Python的装饰器很相似）
     * 用于在函数执行前检查某种前置条件（判断通过之后才会继续执行该方法）
     * _ 表示继续执行之后的代码
     */
    modifier afterDeadline() { if (now >= deadline) _; }

    /**
     * 判断众筹是否完成融资目标， 这个方法使用了afterDeadline函数修改器
     */
    function checkGoalReached() afterDeadline {
        if (amountRaised >= fundingGoal) {
            fundingGoalReached = true;
            GoalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
    }


    /**
     * 完成融资目标时，融资款发送到募资方
     * 未完成融资目标时，执行退款
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
