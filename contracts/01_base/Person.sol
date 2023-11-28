// SPDX-License-Identifier: NO LICENSE
pragma solidity ^0.8.20;

contract Person {
  struct Person {
    string name;
    uint age;
  }

  Person public moi;

  Person[] public people;

  function modifyPerson(string memory _name, uint _age) public {
    moi.name = _name;
    moi.age= _age;
  }

  function add(string memory _name, uint _age) public {
    people.push(Person(_name, _age));
  }

  function emove() public {
    people.pop();
  }
}