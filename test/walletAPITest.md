Colorbay智能合约模块
——Sprint1可交付增量和测试用例
# 一、测试数据
## 1.1 合约地址
0x7b6a1b454cb1245e698ce73029c7fcccd5cd4464

## 1.2 用户数据
jid	chain_userid	姓名	初始CLB数量	类型	钱包地址	钱包私钥
1	1534150413256015	张三	500000000个	运营用户	0x03183a5c78434860d5e021d98155a55dd577a97a	0x1cb131d6c47d4ad6d4313af320a35976b575c346c3323f07fb4d00ffd9f65d7e
2	1534151918819209	李四	0个	普通用户	0x41cb7db0e682986a9368f40f63fd1377ec28f9ef	0x1cb131d6c47d4ad6d4313af320a35976b575c346c3323f07fb4d00ffd9f65d7e
3	1533795622184255	王五	0个	普通用户	0x69a265d4a9c8e236e3539365ae32508b9fe4a303	0x31b72d0dd8a22fc294adc4ad4de4226a5ca9f90236573f0ba78b39657e07d84e
4	1533795622184255	赵六	0个	普通用户	0xc34fd97b8d52e49d55efa970c0a2ea34848006e8	0x1c83e805d7dbaf3f15141433e3dfc2e552537e85f55888bcdb4a732a2c0d8f83

# 二、接口测试简单用例
1、张三从朋友那听说了一条发柴之道，受朋友邀请，来彩贝注册了账号并有了钱包（张三已经注册，可跳过这一步）
http://api.ju3ban.net/wallet/create

2、有一笔注册奖励到了账，张三迫不及待地来查查他的通证CLB总数及子账户情况
http://api.ju3ban.net/user/account?jid=1

3、张三觉得这注册奖励太少，分析下来觉得项目很靠谱，于是去交易所买了一点，来查查他的CLB链上余额
http://api.ju3ban.net/token/balance?address=0x03183a5c78434860d5e021d98155a55dd577a97a

4、张三又查了查他的CLB本地余额
http://api.ju3ban.net/wallet/balance?address=0x03183a5c78434860d5e021d98155a55dd577a97a

5、张三想赚更多币，与平台一起成长，锁定1000个CLB
http://api.ju3ban.net/user/lock/?jid=1&amount=1000
重复第2步查询可用状态余额，去第9步查询锁定日志

6、这些天，彩贝平台画家李四的作品让张三眼前一亮，于是张三打赏了李四，给李四转账了100个CLB（因为没有做充值，暂时会提示余额不足）
http://api.ju3ban.net/wallet/transfer/?from_address=0x03183a5c78434860d5e021d98155a55dd577a97a&to_address=0x41cb7db0e682986a9368f40f63fd1377ec28f9ef&amount=100

7、几个月后，张三通过签到、打赏作品发柴了，想要解锁1000个CLB，然后提个现
http://api.ju3ban.net/user/unlock/?jid=1&amount=1000

8、朋友劝张三，此时解锁还太早，他犹豫地查看了一下解锁中币的详情
http://api.ju3ban.net/user/unlocking?jid=1

10、第二天，张三决定重新锁定1000个币，发现币天增加了（待与周进对接）
http://api.ju3ban.net/user/relock/?id=2&jid=1

# 三、附 数据库初始化
```
SET FOREIGN_KEY_CHECKS=0;

-- 用户彩贝钱包表

truncate table `db_colorbay`.`tb_user_wallet`;

INSERT INTO `db_colorbay`.`tb_user_wallet` (`jid`, `clbaddress`, `clb`, `usable`, `locked`, `unlock`, `canreceive`, `clbday`, `pending`, `balance_onchain`, `exp_ratio`, `ability_ratio`) VALUES ('1', '0x03183a5c78434860d5e021d98155a55dd577a97a', '500000000.0000', '10000.0000', '10000.0000', '10000.0000', '10000.0000', '10000.00', '10000.0000', '10000.0000', '1.00', '1.00');
INSERT INTO `db_colorbay`.`tb_user_wallet` (`jid`, `clbaddress`, `clb`, `usable`, `locked`, `unlock`, `canreceive`, `clbday`, `pending`, `balance_onchain`, `exp_ratio`, `ability_ratio`) VALUES ('2', '0x41cb7db0e682986a9368f40f63fd1377ec28f9ef', '500000000.0000', '20000.0000', '20000.0000', '20000.0000', '20000.0000', '20000.00', '20000.0000', '20000.0000', '1.00', '1.00');

-- 独立的用户公私钥存储表

truncate table `db_colorbay`.`tb_wallet_secret`;

INSERT INTO `db_colorbay`.`tb_wallet_secret` (`userid`, `partnerid`, `chainid`, `address`, `custom_param`, `private_key`, `mnemonic_sentence`, `rsa_public_key`, `rsa_private_key`, `passphrase`, `balance`, `openid`, `groupid`, `create_time`) VALUES ('16469', '10', '2', '0x03183a5c78434860d5e021d98155a55dd577a97a', NULL, '0x1cb131d6c47d4ad6d4313af320a35976b575c346c3323f07fb4d00ffd9f65d7e', NULL, NULL, NULL, NULL, NULL, '1534150413256015', '0', '2018-08-13T16:53:33.6192693+08:00');
INSERT INTO `db_colorbay`.`tb_wallet_secret` (`userid`, `partnerid`, `chainid`, `address`, `custom_param`, `private_key`, `mnemonic_sentence`, `rsa_public_key`, `rsa_private_key`, `passphrase`, `balance`, `openid`, `groupid`, `create_time`) VALUES ('16471', '10', '2', '0x41cb7db0e682986a9368f40f63fd1377ec28f9ef', NULL, '0x73cbda2daaf1d64b3b70528bc373efa5dd04c1c9f02d4e7e543ff760de9d76c6', NULL, NULL, NULL, NULL, NULL, '1534151918819209', '0', '2018-08-13T17:18:38.5470327+08:00');

-- 彩贝币锁定，解锁，重新锁定等日志表

truncate table `db_colorbay`.`tb_clblock_log`;

-- 币天记录表

truncate table `db_colorbay`.`tb_clbday_log`;

-- 其他表

truncate table `db_colorbay`.`tb_clb_log_map`;
truncate table `db_colorbay`.`tb_clbday_settlement_log`;
truncate table `db_colorbay`.`tb_clbreceive_log`;
truncate table `db_colorbay`.`tb_clbtoken_log`;
truncate table `db_colorbay`.`tb_note_clb_log`;
truncate table `db_colorbay`.`tb_note_rank`;
truncate table `db_colorbay`.`tb_vote_log`;
truncate table `db_colorbay`.`tb_vote_rank`;
```
