// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {BellumGalaxyEvolution} from "../src/BellumGalaxyEvolution.sol";

contract DeployBGEvolution is Script {
    BellumGalaxyEvolution evo;
	function run() external returns(BellumGalaxyEvolution){
		
		vm.startBroadcast();
		
		evo = new BellumGalaxyEvolution();

		vm.stopBroadcast();

		return evo;
	}
}