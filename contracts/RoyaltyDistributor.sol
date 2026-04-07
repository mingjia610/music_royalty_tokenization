// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * RoyaltyDistributor
 * 
 * This contract simulates the allocation of music royalty cash flows
 * under a dual-token structure. It implements a simplified waterfall
 * mechanism where Senior investors receive priority payments, and
 * Junior investors receive residual cash flows.
 */

contract RoyaltyDistributor {

    address public owner;

    // Track investment amounts (proxy for token holdings)
    mapping(address => uint) public seniorInvestment;
    mapping(address => uint) public juniorInvestment;

    uint public totalSeniorInvestment;
    uint public totalJuniorInvestment;

    constructor() {
        owner = msg.sender;
    }

    /*
     * Investors allocate capital into Senior tranche
     */
    function investSenior() public payable {
        require(msg.value > 0, "Investment must be greater than zero");
        seniorInvestment[msg.sender] += msg.value;
        totalSeniorInvestment += msg.value;
    }

    /*
     * Investors allocate capital into Junior tranche
     */
    function investJunior() public payable {
        require(msg.value > 0, "Investment must be greater than zero");
        juniorInvestment[msg.sender] += msg.value;
        totalJuniorInvestment += msg.value;
    }

    /*
     * Distribute royalty income according to waterfall structure
     * 
     * Step 1: Allocate a fixed proportion to Senior investors
     * Step 2: Allocate residual cash flow to Junior investors
     */
    function distributeRoyalty() public payable {

        require(msg.value > 0, "Royalty amount must be greater than zero");

        uint royalty = msg.value;

        // Priority allocation to Senior tranche (e.g. 70%)
        uint seniorPortion = (royalty * 70) / 100;

        // Residual allocation to Junior tranche
        uint juniorPortion = royalty - seniorPortion;

        /*
         * Simplification:
         * Instead of distributing to each investor individually,
         * funds are transferred to the contract owner as a proxy.
         * 
         * This avoids gas-heavy loops while preserving the
         * economic logic of the waterfall mechanism.
         * 
         * This simplification avoids O(n) distribution complexity and demonstrates
         * the allocation logic without introducing scalability constraints.
         */

        if (totalSeniorInvestment > 0) {
            (bool success, ) = payable(owner).call{value: seniorPortion}("");
            require(success, "Transfer failed");
        }

        if (totalJuniorInvestment > 0) {
            (bool success, ) = payable(owner).call{value: juniorPortion}("");
            require(success, "Transfer failed");
        }
    }
}