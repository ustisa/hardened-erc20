// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {RealityCheckToken} from "../src/RealityCheckToken.sol";

contract RealityCheckTokenTest is Test {
    RealityCheckToken token;
    address user = address(0xBEEF);

    function setUp() public {
        token = new RealityCheckToken("Reality Check", "REAL", 1_000_000 ether);
    }

    function testOwnerCanMint() public {
        token.mint(user, 100 ether);
        assertEq(token.balanceOf(user), 100 ether);
    }

    function testCannotExceedCap() public {
        token.mint(user, 1_000_000 ether);
        vm.expectRevert();
        token.mint(user, 1);
    }

    function testUserCanBurn() public {
        token.mint(user, 100 ether);
        vm.prank(user);
        token.burn(50 ether);
        assertEq(token.balanceOf(user), 50 ether);
    }
}
