// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Donate is Ownable{
    using SafeERC20 for IERC20;
    mapping(string => address) public urlToCreator;
    mapping(address => uint) public donateBalances;
    IERC20 donateToken;
   
    
    event storeUrlEvent(address creator,string url);
    event donate();
    event withdrawEvent(address creator,uint amount);

    error withdrawError();

    constructor() Ownable(msg.sender){
    }

    function setToken(address token) public onlyOwner(){
        donateToken = IERC20(token);
    }

    // Pay to the creator of the URL
    function reward(string memory url, uint amount) public payable {
        address creator = urlToCreator[url];
        require(creator != address(0), "Creator not registered");
        donateToken.safeTransferFrom(msg.sender,address(this),amount);
        donateBalances[creator] += amount;
    }

    
    function storeUrl(string memory url) public {
        require(urlToCreator[url] == address(0), "URL already stored");
        urlToCreator[url] = msg.sender;

        emit storeUrlEvent(msg.sender,url);
    }

    // Withdraw  bonus
    function withdraw() public {
        uint bonus = donateBalances[msg.sender];
        require(bonus > 0, "No bonus to withdraw");
        donateBalances[msg.sender] = 0;
        (bool success,) = payable(msg.sender).call{value: bonus}("");
        if (!success){
           revert withdrawError();
        }
        emit withdrawEvent(msg.sender,bonus);
    }

    // Get all bonus money
    function totalReward() view public returns(uint256){
        return donateToken.balanceOf(address(this));
    }

    // Get user balance
    function userBalance(address user) view  public returns(uint256){
        return donateToken.balanceOf(address(user));
    }

    receive() external payable { }

}