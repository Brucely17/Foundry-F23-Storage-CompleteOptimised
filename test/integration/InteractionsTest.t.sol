// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe,WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test{
     FundMe fundme;

    address USER=makeAddr("user");//we get this from cheat code refrence in foundryup
    
    uint256 constant SEND_VALUE=0.1 ether;
    uint256 constant STARTING_BALANCE=10 ether;

    uint256 constant GAS_PRICE=1 ether;

    function setUp() external {
    //    fundme=new FundMe();
       DeployFundMe deployFundMe =new DeployFundMe();
       fundme=deployFundMe.run();
       vm.deal(USER,STARTING_BALANCE);



    }

    function testUserCanFundInteractions() public{

        // FundFundMe fundFundMe=new FundFundMe();
        // vm.prank(USER);
        // vm.deal(USER,1e18);
        // fundFundMe.fundFundMe(address(fundme));

        // address funder =fundme.getFunder(0);
        // assertEq(funder,USER);
        FundFundMe fundFundMe=new FundFundMe();
        fundFundMe.fundFundMe(address(fundme));

        WithdrawFundMe withdrawFundMe=new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundme));

        assert(address(fundme).balance==0);
    }

}