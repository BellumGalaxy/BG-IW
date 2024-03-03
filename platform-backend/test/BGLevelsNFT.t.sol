// License SPX-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {BellumGalaxyEvolution} from "../src/BellumGalaxyEvolution.sol";
import {DeployBGEvolution} from "../script/DeployBGEvolution.s.sol";

contract FundeMeTest is Test{
	DeployBGEvolution deployEvo;
    BellumGalaxyEvolution evolution;
	
	address BARBA = makeAddr("BARBA");

    modifier initiateLevels(){
        evolution.addOrAdjustLevels(0, 0);
        evolution.addOrAdjustLevels(1, 2_000);
        evolution.addOrAdjustLevels(2, 5_000);
        evolution.addOrAdjustLevels(3, 10_000);
        evolution.addOrAdjustLevels(4, 15_000);
        evolution.addOrAdjustLevels(5, 20_000);
        evolution.addOrAdjustLevels(6, 25_000);

        vm.prank(BARBA);
        evolution.safeMint();
        _;
    }

	function setUp() external{
		deployEvo = new DeployBGEvolution();
		evolution = deployEvo.run();
	}
    
    error BellumGalaxyEvolution__ThereAreOnlyFiveLevels();
    function testLevelsOverflow() public initiateLevels{
        vm.expectRevert(BellumGalaxyEvolution__ThereAreOnlyFiveLevels.selector);
        evolution.addOrAdjustLevels(7, 35_000);
    }

    function testSafeMint() public {
        vm.prank(BARBA);
        evolution.safeMint();

        uint256 totalTokens = evolution.balanceOf(BARBA);

        assertEq(totalTokens, 1);
    }

    function testGetNftLevel() public initiateLevels{
        uint256 nftLevel = evolution.getNFTLevel(0);

        assertEq(nftLevel, 0);
    }

    error BellumGalaxyEvolution__InvalidNFTId();
    function testUpdateNFTReverts() public {
        vm.expectRevert(BellumGalaxyEvolution__InvalidNFTId.selector);
        evolution.updateNFT(50, 100);
    }

    function testIfLevelUp() public initiateLevels {
        evolution.updateNFT(0, 2001);
        uint256 nftLevelOne = evolution.getNFTLevel(0); //2001
        assertEq(nftLevelOne, 1);

        evolution.updateNFT(0, 3000);
        uint256 nftLevelTwo = evolution.getNFTLevel(0); //5001
        assertEq(nftLevelTwo, 2);

        evolution.updateNFT(0, 5000);
        uint256 nftLevelThree = evolution.getNFTLevel(0); // 10001
        assertEq(nftLevelThree, 3);

        evolution.updateNFT(0, 5000);
        uint256 nftLevelFour = evolution.getNFTLevel(0); // 15001
        assertEq(nftLevelFour, 4);

        evolution.updateNFT(0, 5000);
        uint256 nftLevelFive = evolution.getNFTLevel(0); // 20001
        assertEq(nftLevelFive, 5);

        evolution.updateNFT(0, 5000);
        uint256 nftLevelSix = evolution.getNFTLevel(0); // 25001
        assertEq(nftLevelSix, 6);
    }
}