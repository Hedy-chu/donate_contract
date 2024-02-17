// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import"@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract MyErc20 is ERC20{
    constructor() ERC20("MyToken","MYT"){
    }

    function decimals() public pure override  returns (uint8) {
        return 6;
    }

    function mint(address to, uint amount) public {
        _mint(to, amount);
    }
}