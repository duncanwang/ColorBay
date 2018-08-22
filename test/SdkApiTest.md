# 1.	 用户管理
## 1.1	注册新用户
输入：
{
  "OpenId":"13671927744"
}
输出：
{
    "Code": 1,
    "Msg": "Create finish",
    "Data": 16346
}

## 1.2	创建用户钱包（指定区块链网络）
输入：
{
  "ChainID":2,
  "OpenId":"13671927744"
}
输出：
{
    "Code": 1,
    "Msg": "Create Wallet Succeeded",
    "Data": {
        "Id": 0,
        "UserId": 16346,
        "PartnerId": 2,
        "ChainID": 2,
        "Address": "0xd9d48f3d2e138245862e3e6fd997c5cd27ccd237",
        "CustomParam": null,
        "PrivateKey": "0x1e646dc35ed7f3dad266736f6a19674dcdf927d5cf5bb193c691229d96b09260",
        "CreateTime": "2018-08-22T15:21:47.5630022+08:00",
        "MnemonicSentence": null,
        "RsaPublicKey": null,
        "RsaPrivateKey": null,
        "Passphrase": null,
        "Balance": null,
        "OpenId": "13671927744",
        "GroupID": 0
    }
}

## 1.3	创建用户钱包
创建依据合作伙伴支持的所有钱包账号，每个合作伙伴支持的区块链网络有差别，对应每个用户会有多个不同的钱包地址。
输入：
{
  "OpenId":"13671927744",
  "GroupID":0
}
输出：
{
    "Code": 1,
    "Msg": "创建钱包成功",
    "Data": [
        {
            "Id": 22218,
            "UserId": 16346,
            "PartnerId": 2,
            "ChainID": 1,
            "Address": "0x6d9c8992f593171ed46a9b18c53b1485e30a55ad",
            "CustomParam": null,
            "PrivateKey": "0x07107a6bc9a300976d83176a17d490457b2ba47f90c0efc2031f0f9733c18831",
            "CreateTime": "0001-01-01T00:00:00",
            "MnemonicSentence": null,
            "RsaPublicKey": null,
            "RsaPrivateKey": null,
            "Passphrase": null,
            "Balance": null,
            "OpenId": "13671927744",
            "GroupID": 0
        },
        {
            "Id": 22219,
            "UserId": 16346,
            "PartnerId": 2,
            "ChainID": 4,
            "Address": "0xdc90b4148fe200b452e0d388b656513f9edf2744",
            "CustomParam": null,
            "PrivateKey": "0x57ed07e635adb2624965fc1180176d2980e8c237c6335d271a7c3f85c5b49831",
            "CreateTime": "0001-01-01T00:00:00",
            "MnemonicSentence": null,
            "RsaPublicKey": "MIIBIDANBgkqhkiG9w0BAQEFAAOCAQ0AMIIBCAKCAQEAlmPOS2hIVdW4Prj8VmBSRSC+ao44lFp/3Teb//RFlviq/mWhXGIygcHD8tf4XvFj8TUQ68iz8kBctBwgGkx81jGwHwoCYPk1nCIgrvNZRZ5Bkc6l/0/hFM7LMbN09QQBzlJhIPo+yH6mqfNC1iGwLBQNc6oawakrkOwYs/UHY0lKb9a4HGkS/zkYicB+TTqri7zWdUNY/FWdPiktKgPshz7Xepy8Jou5XjE0+9jIjJbvlQX3mEKea/XDxoVMQhCnm9rUi3Yfj+A+BlpURqCiV3prrxi4Gscf2NLP7HJSmPOsk+IrqKo03EdXV/2dJl0zBPHFOFxaSRmpf2NonFV7JwIBAw==",
            "RsaPrivateKey": "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCWY85LaEhV1bg+uPxWYFJFIL5qjjiUWn/dN5v/9EWW+Kr+ZaFcYjKBwcPy1/he8WPxNRDryLPyQFy0HCAaTHzWMbAfCgJg+TWcIiCu81lFnkGRzqX/T+EUzssxs3T1BAHOUmEg+j7Ifqap80LWIbAsFA1zqhrBqSuQ7Biz9QdjSUpv1rgcaRL/ORiJwH5NOquLvNZ1Q1j8VZ0+KS0qA+yHPtd6nLwmi7leMTT72MiMlu+VBfeYQp5r9cPGhUxCEKeb2tSLdh+P4D4GWlRGoKJXemuvGLgaxx/Y0s/sclKY86yT4iuoqjTcR1dX/Z0mXTME8cU4XFpJGal/Y2icVXsnAgEDAoIBABkQomHmtrj49Ap0Kg5lYwuFdRHCXsNkaqTemf/+C5kpcdUQ8DoQXcBK9f3OqWUoO1LeLXyhc1MKuh4EsARiFM5dnVqBqxApiO9bBXJ95DZFCu2icP/ipYN3zIhIk34rVaJjEDAptSFqcRxTNc5a8rIDV5NHBHWcMe18rsio1pCL86L9AJLW+gRMK/rqZedC75/Bg/MLptrVwUsypffCw3rQ7/3OyKoRvcRIFPaYvPyHRUNjMtpcarPWyeX7VfG86WBwtW9Thpds+STRafehDbOr500mh/+Frz3Xu1qGfUiE9/S2dRUrm3AEPbvTDnEVORshgK2N53zDOfB7oMVssv8CgYEA+5eZFiBcfsZx8c4DpWAvSGj8snFocVr1R0Bzn4XSp3ZdlNn3M+3AxDFvA3BORE1Rdl15zBKUasD0KNFmlU7NtlphhZrNMtWEAgwkXZujPz2ewC9qZnZYPSse8kqedjIVgGTkNz8Wo5r/mVThHcgMNZBphpDyUMvdpmyo/3IILh0CgYEAmQZPnosCuB7+Hto+dYF5xWQ3DFGU/oBdzjqFqdWgsC/7oq3M1DxggpMRs8P2FlQZ2aM4+meDs3P435E6s0jVeP7VDlSzxS3OZR1Net03EOPUP7DHIadMxzqleYKs7LPAXHK3NeqN7KEuS5wqKLfRptG/OpYWnJCop2/UpInBGxMCgYEAp7pmDsA9qdmhS96tGOrKMEX9zEua9jyjhNWialk3Gk7pDeakzUkrLXZKAkre2DOLpD5RMrcNnICixeDvDjSJJDxBA7yIzI5YAV1tk70Xf35p1XTxmaQ603IUoYcUTswOVZiYJNS5wmdVEONAvoVdeQrxBGChizKTxEhwqkwFdBMCgYBmBDUUXKx6v1QUkX75APvY7XoINmNUVZPe0a5xORXKyqfByTM4KEBXDLZ31/lkOBE7wiX8RQJ3oqXqYNHM2zj7VI4Jjc0uHomYvjOnPiS17TgqddoWb4iE0cOmVx3zIoA9oc95RwlIa3QyaBwbJTZvNn98ZA8TCxsaSo3DBoC8twKBgQCqeV+fQon5ZujhMavtx3Bp9Qk6qjBwgfDPfxpRYWnx0ANL0J23VnQcPF+7knwI2EcGCksduk0pQxSHUsFCzFqagmPsTotJVQ+GXOTf9NITGZLO0v95QmBZBM1RH3ZuF3z472pEWHmoPSmdAa1r4DDDwyt8PtIAyjHOfaSUW7RVVQ==",
            "Passphrase": null,
            "Balance": null,
            "OpenId": "13671927744",
            "GroupID": 0
        }
    ]
}

## 1.4	查询用户钱包集合
输入：
{
  "OpenId":"13671927744"
}

输出：
```
{
    "Code": 1,
    "Msg": "",
    "Data": [
        {
            "Id": 22218,
            "UserId": 16346,
            "PartnerId": 2,
            "ChainID": 1,
            "Address": "0x6d9c8992f593171ed46a9b18c53b1485e30a55ad",
            "CustomParam": null,
            "PrivateKey": "0x07107a6bc9a300976d83176a17d490457b2ba47f90c0efc2031f0f9733c18831",
            "CreateTime": "2018-08-22T15:48:17.803",
            "MnemonicSentence": null,
            "RsaPublicKey": null,
            "RsaPrivateKey": null,
            "Passphrase": null,
            "Balance": "0",
            "OpenId": null,
            "GroupID": 0
        },
        {
            "Id": 21517,
            "UserId": 16346,
            "PartnerId": 2,
            "ChainID": 1,
            "Address": "0xaA0A153D5cA9DC5310A406f961D51cd0E57103f0",
            "CustomParam": null,
            "PrivateKey": "0x0be8cc03657d66f1bcb7b7603e0c3b00d2f8aa94845a1e185f40717dc652c077",
            "CreateTime": "2018-07-19T16:21:13.513",
            "MnemonicSentence": null,
            "RsaPublicKey": "MIIBIDANBgkqhkiG9w0BAQEFAAOCAQ0AMIIBCAKCAQEAkXZpItm1vDgMDocRLyJGm7G+9Q4Ee0WtrUVf0kjy5zjC+flhN7pDqdKEEoER9B7ceU34U59ENuCbgwNKe+YvO0GQUy9XEGx/q9SioOALyy2pSBHGLf3igCDvfP8xV20kIeMq1MoXGSJIAl6nY0mGn7YiK92OUu10edyvQyMWVTS0rlTbROUdIUORwKTY6N10bh9iHof6/3t7RJ0a2PyKUUImyFth0HU9Jplrr9R+f/EuypvnVnKW1vgbcUAtYuBcE4c3bxg9di8iVLSY0hEljal+13IvdXWsw10ryd+1oFd1Rj0dvADA9zG16AtwCdhY9nO332P4ZeMINDtuerOwiwIBAw==",
            "RsaPrivateKey": "MIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCRdmki2bW8OAwOhxEvIkabsb71DgR7Ra2tRV/SSPLnOML5+WE3ukOp0oQSgRH0Htx5TfhTn0Q24JuDA0p75i87QZBTL1cQbH+r1KKg4AvLLalIEcYt/eKAIO98/zFXbSQh4yrUyhcZIkgCXqdjSYaftiIr3Y5S7XR53K9DIxZVNLSuVNtE5R0hQ5HApNjo3XRuH2Ieh/r/e3tEnRrY/IpRQibIW2HQdT0mmWuv1H5/8S7Km+dWcpbW+BtxQC1i4FwThzdvGD12LyJUtJjSESWNqX7Xci91dazDXSvJ37WgV3VGPR28AMD3MbXoC3AJ2Fj2c7ffY/hl4wg0O256s7CLAgEDAoIBABg+ZtskSPS0AgJr2DKFtm9ISn4tAL82R5zg5U220yaJddRUOt6fC0b4a1hq2FNaehQ3qWNFNgklb0CAjGn7songQriH49gSFUdOGxrQAfcyRuFYS7JU+xVa0pTVMuPnhgWl3HjMWS7bDABlG+Xhlm/zsFyk7Q3SPhRPcoswg7jd3Z+1V59duaUSqT+t8QpM1wbLJYa5QslwzC4mEqVHMt8GBSdQ4AZO+h2h18Rml6GuHZv/maILDxaRQfEQpVlLbm/o/6ivMwQuNCJFa91yRPkkWScrHn3+caRfjLzQnoxKvLiLiyiN4Ikv7Mg+9chOjoeRmsek8FPTSJDchBuIZrMCgYEAz1GBlAg8yzo5LV0MfIW7+5s1o47frEqHf9lEGUmPJAQzq0IfsKbxW1zMofZ+QIJOk4P90JEw5+AV+sB76sEsFmUQOvx9WlwFslCDry94byOm8aTPEgQEcuCxplaVQEFHsl36Np0lN/gI58Zg+H+F+WjpW3zoMJ588xdx6WTM+0MCgYEAs56TOYB1+AiabOWEtiVUbqom3WdQvfxPMlZ0ka/CNRLqXJpWcQOqBRgBux7usDON6Z6gfPj/VG96lQpgYonvrw8A/n5/sQEUNzaQYnHrGJModkegZn16kAhuOQZmvhVPVpT9pCuIRcgJQXAwtNh7CGAgu7SeJdByYbeebHC0TRkCgYEAijZWYrAoh3wmHj4IUwPSp7zObQnqctxaVTuCu4ZfbVgiciwVIG9Lkj3dwU7+1aw0Ylf+iwt17+q5UdWn8dYdZENgJ1L+PD1ZIYsCdMpQShfEoRiKDAKtoeshGY8OKtYvzD6mzxNuJVAF79mV+v+upkXw56iayxRTTLpL8O3d/NcCgYB3vwzRAE6lWxGd7lh5bjhJxsSTmjXT/YohjvhhH9bODJw9vDmgrRwDZVZ8v0nKzQlGacBTUKo4SlG4sZWXBp/KCgCpqap2ALgkzwrsS/IQYhr5hRWZqPxgBZ7Qru8pY4o5uKkYHQWD2rDWSssjOvywQBXSeGluivbrz77y9c2IuwKBgHTOFmZL2lGdiryZpk77P6K4JjnjS8Uf6azSd+YlwijSdjJ+bwLgJ4NCLJlCj9BMYDcjaYk5OlABcEle+5dWWGBoPTvnhVFn5OlyHZlHfPELtM2jvG6lUsgzs40JUgMsw8Z6mfyMdvCPp1lD30vUcYbx/bfXtX21Q/Qt0rEAGUaO",
            "Passphrase": null,
            "Balance": "0",
            "OpenId": null,
            "GroupID": 0
        },
        {
            "Id": 22217,
            "UserId": 16346,
            "PartnerId": 2,
            "ChainID": 2,
            "Address": "0xd9d48f3d2e138245862e3e6fd997c5cd27ccd237",
            "CustomParam": null,
            "PrivateKey": "0x1e646dc35ed7f3dad266736f6a19674dcdf927d5cf5bb193c691229d96b09260",
            "CreateTime": "2018-08-22T15:21:47.57",
            "MnemonicSentence": null,
            "RsaPublicKey": null,
            "RsaPrivateKey": null,
            "Passphrase": null,
            "Balance": "0",
            "OpenId": null,
            "GroupID": 0
        },
        {
            "Id": 22219,
            "UserId": 16346,
            "PartnerId": 2,
            "ChainID": 4,
            "Address": "0xdc90b4148fe200b452e0d388b656513f9edf2744",
            "CustomParam": null,
            "PrivateKey": "0x57ed07e635adb2624965fc1180176d2980e8c237c6335d271a7c3f85c5b49831",
            "CreateTime": "2018-08-22T15:48:18.36",
            "MnemonicSentence": null,
            "RsaPublicKey": "MIIBIDANBgkqhkiG9w0BAQEFAAOCAQ0AMIIBCAKCAQEAlmPOS2hIVdW4Prj8VmBSRSC+ao44lFp/3Teb//RFlviq/mWhXGIygcHD8tf4XvFj8TUQ68iz8kBctBwgGkx81jGwHwoCYPk1nCIgrvNZRZ5Bkc6l/0/hFM7LMbN09QQBzlJhIPo+yH6mqfNC1iGwLBQNc6oawakrkOwYs/UHY0lKb9a4HGkS/zkYicB+TTqri7zWdUNY/FWdPiktKgPshz7Xepy8Jou5XjE0+9jIjJbvlQX3mEKea/XDxoVMQhCnm9rUi3Yfj+A+BlpURqCiV3prrxi4Gscf2NLP7HJSmPOsk+IrqKo03EdXV/2dJl0zBPHFOFxaSRmpf2NonFV7JwIBAw==",
            "RsaPrivateKey": "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCWY85LaEhV1bg+uPxWYFJFIL5qjjiUWn/dN5v/9EWW+Kr+ZaFcYjKBwcPy1/he8WPxNRDryLPyQFy0HCAaTHzWMbAfCgJg+TWcIiCu81lFnkGRzqX/T+EUzssxs3T1BAHOUmEg+j7Ifqap80LWIbAsFA1zqhrBqSuQ7Biz9QdjSUpv1rgcaRL/ORiJwH5NOquLvNZ1Q1j8VZ0+KS0qA+yHPtd6nLwmi7leMTT72MiMlu+VBfeYQp5r9cPGhUxCEKeb2tSLdh+P4D4GWlRGoKJXemuvGLgaxx/Y0s/sclKY86yT4iuoqjTcR1dX/Z0mXTME8cU4XFpJGal/Y2icVXsnAgEDAoIBABkQomHmtrj49Ap0Kg5lYwuFdRHCXsNkaqTemf/+C5kpcdUQ8DoQXcBK9f3OqWUoO1LeLXyhc1MKuh4EsARiFM5dnVqBqxApiO9bBXJ95DZFCu2icP/ipYN3zIhIk34rVaJjEDAptSFqcRxTNc5a8rIDV5NHBHWcMe18rsio1pCL86L9AJLW+gRMK/rqZedC75/Bg/MLptrVwUsypffCw3rQ7/3OyKoRvcRIFPaYvPyHRUNjMtpcarPWyeX7VfG86WBwtW9Thpds+STRafehDbOr500mh/+Frz3Xu1qGfUiE9/S2dRUrm3AEPbvTDnEVORshgK2N53zDOfB7oMVssv8CgYEA+5eZFiBcfsZx8c4DpWAvSGj8snFocVr1R0Bzn4XSp3ZdlNn3M+3AxDFvA3BORE1Rdl15zBKUasD0KNFmlU7NtlphhZrNMtWEAgwkXZujPz2ewC9qZnZYPSse8kqedjIVgGTkNz8Wo5r/mVThHcgMNZBphpDyUMvdpmyo/3IILh0CgYEAmQZPnosCuB7+Hto+dYF5xWQ3DFGU/oBdzjqFqdWgsC/7oq3M1DxggpMRs8P2FlQZ2aM4+meDs3P435E6s0jVeP7VDlSzxS3OZR1Net03EOPUP7DHIadMxzqleYKs7LPAXHK3NeqN7KEuS5wqKLfRptG/OpYWnJCop2/UpInBGxMCgYEAp7pmDsA9qdmhS96tGOrKMEX9zEua9jyjhNWialk3Gk7pDeakzUkrLXZKAkre2DOLpD5RMrcNnICixeDvDjSJJDxBA7yIzI5YAV1tk70Xf35p1XTxmaQ603IUoYcUTswOVZiYJNS5wmdVEONAvoVdeQrxBGChizKTxEhwqkwFdBMCgYBmBDUUXKx6v1QUkX75APvY7XoINmNUVZPe0a5xORXKyqfByTM4KEBXDLZ31/lkOBE7wiX8RQJ3oqXqYNHM2zj7VI4Jjc0uHomYvjOnPiS17TgqddoWb4iE0cOmVx3zIoA9oc95RwlIa3QyaBwbJTZvNn98ZA8TCxsaSo3DBoC8twKBgQCqeV+fQon5ZujhMavtx3Bp9Qk6qjBwgfDPfxpRYWnx0ANL0J23VnQcPF+7knwI2EcGCksduk0pQxSHUsFCzFqagmPsTotJVQ+GXOTf9NITGZLO0v95QmBZBM1RH3ZuF3z472pEWHmoPSmdAa1r4DDDwyt8PtIAyjHOfaSUW7RVVQ==",
            "Passphrase": null,
            "Balance": "0",
            "OpenId": null,
            "GroupID": 0
        }
    ]
}
```

## 1.5	WalletDetail查询钱包详情
输入：
{
  "Address":"0xd9d48f3d2e138245862e3e6fd997c5cd27ccd237",
  "ChainID":2
}
输出：
{
    "Code": 1,
    "Msg": "钱包获取",
    "Data": {
        "Id": 22217,
        "UserId": 16346,
        "PartnerId": 2,
        "ChainID": 2,
        "Address": "0xd9d48f3d2e138245862e3e6fd997c5cd27ccd237",
        "CustomParam": null,
        "PrivateKey": "0x1e646dc35ed7f3dad266736f6a19674dcdf927d5cf5bb193c691229d96b09260",
        "CreateTime": "2018-08-22T15:21:47.57",
        "MnemonicSentence": null,
        "RsaPublicKey": null,
        "RsaPrivateKey": null,
        "Passphrase": null,
        "Balance": "0",
        "OpenId": null,
        "GroupID": 0
    }
}

## 1.6 GetBalanceInDB获取数据库中的DB数量
输入：
{
	"WalletAddress":"0xd9d48f3d2e138245862e3e6fd997c5cd27ccd237",
	"CurrencyType":100,
	"ChainID":2
}
输出：
{
    "Code": 0,
    "Msg": "",
    "Data": null
}

输入2：
{
	"WalletAddress":"0x03183a5c78434860d5e021d98155a55dd577a97a",
	"CurrencyType":100,
	"ChainID":2
}
输出：
{
    "Code": 1,
    "Msg": "Get balance success",
    "Data": "500000009999999999999999900"
}

## 1.7 Transfer转账 【该接口已失效，请删除】
输入：
{
  "TokenAddress":"0x7b6a1b454cb1245e698ce73029c7fcccd5cd4464",
  "CurrencyType":"100",
  "Address":"0x03183a5c78434860d5e021d98155a55dd577a97a",
  "AddressTo":"0xd9d48f3d2e138245862e3e6fd997c5cd27ccd237",
  "AmountInHex":"2710",
  "BackUrl":"http://api.ju3ban.net/token/callback/",
  "chainID":"2"
}

输出：
{
    "Code": -1,
    "Msg": "insufficient balance!",
    "Data": -1
}

**说明：** 转账未成功，一定要用TOKEN的转账功能吗？

## 1.8 TransferInDB
输入：
{
	"FromWalletAddress":"0x03183a5c78434860d5e021d98155a55dd577a97a",
	"CurrencyType":100,
	"ChainID":2,
	"ToWalletAddress":"0xd9d48f3d2e138245862e3e6fd997c5cd27ccd237",
	"TransferValue":"10000000000000000000000",
	"UserTypeID":10
}

输出：【错误】
{
    "Code": -3,
    "Msg": "To address is not valid!",
    "Data": -3
}

输入2：
{
	"FromWalletAddress":"0x03183a5c78434860d5e021d98155a55dd577a97a",
	"CurrencyType":100,
	"ChainID":2,
	"ToWalletAddress":"0x41cb7db0e682986a9368f40f63fd1377ec28f9ef",
	"TransferValue":"10000000000000000000000",
	"UserTypeID":10
}

输出2：
{
    "Code": 1,
    "Msg": "process success!",
    "Data": 1
}

# 2.	 TOKEN
## 2.1	Publish
{
  "ChainID":1,
  "TotalSupply":"1000000000000",
  "TokenName":"tokne_test2",
  "Symbol":"token",
  "Decimals":"18",
  "Address":"0xBf73abE70307C61c0661A69d49e14358c837387c",
  "Gas":"1000000000",
  "BackUrl":""
}

## 2.2 List
输入：
{
  "openId":"13671927744"
}
输出：
{
    "Code": 1,
    "Msg": "",
    "Data": []
}

## 2.2 Transfer
输入：
{
  "TokenAddress":"0x7b6a1b454cb1245e698ce73029c7fcccd5cd4464",
  "ChainID":"2",
  "Address":"0x03183a5c78434860d5e021d98155a55dd577a97a",
  "AddressTo":"0xd9d48f3d2e138245862e3e6fd997c5cd27ccd237",
  "AmountInHex":"2710",
  "BackUrl":"http://api.ju3ban.net/token/callback/"
}
输出：
{
    "Code": 1,
    "Msg": "Transfer Waiting",
    "Data": "0x79085a9abe2f6af3011370fbbcfc9ed1ffa3cba46bf95291a000e68b50ea3ffa"
}

网络查询
https://rinkeby.etherscan.io/tx/0x79085a9abe2f6af3011370fbbcfc9ed1ffa3cba46bf95291a000e68b50ea3ffa

## 2.3  TransferEvent【无效函数】
输入：
{
  "TokenAddress":"0x7b6a1b454cb1245e698ce73029c7fcccd5cd4464",
  "Address":"0x03183a5c78434860d5e021d98155a55dd577a97a",
  "ChainID":"2"
}
输出：
{
    "Code": 0,
    "Msg": "",
    "Data": null
}


## 2.4 GetBalance
输入：
{
  "TokenAddress":"0x7b6a1b454cb1245e698ce73029c7fcccd5cd4464",
  "ChainID":2,
  "Address":"0x03183a5c78434860d5e021d98155a55dd577a97a"
}
输出：
{
    "Code": 1,
    "Msg": "",
    "Data": "500000009999999999999979488"
}













# 10 问题
## 10.1 传递给钱包的用户唯一ID标识是什么格式呢？
文档建议： 建议采用平台统一前缀（如健康链：HDC）+手机号码 构成用户的唯一OpenID

## 10.2 判断目标地址是否是DB内地址的函数呢？
文档建议： 建议增加一个。

## 10.3 如果是DB外地址转账给DB内地址，DB内地址如何触发通知呢？
DB内地址给DB内地址转TransferInDB,不上链的话，不会触发回调函数，如何处理？
- 系统自己处理。
DB内地址转账给DB外地址Transfer，上链，触发回调函数，完成后发送端会收到通知。
DB内地址给DB内地址转,上链的话，触发回调函数，发送端收到通知，接受端呢？


## 10.4 需要能够监控CLB的所有持仓账户余额情况？




