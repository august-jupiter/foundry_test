// SPDX-License-Identifier UNLICENSED

pragma solidity ^0.8.13;

import {MyErcToken} from "../src/MyErcToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract MyErcTokenTest is Test {
    MyErcToken public token;
    address payable public user1;


    function setUp() public {
        token = new MyErcToken();
        user1 =  payable(address(1));
    }

    function test_Name() public view {
        assertEq(token.name(), "AUGUST");
    }

    function test_deposit() public {
        deal(user1, 100 ether);
        vm.prank(user1);
        token.deposit{value: 10 ether}();

        assertEq(address(token).balance, 10 ether);
        assertEq(token.balanceOf(user1), 90 ether);
    }

    function test_balanceOfBeginning() public view{
        uint balance = token.balanceOf(address(this));
        assertEq(balance, 0);
    }

    function test_TransferInsufficientBalance() public {
        vm.prank(user1);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientBalance.selector, user1, 0, 10 ether
            )
        );        
        token.transfer(address(this), 10 ether);
    }

    function test_Transfer_success() public {
        deal(address(token), user1, 100 ether);
        vm.prank(user1);
        token.transfer(address(this), 10 ether);
        assertEq(token.balanceOf(address(this)), 10 ether);
        assertEq(token.balanceOf(user1), 90 ether);
    }

    function test_CanNotTransferToZero() public {
        deal(address(token), user1, 100 ether);
        vm.startPrank(user1);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InvalidReceiver.selector, address(0)
            )
        );
        token.transfer(address(0), 0 ether);
        vm.stopPrank();
    }

    function test_CustomTransfer() public {
        vm.expectRevert(bytes("Amount must be greater than 1 ether"));
        token.customTransfer(0.5 ether);
    }

    function test_CustomError() public {
        vm.expectRevert();
        token.customTransfer(0.5 ether);
    }

    function test_TransferEmit() public {
        deal(address(token), user1, 100 ether);
        
        vm.expectEmit(true, true, true, true);
        emit IERC20.Transfer(user1, address(this), 11 ether);

        vm.startPrank(user1);
        token.transfer(address(this), 10 ether);
        vm.stopPrank();
    }

    // topics为什么是3个， 参考 https://docs.soliditylang.org/en/v0.8.15/abi-spec.html?highlight=events#events
    function test_CustomEvent() public {
        vm.expectEmit(true, false, false, true);
        emit MyErcToken.CustomEventOne(user1, user1);
        vm.expectEmit(true, false, false, true);
        emit MyErcToken.CustomEventTwo(user1, user1, 100, block.timestamp);
        vm.prank(user1);
        token.customEmit();
    }
}