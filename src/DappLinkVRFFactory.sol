// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./DappLinkVRF.sol";


contract DappLinkVRFFactory {
    event ProxyCreated(address mintProxyAddress);

    function createProxy(address implementation, address dapplinkAddress) external returns (address) {
        address mintProxyAddress = Clones.clone(implementation);
        DappLinkVRF(mintProxyAddress).initialize(msg.sender, dapplinkAddress);
        emit ProxyCreated(mintProxyAddress);
        return mintProxyAddress;
    }
}
