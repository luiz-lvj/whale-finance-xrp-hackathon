// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "../src/MockERC20.sol";
import "../src/WhaleFinance.sol";

contract Create is Script {
    MockERC20 public token;
    MockERC20 public weth;


    function setUp() public {}

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address target = 0xB0Eb2a4CDf7be2D0c408cF60Ed8ba1065920b339;

        MockERC20 tokenA = new MockERC20("DOT", "DOT");
        MockERC20 tokenB = new MockERC20("WBTC", "WBTC");

        tokenA.mint(target, 3000 ether);
        tokenB.mint(target, 3000 ether);

        console.log("DOT Address: ", address(tokenA));
        console.log("WBTC Address: ", address(tokenB));


        vm.stopBroadcast();
        
    }
}