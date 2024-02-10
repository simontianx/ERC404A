// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import "forge-std/Test.sol";
import {Example} from "../contracts/Example.sol";
import "./utils/Utils.sol";
import {console} from "forge-std/console.sol";

contract ExampleTest is Test {
    error NotFound();

    Example public token;

    Utils internal utils;
    address[] internal users;
    address internal treasury;
    address internal user1;
    address internal user2;
    address internal user3;
    address internal user4;
    address internal user5;

    function setUp() public {
        utils = new Utils();
        users = utils.createUsers(10);
        treasury = users[0];
        user1 = users[1];
        user2 = users[2];
        user3 = users[3];
        user4 = users[4];
        user5 = users[5];
        vm.prank(user1);
        token = new Example(user1);
    }

    function test_EXM_Deployment() public {
        assertEq(token.name(), "Example");
        assertEq(token.symbol(), "EXM");
        assertEq(token.totalSupply(), 10000000000000000000000);
        assertEq(token.decimals(), 18);
        assertEq(token.owner(), user1);
        assertEq(token.minted(), 0);
        assertTrue(token.whitelist(user1));
        assertEq(token.balanceOf(user1), 10000000000000000000000);
    }

    function test_EXM_Transfer_Success() public {
        vm.prank(user1);
        token.transfer(user2, 10000000000000000000);
        assertEq(token.balanceOf(user1), 9990000000000000000000);
        assertEq(token.balanceOf(user2), 10000000000000000000);
        assertEq(token.minted(), 10);
        uint256[] memory nfts = token.getNFTs(user2);
        assertEq(nfts.length, 10);
        for (uint256 i = 1; i < 11; i++) {
            assertEq(token.ownerOf(i), user2);
            assertEq(token.getNFTIndex(nfts[i-1]), i-1);
        }
    }

    function test_EXM_Transfer_BurnNFT_Success() public {
        vm.prank(user1);
        token.transfer(user2, 10000000000000000000);
        vm.prank(user2);
        token.transfer(user3, 1500000000000000000);
        assertEq(token.balanceOf(user2), 8500000000000000000);
        assertEq(token.balanceOf(user3), 1500000000000000000);
        assertEq(token.minted(), 11);
        for (uint256 i = 1; i < 9; i++) {
            assertEq(token.ownerOf(i), user2);
        }
        vm.expectRevert(NotFound.selector);
        token.ownerOf(9); // Burned
        vm.expectRevert(NotFound.selector);
        token.ownerOf(10); // Burned
        assertEq(token.ownerOf(11), user3);
    }

    function test_EXM_SwapPosition_Success() public {
        vm.prank(user1);
        token.transfer(user2, 10000000000000000000);
        vm.prank(user2);
        token.swapPosition(10, 1);
        token.swapPosition(9, 2);
        uint256 index_1 = token.getNFTIndex(1);
        uint256 index_2 = token.getNFTIndex(2);
        uint256 index_9 = token.getNFTIndex(9);
        uint256 index_10 = token.getNFTIndex(10);
        assertEq(index_1, 9);
        assertEq(index_2, 8);
        assertEq(index_9, 1);
        assertEq(index_10, 0);
    }

    function test_EXM_SwapPosition2_Success() public {
        vm.prank(user1);
        token.transfer(user2, 10000000000000000000);
        vm.startPrank(user2);
        token.swapPosition(10, 1);
        token.swapPosition(9, 2);
        token.transfer(user3, 1500000000000000000);
        vm.expectRevert(NotFound.selector);
        token.ownerOf(1); // Burned
        vm.expectRevert(NotFound.selector);
        token.ownerOf(2); // Burned
        assertEq(token.ownerOf(11), user3);
    }
}
