// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "contracts/PilotLogBook.sol";

contract GA {
    // all pilot log books
    mapping(address => PilotLogBook) pilotLogBooks;
    uint knownPilots;

    function signUp() public returns (PilotLogBook) {
        // Check for prior record
        if( pilotLogBooks[msg.sender] == (PilotLogBook)(address(0))) {
            // create a new entry
            pilotLogBooks[msg.sender] = new PilotLogBook(msg.sender);
            knownPilots++;
        }

        return pilotLogBooks[msg.sender];
    }
    

    /**
     * @return Caller own Pilot Log Book
     */
    function getMyLogBook() public view returns (PilotLogBook) {
        return pilotLogBooks[msg.sender];
    }

    /**
     * @return someone else's Pilot Log Book
     */
    function getPilotLogBook( address pilot) public view returns (PilotLogBook) {
        PilotLogBook plb = pilotLogBooks[pilot];
        require( plb.canRead(), "You don't have permission to read this pilot log book.");

        return plb;
    }

}