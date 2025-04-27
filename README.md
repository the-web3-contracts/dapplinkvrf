## The Web3 VRF 小型项目实战

学习目的：
- 链上如何使用随机数
- 理解 BLS 签名验证签名流程，

## Build
```
$ forge build
```

## Deploy
```shell
forge script ./script/DappLinkVRFDepoly.s.sol:DappLinkVRFDepolyScript --rpc-url https://ethereum-holesky-rpc.publicnode.com --private-key $PRIVATE_KEY --broadcast
```

## Call Function
```
cast send --rpc-url https://ethereum-holesky-rpc.publicnode.com --private-key $PRIVATE_KEY 0x21EA59025C4a16E948224D100D97c3a24706C728 "requestRandomWords(uint256,uint256)" 10000, 3
```

## Address
```
DappLink blsApkRegistry contract deployed at: 0x2bf417A46a595Facd902111c13008Cb3ECD536b7
DappLink base contract deployed at: 0xE74ee1280B0332cA7155b7d423549e4A0B5FA1cA
DappLink Proxy Factory contract deployed at: 0x6c882e1D04940A685EA8b96BC2d2c6541ea64e24
DappLink Proxy contract deployed at: 0x21EA59025C4a16E948224D100D97c3a24706C728
```
