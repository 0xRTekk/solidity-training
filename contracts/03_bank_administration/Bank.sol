// SPDX-License-Identifier: NO LICENSE
pragma solidity ^0.8.20;

/**
TP Bank :
- Votre smart contract doit s’appeler “Bank”. 
- Votre smart contract doit utiliser la dernière version du compilateur.
- Votre smart contract doit définir un mapping _balances qui détient le solde détenu par un compte.
- Votre smart contract doit définir une fonction deposit qui permet à son appelant de déposer de l’argent dans son compte. Elle prend comme paramètre un uint _amount.
- Votre smart contract doit définir une fonction transfer qui permet à son appelant de transférer de l’argent de son propre compte à un autre compte. Elle prend comme paramètre une address _recipient et un uint _amount.
- Votre smart contract doit définir une fonction balanceOf qui renvoie le solde détenu par un compte. Elle prend comme paramètre une address _address. 
 */
contract Bank {
  mapping(address => unit256) private _balances;

  event Deposit(address account, uint256 amount);
  event Transfer(address from, address to, uint256 amount);

  function deposit(uint _amount) public {
    require(_amount > 0, "Must deposit someting");
    _balances[msg.sender] += _amount;
    emit Deposit(msg.sender, _amount);
  }

  function transfer(address _recipient, uint _amount) public {
    // PATTERNE CHECK - EFFECT - INTERRACTION

    // CHECK
    require(_recipient != address(0), "Don't throw your money please");
    require(_balance[msg.sender] > _amount, "You don't have enought");

    // EFFECT
    _balances[msg.sender] -= _amount;
    _balances[_recipient] += _amount;

    // INTERRACTION
    emit Transfer(msg.sender, _recipient, _amount);
  }

  function balanceOf(address _address) public returns(uint256) {
    return _balances[_address];
  }
}