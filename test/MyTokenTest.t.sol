// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test } from "forge-std/Test.sol";
import { DeployMyToken } from "script/DeployMyToken.s.sol";
import { MyToken } from "src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    DeployMyToken public deployer;

    address mra = makeAddr("mra");
    address mahla = makeAddr("mahla");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();

        vm.prank(msg.sender);
        myToken.transfer(mra, STARTING_BALANCE);
    }

    function testMRABalance() public view {
        assertEq(STARTING_BALANCE, myToken.balanceOf(mra)); // we transfer mra the starting balance in sutUp function
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;

        //* MRA approves Mahla to spend tokens on his begalf
        vm.prank(mra);
        myToken.approve(mahla, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(mahla);
        myToken.transferFrom(mra, mahla, transferAmount);

        assertEq(myToken.balanceOf(mahla), transferAmount);
        assertEq(myToken.balanceOf(mra), STARTING_BALANCE - transferAmount);
    }

    function testTransfer() public {
        uint256 amount = 1000;
        address receiver = address(0x1);
        vm.prank(msg.sender);
        myToken.transfer(receiver, amount);
        assertEq(myToken.balanceOf(receiver), amount);
    }

    function testBalanceAfterTransfer () public {
        uint256 amount = 1000;
        address receiver = address(0x1);
        uint256 initialBalance = myToken.balanceOf(msg.sender);
        vm.prank(msg.sender);
        myToken.transfer(receiver, amount);
        assertEq(myToken.balanceOf(msg.sender), initialBalance - amount);
    }

    function testTransferFrom() public {
        uint256 amount = 1000;
        address receiver = address(0x1);

        vm.prank(msg.sender);
        myToken.approve(address(this), amount);
        myToken.transferFrom(msg.sender, receiver, amount);
        assertEq(myToken.balanceOf(receiver), amount);
    }
}