// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";

import "../src/ERC6551Registry.sol";
import "../src/SafeAccount.sol";
import "../src/interface/IERC6551Account.sol";
import "../src/WhaleFinance.sol";
import "../src/QuotaBeacon.sol";
import "../src/MockERC20.sol";

contract Deploy is Script {
    ERC6551Registry public registry;

    QuotaToken public quotaTokenImplementation;
    MockERC20 public stablecoin;
    SafeAccount public safeAccount;
    WhaleFinance public whaleFinance;
    BeaconERC20 public beacon;


    function setUp() public {}

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        whaleFinance = WhaleFinance(0xcd055c8824Ef6E9306b1F707Ce2E327ae2145c5D);

        whaleFinance.setWhiteListedToken(0x9F0a79c5A1Fb5f7E2221Ddda85362f97FF847F66);

        vm.stopBroadcast();
        
    }
}
