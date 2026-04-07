// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * SeniorToken
 * 
 * Represents the senior tranche in the music royalty tokenization structure.
 * Holders of this token have a priority claim on royalty cash flows and are
 * exposed to lower risk compared to junior participants.
 */

contract SeniorToken {

    string public name = "Senior Music Royalty Token";
    string public symbol = "SNR";
    uint public totalSupply;

    address public owner;

    mapping(address => uint) public balanceOf;

    constructor(uint _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
    }

    /*
     * Transfer token ownership
     */
    function transfer(address _to, uint _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        return true;
    }

    /*
     * Senior tokens are designed to have priority in cash flow allocation.
     * This property is enforced externally by the RoyaltyDistributor contract.
     */
}