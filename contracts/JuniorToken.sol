// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * JuniorToken
 * 
 * Represents the junior tranche in the music royalty tokenization structure.
 * Holders of this token receive residual cash flows after senior obligations
 * are satisfied, and therefore bear higher risk with potential upside.
 */

contract JuniorToken {

    string public name = "Junior Music Royalty Token";
    string public symbol = "JNR";
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
     * Junior tokens receive residual cash flows and absorb volatility.
     * Their payoff depends on the performance of the underlying royalty asset.
     */
}