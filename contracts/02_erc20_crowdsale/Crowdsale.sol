// SPDX-License-Identifier: NO LICENSE
pragma solidity ^0.8.20;

import './ERC20Rtk.sol';

/**
 * @title Crowdsale
 * @author Rtekk
 * @notice A basic crowdsale SC for the ERC20Rtk token
 * @dev The SC create a new instance of the ERC20Rtk on deploy with an initial supply.
 * This supply is minted at de Crowdsale SC deployment and transfered to it.
 * See the ERC20Rtk constructor
 */
contract Crowdsale {
  uint public rate = 200;
  ERC20Rtk public token;

  constructor(uint256 initialSupply) {
    token = new ERC20Rtk(initialSupply);
  }

  // Executed function when ethers are sent to this contract (using tranfer and/or send function)
  receive() external payable {
    require(msg.value >= 0.1 ethers, "Cannot send less than 0.1 ethers");
    distribute(msg.value);
  }

  function distribute(uint256 _amount) internal {
    uint256 tokensToSent = _amount * rate;
    token.tranfer(msg.sender, tokensToSent);
  }
}