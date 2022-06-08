// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.14;


/*
On a le droit de transférer au compte de l’argent quand on le souhaite 

1- Ajouter un admin au déploiement du contrat.

2- Ajouter la condition suivante : l'admin ne peut récupérer les fonds qu'après 3 mois après la première transaction

3- On peut évidemment rajouter de l’argent sur le contrat régulièrement.
Faire une fonction pour ça, et garder un historique (simple, d’un numero vers une quantité) des dépots dans un mapping.

4 – Mettre en commentaire les fonctions d’admin, et rajouter onlyOwner

*/

contract Epargne {

    address public admin;
    uint public firstDepositDate;
    mapping(address => uint) deposits;

    constructor() payable {
        admin = msg.sender;
        if(msg.value > 0) {
            firstDepositDate = block.timestamp;
        }
    }

    receive() external payable {
        deposits[msg.sender] = msg.value;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }


    function deposit() external payable {
        (bool sent, ) = address(this).call{value: msg.value}("");
        require(sent == true, unicode"Dépôt non effectué");
        if (firstDepositDate == 0) {
            firstDepositDate = block.timestamp;
        }
    }

    function withdraw() external payable {
        require(msg.sender == admin, "Vous n'avez pas les droits de retirer la moulaga");
        require((3 * 4 weeks) < (block.timestamp - firstDepositDate), "il faut attendre un peu plus pour retirer ta moulaga");
        (bool sent, ) = admin.call{value: address(this).balance}("");
        require(sent == true, unicode"Moulaga non retirée");
    }
}
