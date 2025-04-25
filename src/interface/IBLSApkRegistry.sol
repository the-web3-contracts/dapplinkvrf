// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "../libraries/BN254.sol";

interface IBLSApkRegistry {
    struct VrfNoSignerAndSignature {
        BN254.G1Point[] nonSignerPubKeys;
        BN254.G2Point apkG2;
        BN254.G1Point sigma;
        uint256 totalDappLinkStake;
        uint256 totalBtcStake;
    }

    struct ApkUpdate {
        bytes24 apkHash;
        uint32 updateBlockNumber;
        uint32 nextUpdateBlockNumber;
    }

    struct PubkeyRegistrationParams {
        BN254.G1Point pubkeyRegistrationSignature;
        BN254.G1Point pubkeyG1;
        BN254.G2Point pubkeyG2;
    }

    struct StakeTotals {
        uint256 totalDappLinkStake;
        uint256 totalBtcStake;
    }

    event NewPubkeyRegistration(address indexed operator, BN254.G1Point pubkeyG1, BN254.G2Point pubkeyG2);

    event OperatorAdded(address operator, bytes32 operatorId);

    event OperatorRemoved(address operator, bytes32 operatorId);


    function registerOperator(address operator) external;

    function deregisterOperator(address operator) external;

    function registerBLSPublicKey(
        address operator,
        PubkeyRegistrationParams calldata params,
        BN254.G1Point memory msgHash
    ) external returns (bytes32);

    function checkSignatures(bytes32 msgHash, uint256 referenceBlockNumber, VrfNoSignerAndSignature memory params) external view returns (StakeTotals memory, bytes32);

    function getRegisteredPubkey(address operator) external view returns (BN254.G1Point memory, bytes32);

    function addOrRemoveBlsRegisterWhitelist(address operator, bool isAdd) external;

    function getPubkeyRegMessageHash(address operator) external view returns (BN254.G1Point memory);
}
