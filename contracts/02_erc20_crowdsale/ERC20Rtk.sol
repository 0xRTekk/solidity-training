// SPDX-License-Identifier: NO LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Rtk is ERC20 {
  constructor(uint256 initialSupply) ERC20("RTokken", "RTK"){
    _mint(msg.sender, initialSupply);
  }

  function faucet() public view {
    _mint(msg.sender, 1000);
  }
}