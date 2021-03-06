# 基础合约Colorbay测试用例
#### 测试功能点：转账（包括授权转账）、锁/解仓、冻结账户、超管、增发、燃烧、更新代币名字和简称、更换合约管理员、禁止接收ETH、安全运算库

---

#### 测试工具
Remix或Truffle

---

#### 测试数据
**代币**
- 彩贝发行总量为 1,000,000,000 个token
- 机构方私募                   占比15%，即150,000,000个token，上交易所后私募锁仓三个月，之后逐月释放 20%；
- 基金会核心运作团队            占比20%，即200,000,000个token，锁定一年， 两年内逐步释放；
- 社区建设&海外社区核心团队     占比10%，即100,000,000个token，锁定一年，两年内逐步释放；
- 生态激励矿池                 占比30%，即300,000,000个token，按照智能合约的规则每年释放剩余总量的 10%；
- 市场推广                     占比15%，即150,000,000个token，主要是市场教育、社区推广等持续性投入；
- 基金会持有                   占比10%，即100,000,000个token，，主要做数字内容生态战略合作资源。

---
**账号**
- 管理员 `0xca3...a733c`
- 张三  `0x147...c160c`
- 李四  `0x4b0...4d2db`
- 王五  `0x583...40225`
- 赵六  `0xdd8...92148`
---
- 管理员 `0xca35b7d915458ef540ade6068dfe2f44e8fa733c`
- 张三  `0x14723a09acff6d2a60dcdf7aa4aff308fddc160c`
- 李四  `0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db`
- 王五  `0x583031d1113ad414f02576bd6afabfb302140225`
- 赵六  `0xdd870fa1b7c4700f2bd7f44238821c26f7392148`
---

#### 用例1——创建代币合约CLB
只有管理员拥有操作权限

1、创建一个代币合约CLB；

2、查看事件日志。

---
【测试结果】：
(1) 输出10亿数量更新事件是正确的；


#### 用例2——查看合约
1、查询代币名称、简称、管理员地址、仓库状态、是否可增发。
```
decimals
name()
symbol()
owner()
paused()
mintingFinished()
```
---
【测试结果】：全局变量和一个函数正确的；
(1) decimals = 4;
(2) totalSupply() = 10亿；
(3) symbol = CLB
(4) paused = false
(5) mintFinished = false;
(6) owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c 

#### 用例3——转账
1、切换到管理员账号`0xca3...a733c`下，给张三`0x147...c160c`转账1000个CLB，执行：
```
transfer("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "1000,0000") #约定：运行时，去除数额中的逗号，否则会出错
```

2、查询张三账号`0x147...c160c`余额
```
balanceOf("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c")
```

---
【测试结果】：转账成功，张三名下余额正确；

【异常用例】
1，切换到张三账户下，转移10000个CLB给管理员账户
```
transfer("0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "10000,0000") #约定：运行时，去除数额中的逗号，否则会出错
```
【预计结果】：失败

---
【测试结果】：
结果失败，张三下CLB余额未减少，但是ETH GAS减少了。

#### 用例4——授权转账
1、切换到管理员账号`0xca3...a733c`下，给李四账号`0x4b0...4d2db`授权额度2亿，执行:
```
approve("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","200000000,0000")
```
【结果】执行成功

异常测试用例：
切换到管理员账号`0xca3...a733c`下，给李四账号`0x4b0...4d2db`授权额度20亿，执行:
```
approve("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "2000000000,0000")
```
【结果】执行成功。不对啊，授信额度怎么可以超过总量呢？

2、 查询李四账号`0x4b0...4d2db`的余额

```
balanceOf("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
```
【结果】结果显示为0。


2、查询李四账号`0x4b0...4d2db`的授权额度
```
allowance("0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
```
异常测试用例：
【结果】执行成功，显示为20亿。

3、李四账号`0x4b0...4d2db`给王五账号`0x583...40225`转账3000个CLB，切换到李四账号`0x4b0...4d2db`下，执行：
```
transferFrom("0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x583031d1113ad414f02576bd6afabfb302140225","3000,0000")
```
【结果】成功
提示性结论有2个Transfer的输出，感觉太冗余了，建议只保留一个事件，不要2次输出？评估其他事件的情况别导致无事件输出。


异常测试用例：
前一步授权20个亿，然后执行转账12个亿CLB；
transferFrom("0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x583031d1113ad414f02576bd6afabfb302140225","1200000000,0000")
【结果】失败，超过限额

前一步授权20个亿，然后执行转账3000个CLB；
transferFrom("0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x583031d1113ad414f02576bd6afabfb302140225","3000,0000")
【结果】成功。

【结果 -  失败】 执行到LINE 215行失败
decoded output  的结果为false

transact to Colorbay.transferFrom errored: VM error: revert.
revert	The transaction has been reverted to the initial state.
Note: The constructor should be payable if you send value.	Debug the transaction to get more information. 
【结论】非故障，原因为未切换到APPROVE 李四的账号下。

4、查询王五账号`0x583...40225`余额
```
balanceOf("0x583031d1113ad414f02576bd6afabfb302140225")
```
5、查询管理员账号`0xca3...a733c`余额
```
balanceOf("0xca35b7d915458ef540ade6068dfe2f44e8fa733c")
```
6、查询李四账号`0x4b0...4d2db`剩余的授权额度
```
allowance("0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
```
7、增加授权额度，切换到管理员账号`0xca3...a733c`下，给李四账号`0x4b0...4d2db`授权额度增加4000个CLB，执行:
```
increaseApproval("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "4000,0000")

```
重复第6步，查询授权额度

8、切换到管理员账号`0xca3...a733c`下，给李四账号`0x4b0...4d2db`授权额度减少4000个CLB，执行:
```
decreaseApproval("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "4000,0000")
```
重复第6步，查询授权额度
异常用例：
（1）减少的授权额度，超过总授权数
decreaseApproval("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "4000,0000")
（2）减少的授权额度，超过父账户总余额
decreaseApproval("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "4000,0000")


#### 用例5——锁/解仓、超管
只有管理员拥有操作权限
锁仓后，相关函数被禁用：`transfer、transferFrom、approve、increaseApproval、decreaseApproval`

1、切换到李四账号`0x4b0...4d2db`下，执行锁仓，将报错，没有权限
```
pause()
```
2、切换到管理员账号`0xca3...a733c`下，执行锁仓，将成功
```
pause()
```
3、查询仓库状态
```
paused()
```
4、李四给王五账号`0x583...40225`转账3000个CLB，切换到李四账号`0x4b0...4d2db`下，执行将失败，因为已锁仓：
```
transferFrom("0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x583031d1113ad414f02576bd6afabfb302140225","3000,0000")
```
5、切换到李四账号`0x4b0...4d2db`下，执行解仓，将报错，没有权限
```
unpause()
```
6、切换到管理员账号`0xca3...a733c`下，执行锁仓:
```
unpause()
```
7、查询仓库状态
```
paused()
```

#### 用例6——冻结账户
只有管理员拥有操作权限

1、查询王五账号`0x583...40225`是否被冻结
```
frozenAccount("0x583031d1113ad414f02576bd6afabfb302140225")
```
2、切换到王五账号`0x583...40225`下，自己冻结自己，将会失败，因为没有权限
```
freezeAccount("0x583031d1113ad414f02576bd6afabfb302140225", true)
```
【结果】冻结失败，正常。

[异常用例] 管理员冻结自己呢？
```
freezeAccount("0xca35b7d915458ef540ade6068dfe2f44e8fa733c", true)
```
【结果】冻结成功。

3、切换到管理员账号`0xca3...a733c`下，冻结王五账号`0x583...40225`
```
freezeAccount("0x583031d1113ad414f02576bd6afabfb302140225", true)
```
4、切换到王五账号`0x583...40225`下，给李四账号`0x4b0...4d2db`转账1000个CLB
```
transfer("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "1000,0000")
```
【结果】提示失败，回滚。正常。

5、切换到管理员账号`0xca3...a733c`下，解冻王五账号`0x583...40225`
```
freezeAccount("0x583031d1113ad414f02576bd6afabfb302140225", false)
```
重复第1、3步


#### 用例7——增发
只有管理员拥有操作权限

1、查询是否可增发
```
mintingFinished()
```
2、查询CLB总量
```
totalSupply
```
3、切换到李四账号`0x4b0...4d2db`下，增发10000个CLB，将会报错，因为没有权限：
```
mint("0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "10000,0000")
```
4、切换到管理员账号`0xca3...a733c`下，增发10000个CLB
```
mint("0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "10000,0000")
```
重复第2步

5、关闭增发
```
finishMinting
```
重复第3步


#### 用例8——燃烧
只有管理员拥有操作权限

1、查询CLB总量
```
totalSupply
```
2、切换到李四账号`0x4b0...4d2db`下，燃烧代币总量中的10000个CLB，将会报错，因为没有权限：
```
burn("10000,0000")
```
【结果】burn谁都可以做，用例设计错误，跟代码不一致。

3、切换到管理员账号`0xca3...a733c`下，燃烧代币总量中的10000个CLB
```
burn("10000,0000")
```
重复第1步


#### 用例9——更新代币名字和简称
只有管理员拥有操作权限

1、查看当前代币名字和简称
2、切换到李四账号`0x4b0...4d2db`下，执行更新，将会报错，因为没有权限：
```
setTokenInformation("Colorbay Token 2", "CLB2")
```
3、切换到管理员账号`0xca3...a733c`下，执行更新：
```
setTokenInformation("Colorbay Token 2", "CLB2")
```
重复第1步



#### 用例10——更换合约管理员
只有管理员拥有操作权限

1、切换到李四账号`0x4b0...4d2db`下，执行更新，将会报错，因为没有权限：
```
transferOwnership("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
```
2、切换到当前管理员账号`0xca3...a733c`下，将管理员身份转让给李四：
```
transferOwnership("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
```
3、查询当前管理员账号
```
owner()
```
4、用原管理员账号，做增发、燃烧、锁/解仓、更新代币名字和简称操作，将会失败，因为没有权限
```

burn("10000,0000") #燃烧
mint("0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "10000,0000") #增发

pause() #锁仓
unpause() #解仓
setTokenInformation("Colorbay Token 3", "CBT3")
```
#### 用例11——合约禁用接收ETH
```
fallback()
```
【结果】该函数不存在。

