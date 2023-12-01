// SPDX-License-Identifier: NO LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/*
- Votre smart contract doit s'appeler “Admin”. 
- Votre smart contract doit utiliser la dernière version du compilateur.
- L’administrateur est celui qui va déployer le smart contract. 
- L’administrateur est le seul qui a le droit d’autoriser un compte Ethereum à l’aide de la fonction “whitelist”.
- L’administrateur est le seul qui a le droit de bloquer un compte Ethereum à l’aide de la fonction “blacklist”.
- Votre smart contract doit définir une fonction isWhitelisted qui retourne un compte whitelisté.
- Votre smart contract doit définir une fonction isBlacklisted qui retourne un compte blacklisté.
- Votre smart contract doit définir deux événements “Whitelisted” et “Blacklisted”.
- L’utilisation du type mapping est exigée. 
- L’utilisation d’un modifier est exigée. 
- L’import de la librairie “Ownable” d’OpenZepplin est obligatoire.
*/

contract Admin is Ownable {
  mapping (address => bool) private _whitelisted;
  mapping (address => bool) private _blacklisted;

  event Whitelisted(address _addr);
  event Blacklisted(address _addr);

  constructor() Ownable(msg.sender) {}

  function whitelist(address _addr) public onlyOwner {
    // CHECK
    require(_addr != address(0), "Cannot whitelist the address 0x0");
    // EFFECT
    _whitelisted[_addr] = true;
    _blacklisted[_addr] = false;
    // INTERRACTION
    emit Whitelisted(_addr);
  }

  function blacklist(address _addr) public onlyOwner {
    // CHECK
    require(_addr != address(0), "Cannot blacklist the address 0x0");
    // EFFECT
    _blacklisted[_addr] = true;
    _whitelisted[_addr] = false;
    // INTERRACTION
    emit Blacklisted(_addr);
  }

  function isWhitelisted(address _addr) public view returns(bool) {
    require(_addr != address(0), "Cannot whitelist the address 0x0");
    return _whitelisted[_addr];
  }

  function isBlacklisted(address _addr) public view returns(bool) {
    require(_addr != address(0), "Cannot blacklist the address 0x0");
    return _blacklisted[_addr];
  }
}