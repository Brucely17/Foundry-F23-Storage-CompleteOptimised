//Deploy mocks when awe are on a local anvil vhain
//Keep track of contract address across different chains
//Sepolia ETH/USD
//Mainnet ETH/USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //If we are on a local anvil ,we deploy mocks
    //Otherwise ,grab te existing address from live network
NetworkConfig public activeNetworkConfig;
    struct NetworkConfig{
        address priceFeed; //ETH/USD price feed address
    }
    constructor (){
        if (block.chainid==11155111){
            activeNetworkConfig=getSepoliaEthConfig();
        }
        else if (block.chainid==1){
            activeNetworkConfig=getMainnetEthConfig();
        }
        else{
            activeNetworkConfig=getAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
        //price feed address
        NetworkConfig memory sepoliaConfig=NetworkConfig({
            priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
return sepoliaConfig;
    }
    function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory mainConfig=NetworkConfig({
            priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainConfig;
    }

    function getAnvilEthConfig()  public returns (NetworkConfig memory){
        //1.Deploy mocks
        //2.Return mock address
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed=new MockV3Aggregator(8,200e8);

        vm.stopBroadcast();
        NetworkConfig memory anvilConfig=NetworkConfig({
            priceFeed:address(mockPriceFeed)
        });
        return anvilConfig;

    }
}