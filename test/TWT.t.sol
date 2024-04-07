// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";

import {TWTInterface} from "../src/TWT.sol";

contract WETHTest is Test {
    TWTInterface public twtInterface;
    address constant public aTwtAddress = 0x4B0F1812e5Df2A09796481Ff14017e6005508003;

    function setUp() public {
        twtInterface = TWTInterface(payable(aTwtAddress));
    }

    function test_LatestBalance() public {
        vm.createSelectFork("bsc-main");
        uint256 balance = twtInterface.balanceOf(0xACA49aDd0E50849e7b0e05AA6B1F697dE38e4A6b);
        console.log("balance: ", balance);
    }

    function test_BalanceOfBlockNumber() public {
        // 5519466054378060000000000
        // 5519466053378060000000000   --> 37631884
        // 5519466053378060000000000
        uint256 blockNumber = 37631884;
        vm.createSelectFork("bsc-main", blockNumber);
        uint256 balance37631884 = twtInterface.balanceOf(0xACA49aDd0E50849e7b0e05AA6B1F697dE38e4A6b);
        console.log("test_BalanceOfBlockNumber balance37631884 : ", balance37631884);

        vm.createSelectFork("bsc-main", 37630880);
        uint256 balance37631883 = twtInterface.balanceOf(0xACA49aDd0E50849e7b0e05AA6B1F697dE38e4A6b);
        console.log("test_BalanceOfBlockNumber balance37631883 : ", balance37631883);
    }


    function test_Name() public {
        vm.createSelectFork("bsc-main");
        string memory name = twtInterface.name();
        assertEq("Trust Wallet", name);
    }
}