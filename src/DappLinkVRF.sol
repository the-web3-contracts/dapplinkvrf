// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract DappLinkVRF is Initializable, OwnableUpgradeable {
    struct RequestStatus {
        bool fulfilled;
        uint256[] randomWords;
    }

    uint256[] public requestIds;
    uint256 public lastRequestId;
    address public dappLinkAddress;

    mapping(uint256 => RequestStatus) public requestMapping;

    event RequestSent(
        uint256 requestId,
        uint256 _numWords,
        address current
    );

    event FillRandomWords(
        uint256 requestId,
        uint256[] randomWords
    );

    modifier onlyDappLink() {
        require(msg.sender == dappLinkAddress, "DappLinkVRF.onlyDappLink");
        _;
    }

    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner, address _dappLinkAddress) public initializer {
        __Ownable_init(initialOwner);
        dappLinkAddress = _dappLinkAddress;
    }

    function requestRandomWords(uint256 _requestId, uint256 _numWords) external onlyOwner {
        requestMapping[_requestId] = RequestStatus({
            randomWords: new uint256[](0),
            fulfilled: false
        });
        requestIds.push(_requestId);
        lastRequestId = _requestId;
        emit RequestSent(_requestId, _numWords, address(this));
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) external onlyDappLink {
        requestMapping[_requestId] = RequestStatus({
            fulfilled: true,
            randomWords: _randomWords
        });
        emit FillRandomWords(_requestId, _randomWords);
    }

    function getRequestStatus(uint256 _requestId) external view returns (bool fulfilled, uint256[] memory randomWords){
        return (requestMapping[_requestId].fulfilled, requestMapping[_requestId].randomWords);
    }

    function setDappLink(address _dappLinkAddress) public onlyOwner {
        dappLinkAddress = _dappLinkAddress;
    }
}
