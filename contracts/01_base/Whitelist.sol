// SPDX-License-Identifier: NO LICENSE
pragma solidity ^0.8.20;

contract Whitelist {
  mapping (address => bool) whitelist;
  event Authorized(address _address);

  constructor() {
    whitelist[msg.sender] = true;
  }

  function authorize(address _addr) public check {
    require(_addr != "0x0000000000000000000000000000000000000000", "Cannot authorize null address !");
    whitelist[_addr] = true;
    emit Authorized(_addr);
  }

  modifier check() {
    require(whitelist[msg.sender] == true, "You're not authorized to add in the whitelist");
    _;
  }
}