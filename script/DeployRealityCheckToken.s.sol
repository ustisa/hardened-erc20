// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {RealityCheckToken} from "../src/RealityCheckToken.sol";

contract DeployRealityCheckToken is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.parseUint(vm.envString("PRIVATE_KEY"));

        vm.startBroadcast(deployerPrivateKey);

        // Deploy the token
        new RealityCheckToken("RealityCheckToken", "RealityCheckToken", 1_000_000 * 10 ** 18);

        vm.stopBroadcast();
    }
}
