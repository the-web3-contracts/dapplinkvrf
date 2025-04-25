// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";


import "../src/utils/EmptyContract.sol";

import "../src/contracts/vrf/DappLinkVRFManager.sol";
import "../src/contracts/DappLinkVRFFactory.sol";
import "../src/contracts/bls/BLSApkRegistry.sol";


// forge script ./script/DappLinkVRFDepoly.s.sol --rpc-url https://eth-holesky.g.alchemy.com/v2/BvSZ5ZfdIwB-5SDXMz8PfGcbICYQqwrl --private-key $PrivateKey --broadcast
contract DappLinkVRFDepolyScript is Script {
    EmptyContract public emptyContract;
    ProxyAdmin public blsApkRegistryProxyAdmin;

    BLSApkRegistry public blsApkRegistry;
    BLSApkRegistry public blsApkRegistryImplementation;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address deployerAddress = vm.addr(deployerPrivateKey);


        vm.startBroadcast();

        emptyContract = new EmptyContract();

        TransparentUpgradeableProxy proxyBlsApkRegistry = new TransparentUpgradeableProxy(address(emptyContract), deployerAddress, "");
        blsApkRegistry = BLSApkRegistry(address(proxyBlsApkRegistry));
        blsApkRegistryImplementation = new BLSApkRegistry();
        blsApkRegistryProxyAdmin = ProxyAdmin(getProxyAdminAddress(address(proxyBlsApkRegistry)));

        blsApkRegistryProxyAdmin.upgradeAndCall(
            ITransparentUpgradeableProxy(address(blsApkRegistry)),
            address(blsApkRegistryImplementation),
            abi.encodeWithSelector(
                BLSApkRegistry.initialize.selector,
                deployerAddress,
                deployerAddress,
                deployerAddress
            )
        );

        DappLinkVRFManager dappLinkVRF = new DappLinkVRFManager();
        console.log("dapplink base contract deployed at:", address(dappLinkVRF));

        DappLinkVRFFactory dappLinkVRFFactory = new DappLinkVRFFactory();
        console.log("DappLink Proxy Factory contract deployed at:", address(dappLinkVRFFactory));

        address proxyDappLink = dappLinkVRFFactory.createProxy(address(dappLinkVRF), msg.sender, address(blsApkRegistry));

        console.log("DappLink Proxy contract deployed at:", proxyDappLink);

        vm.stopBroadcast();
    }

    function getProxyAdminAddress(address proxy) internal view returns (address) {
        address CHEATCODE_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
        Vm vm = Vm(CHEATCODE_ADDRESS);

        bytes32 adminSlot = vm.load(proxy, ERC1967Utils.ADMIN_SLOT);
        return address(uint160(uint256(adminSlot)));
    }
}

