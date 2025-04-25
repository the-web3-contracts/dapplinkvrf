// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../../interface/IBLSApkRegistry.sol";

abstract contract DappLinkVRFStorage {
    struct RequestStatus {
        bool fulfilled;
        uint256[] randomWords;
    }
    uint256[] public requestIds;
    uint256 public lastRequestId;
    address public dappLinkAddress;

    IBLSApkRegistry public blsRegistry;

    mapping(uint256 => RequestStatus) public requestMapping;

    uint256[100] private slot;
}
