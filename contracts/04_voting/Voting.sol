// SPDX-License-Identifier: NO LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {
  struct Voter {
    bool isRegistered;
    bool hasVoted;
    uint votedProposalId;
  }
  struct Proposal {
    string description;
    uint voteCount;
  }  
  enum WorkflowStatus {
    RegisteringVoters,
    ProposalsRegistrationStarted,
    ProposalsRegistrationEnded,
    VotingSessionStarted,
    VotingSessionEnded,
    VotesTallied
  }

  mapping (address => Voter) public voter;
  Proposal[] _proposals;
  uint _winningProposalId;
  WorkflowStatus _status;

  event VoterRegistered(address voterAddress); 
  event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
  event ProposalRegistered(uint proposalId);
  event Voted (address voter, uint proposalId);

  // L'addr qui déploie est l'owner du SC
  constructor() Ownable(msg.sender) {
    // On whitelist l'owner
    voter[msg.sender] = Voter(true, false, 0);
    // On initialise la phase de registring
    _status = WorkflowStatus.RegisteringVoters;
  }

  function getStatus() external view returns (uint) {
    return uint(_status);
  }

  function setStatus(uint _value) external onlyOwner {
    // check
    require(uint(WorkflowStatus.VotesTallied) >= _value, "Incorrect workflow status value");
    // effect
    uint previousStatus = uint(WorkflowStatus(_status));
    _status = WorkflowStatus(_value);
    // interraction
    emit WorkflowStatusChange(WorkflowStatus(previousStatus), WorkflowStatus(_value));
  }

  // Whitelist une liste d'addr
  function whitelist(address[] memory _voters) external onlyOwner {
    // Check
    require(_voters.length > 0, "Please fill addresses");

    // Effect
    for (uint i = 0; i < _voters.length; i++) {
      // Check
      require(_voters[i] != address(0), "Cannot register zero address");
      require(voter[_voters[i]].isRegistered != true, "Account already registered");
      // Effect
      voter[_voters[i]] = Voter(true, false, 0);
      // Interraction
      emit VoterRegistered(_voters[i]);
    }

    // Interraction
    emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
  }

  function getProposal(uint _index) external view returns (Proposal memory) {
    // check
    require(_index < _proposals.length, "Incorrect proposal index");
    return _proposals[_index];
  }

  function addProposal(string memory _desc) external {
    // check
    require(_status == WorkflowStatus.ProposalsRegistrationStarted, "Have to wait the Proposals Registration phase");
    require(voter[msg.sender].isRegistered == true, "You have to be registered to send a proposal");
    // effect
    _proposals.push(Proposal(_desc, 0));
    // interraction
    emit ProposalRegistered(_proposals.length - 1);
  }

  function vote(uint _proposalId) external {
    // check
    require(_status == WorkflowStatus.VotingSessionStarted, "Have to wait the Voting phase");
    require(voter[msg.sender].isRegistered == true, "You have to be registered to send a proposal");
    require(voter[msg.sender].hasVoted == false, "You already have voted");
    require(_proposalId < _proposals.length, "Incorrect proposal index");

    // effect
    voter[msg.sender].hasVoted = true;
    voter[msg.sender].votedProposalId = _proposalId;
    _proposals[_proposalId].voteCount++;

    // interraction
    emit Voted(msg.sender, _proposalId);
  }

  function TallyVotes() external onlyOwner {
    // check
    require(WorkflowStatus(_status) == WorkflowStatus.VotingSessionEnded, "Vote phase must be stoped before tallying");

    // effect
    uint bestVoteCount = 0;
    for (uint i = 0; i < _proposals.length; i++) {
      if (_proposals[i].voteCount > bestVoteCount) {
        bestVoteCount = _proposals[i].voteCount;
        _winningProposalId = i;
      }
    }
  }

  function getWinner() external view returns (Proposal memory) {
    require(WorkflowStatus(_status) == WorkflowStatus.VotesTallied, "Have to wait votes tallied");
    return _proposals[_winningProposalId];
  }
}