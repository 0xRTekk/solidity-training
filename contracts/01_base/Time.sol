// SPDX-License-Identifier: NO LICENSE
pragma solidity ^0.8.20;

contract Time {
  function getTime() public view returns(uint) {
    return block.timestamp;
  }
}