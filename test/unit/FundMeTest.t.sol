// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundMe;
    uint160 public constant USER_NUMBER = 50;
    address public constant USER = address(USER_NUMBER);
    function setUp()  external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();        
    }
    function testMinimunUsdIsFive() public view{
        assertEq(fundMe.MINIMUM_USD(), 5e18, "hey the test is failed");
    }
    function testOwner() public view{
        assertEq(fundMe.i_owner(), msg.sender);
    }
    function testgetAddressToAmountFunded() public {
        fundMe.fund{value :100e18}();
        uint256 amount = fundMe.getAddressToAmountFunded(address(this));
        assertEq(amount,100e18);
    }
    function testAddsFunderToArrayOfFunder() public  {
        vm.prank(USER);
        vm.deal(USER, 10e18);
        fundMe.fund{value : 10e18}();
        address funder = fundMe.getFunder(0);
        assertEq(USER,funder);
    }
    modifier user {
        vm.deal(USER, 10e18);
        vm.prank(USER);
        fundMe.fund{value : 10e18}();
        vm.deal(makeAddr("siddu"), 10e18);
        vm.prank(makeAddr("siddu"));
        fundMe.fund{value : 10e18}();
        _;
    }
    function testOwnerOnlyCanWithdraw()  public user {
        
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
        console.log("got full eth");
    }

    function testgetVersion()  public  {
        assert(fundMe.getVersion() == 4);
        
    }
    function testgetFunder()  public user{
        assertEq(fundMe.getFunder(0) ,USER);
        
    }
    function testgetAddressToAmountFundedd()  public user {
        assertEq(fundMe.getAddressToAmountFunded(USER) ,10 ether);
        
    }
}