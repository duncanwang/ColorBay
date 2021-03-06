# 众筹合约ColorbayCrowdsale测试用例
#### 测试功能点：创建具有固定期限的众筹合约并充值、修改众筹期限、众筹失败可退还

#### 测试数据
**代币**
- 彩贝发行总量为 1,000,000,000 个token
- 激励          占比35%，即350,000,000个token
- 私募          占比20%，即200,000,000个token
- 团队及基金会    占比25%，即250,000,000个token
- 社区培养及推广  占比20%，即200,000,000个token

---

**账号**
- 管理员 `0xca3...a733c`
- 张三  `0x147...c160c`
- 李四  `0x4b0...4d2db`
- 王五  `0x583...40225`
---
- 管理员 `0xca35b7d915458ef540ade6068dfe2f44e8fa733c`
- 张三  `0x14723a09acff6d2a60dcdf7aa4aff308fddc160c`
- 李四  `0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db`
- 王五  `0x583031d1113ad414f02576bd6afabfb302140225`

---

**初始化参数**
- 开始时间：`1531756800`（2018/7/17 00:00:00）
- 结束时间：`1534521599`（2018/8/17 23:59:59）
- 兑换比率：1 ETH : 1000 CLB
- 募集总额：20 ETH = 20% CLB， 即`200,000,000`个CLB
- 收取ETH钱包（管理员）：`0xca35b7d915458ef540ade6068dfe2f44e8fa733c`
- 代币合约地址：`0x692a70d2e424a56d2c6c27aa97d1a86395877b3a`
- 受益人：当前调用者

---

- 获取时间戳：https://unixtime.51240.com/

---

#### 用例1——创建具有固定期限的众筹合约并充值CLB

1、发行代币CLB，且将代币合约地址复制下来

2、输入以下构造函数参数，执行：
`"1531756800","1534521599","1000","0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x692a70d2e424a56d2c6c27aa97d1a86395877b3a"`

3、查询一下当前募集币数、代币合约地址、兑换比率、收ETH钱包、众筹开始时间、结束时间、是否关闭众筹
```
weiRaised()
token()
rate()
wallet()
openingTime()
closingTime()
hasClosed()
```

4、复制众筹合约地址`0xbbf289d846208c16edc8474705c748aff07732db`备用

5、按私募的占比20%，给众筹合约地址分配`200,000,000`个CLB，回到代币合约，切换到管理员账号`0xca3...a733c`下，执行转账：
```
transfer("0xbbf289d846208c16edc8474705c748aff07732db", "200000000,000000000000000000")
```

6、查询众筹合约地址CLB余额
```
balanceOf("0xbbf289d846208c16edc8474705c748aff07732db")
```

---

#### 用例2——投资ETH并获得CLB

1、切换到张三账号`0x147...c160c`，投资3个ETH，得到`3000,000000000000000000`个CLB
```
buyTokens("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "3 ether")
```

2、回到代币合约，验证一下张三账号CLB余额：
```
balanceOf("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c")
```

3、查看当前募集情况
```
weiRaised
```

---

#### 用例3——修改众筹期限，让众筹延期或过期

只有管理员拥有操作权限

1、切换到管理员账号`0xca3...a733c`下，设置众筹延期：
```
setTimePeriod("1531756800", "1537199999")
```

2、查询众筹结束时间
```
closingTime
```

3、设置众筹时间过期，众筹自动关闭
```
setTimePeriod("1531756800", "1531900167")
```
重复第2步

4、查询众筹状态
```
hasClosed
```

#### 用例4——众筹失败可退还

查看转账到收ETH钱包是否到账




























