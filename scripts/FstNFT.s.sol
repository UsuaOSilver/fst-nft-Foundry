// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/FstNFT.sol";

contract MyScript is Script {
    function run() external {
        vm.startBroadcast();
        
        FstNFT nft = new FstNFT("FstNFT", "FST", "baseUri");
        
        vm.stopBroadcast();
    }
}