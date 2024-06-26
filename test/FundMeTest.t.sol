// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test{
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

    function testMinimumDollarIsFive() public{
        assertEq(fundme.MINIMUM_USD(),5e18);
    }

    function testOwnerIsMsgSender() public{
        // console.log(fundme.i_owner());
        // console.log(msg.sender);
        // assertEq(fundme.i_owner(),msg.sender);
        assertEq(fundme.getOwner(),msg.sender);
    }

    function testPriceFeedVersion() public{
        uint256 version=fundme.getVersion();
        assertEq(version,4);
    }

    function testFundFailsWithoutEnoughETH() public{
        vm.expectRevert(); //the next line should revert
        //assert (this tx fails/reverts)
        fundme.fund();//send 0 value ETH
    }

    function testFundUpdatesFundedDataStructure() public{
        vm.prank(USER);//The next tx wiil be sent by USER,its taken from cheatcode rference of foundrybook

        fundme.fund{value:SEND_VALUE}();

        uint256 amountFunded =fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded,SEND_VALUE);
        }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundme.fund{value:SEND_VALUE}();

        address funder =fundme.getFunder(0);
        assertEq(funder,USER);
    }

    modifier funded(){
        vm.prank(USER);
        fundme.fund{value:SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded{
       

        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }



    function testWithDrawWithASIngleFunder() public funded{
        //Arrange
        uint256 startingOwnerBalance=fundme.getOwner().balance;
        uint256 startingFundMeBalance =address(fundme).balance;




        //Act

        uint256 gasStart=gasleft(); //built in function to know gas left in transaction 
        vm.txGasPrice(GAS_PRICE); 
        vm.prank(fundme.getOwner());
        fundme.withdraw();

        uint256 gasEnd=gasleft();
        uint256 gasUsed=(gasStart-gasEnd)*tx.gasprice;
        console.log(gasUsed);

        //Assert

        uint256 endingOwnerBalance=fundme.getOwner().balance;
        uint256 endingFundMeBalance =address(fundme).balance;
        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance+startingOwnerBalance,endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded{

        uint160 numberOfFunders=10;//if we have to generate address from numbers we have to use uint160
        uint160 startingFunderIndex=1;

        for (uint160 i=startingFunderIndex; i<numberOfFunders; i++){
            //vm.prank
            //vm.deal
            //prank and deal combined chaetcode - hoax
            hoax(address(i),SEND_VALUE);
            fundme.fund{value:SEND_VALUE}();

              uint256 startingOwnerBalance=fundme.getOwner().balance;
        uint256 startingFundMeBalance =address(fundme).balance;

//Act
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();
//assert
        assert(address(fundme).balance==0);
        assert(
            startingFundMeBalance + startingOwnerBalance == fundme.getOwner().balance
        );

        }
    }


    function testCheaperWithdrawFromMultipleFunders() public funded{

        uint160 numberOfFunders=10;//if we have to generate address from numbers we have to use uint160
        uint160 startingFunderIndex=1;

        for (uint160 i=startingFunderIndex; i<numberOfFunders; i++){
            //vm.prank
            //vm.deal
            //prank and deal combined chaetcode - hoax
            hoax(address(i),SEND_VALUE);
            fundme.fund{value:SEND_VALUE}();

              uint256 startingOwnerBalance=fundme.getOwner().balance;
        uint256 startingFundMeBalance =address(fundme).balance;

//Act
        vm.startPrank(fundme.getOwner());
        fundme.cheaperWithdraw();
        vm.stopPrank();
//assert
        assert(address(fundme).balance==0);
        assert(
            startingFundMeBalance + startingOwnerBalance == fundme.getOwner().balance
        );

        }
    }
}




