// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Donate} from "../src/Donate.sol";
import {MyErc20} from "../src/MyErc20.sol";

contract DonateTest is Test {
   Donate public donate;
   MyErc20 public token;
   address admin = makeAddr("admin");
   address alice = makeAddr("alice");

    function setUp() public {
        token = new MyErc20();
        donate = new Donate();
        donate.setToken(address(token));
        deal(alice, 10000 ether);
        token.mint(admin,10000000000);
        token.mint(alice,10000000000);
    }

    function test_storeUrl() public {
        vm.startPrank(admin);
        {
            donate.storeUrl("https://y1cunhui.github.io");
            address user = donate.urlToCreator("https://y1cunhui.github.io");
            console.log("user:",user);
            assert(user==admin);
        }
        vm.stopPrank();
    }

    function test_reward(uint amount) public{
        vm.startPrank(alice);
        {
            token.approve(address(donate),amount);
            donate.reward("https://y1cunhui.github.io",amount);
            uint balance = donate.donateBalances(address(admin));
            console.log("balance:",balance);
        }
        vm.stopPrank();
    }

    function test_total() public {
        test_storeUrl();
        test_reward(10000);
    }
}