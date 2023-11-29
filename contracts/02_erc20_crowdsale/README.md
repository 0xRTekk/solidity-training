# TP Crowdale / ICO

## ERC20

- Dans le state de ce SC on mémorise Le nom du token, son symbole, nom de décimales (18 par défaut) et sa total supply.
- Un `mapping (address => uint256) balance`
- Il peut être interessant de définir la `totalSupply` lors du déploiement du SC => dans le `constructor()`
- On a une fonction `balanceOf(addr)` pour connaitre la balance d'un wallet
- Une fonction `transfer(to, amount)` => quand une adresse l'execute, va envoyer ses fonds vers une autre spécifiée en argument
- Une fonction `approval(spender, amount)` pour autoriser une autres adresse à utiliser un montant de sa balance => Utile pour autoriser un autre SC (de DeFi par ex) de bouger ses tokens pour du staking
- `mapping(address account => mapping(address spender => uint256)) allowances` => connaitre le montant autorisé pour chaque addr pour chaque compte

## Crowdsale

C'est le SC d'ICO. Au déploiement il va créer une nouvelle instance du token en définissant son intial supply.

On pourrait faire autrement : Créer/minter des tokens uniquement lorsque des investisseurs envoient des eth au contract.
Mais par défaut c'est comme ça que ça fonctionne !

- Au déploiement, le SC va créer une new instance du ERC20 en lui renseignant son initial supply
- Lors de la création de l'instance du ERC20, cette initialSupply est mint sur le SC Crowdsale
- Lorsqu'un wallet envoi des eth au SC, on calcul sa reward avec le rate et on lui envoi
  - On a une fonction `receive()` qui est executé lorsque que le SC recoit des eth
  - Et une fonction `distribute()` qui va faire la calcul puis l'envoi des tokens au wallet

Le code implémenté est simpliste mais permet de comprendre la mécanique d'ICO.  
On peut évidemment rajouter des choses :

- Un système de withdrawal à la place du distribute
- Withdrawal qui se débloque qu'après un certain montant investi
- Une période d'attente avant la dispo du withdrawal
- Mémoriser l'investissement total
- Mémoriser l'investissement de chaque addr
- Avoir un rate différents pour les addr selon certains critère (amount invetsi, OG, etc)
- etc
