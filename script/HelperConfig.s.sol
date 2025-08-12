// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";


contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    struct NetworkConfig {
        address priceFeed;  
        
    }
    constructor (){
        if(false){
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory SepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return SepoliaConfig;
    }
    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(8 ,2000e8);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockV3Aggregator)});
        return anvilConfig;
    }
}
     