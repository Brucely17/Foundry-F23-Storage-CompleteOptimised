// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from './HelperConfig.sol';
contract DeployFundMe is Script{


    function run() external returns (FundMe){
        //Before broadcast _> not real transaction,no gas
        HelperConfig helperConfig=new HelperConfig();
        address ethUsdPriceFeed=helperConfig.activeNetworkConfig();

        //After broadcast is real transaction
        vm.startBroadcast();
        //Mock contract - Helperconfig.sol
        // FundMe fundme =new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
FundMe fundme =new FundMe(ethUsdPriceFeed);
        // new FundMe();
        vm.stopBroadcast();
        return fundme;

    }
}