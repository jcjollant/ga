// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;


/**
 * @title Owner
 * @dev Set & change owner
 */
contract PilotLogBook {

    // The pilot that created this log book
    address _owner;
    // Number of flight minutes recorded in this book
    uint totalFlightMinutes;
    // list of flights in this book
    Flight[] flights;

    // Permissions on this log book
    uint constant NONE = 0x00;
    uint constant READ = 0x01;
    uint constant WRITE = 0x02; // must be > READ
    uint constant GRANT = 0x04;

    // list of pilots with permissions on this book (owner is implied)
    mapping(address => uint) _permission;

    struct Flight {
        uint date;
        uint duration;
    }

    constructor( address pilot) {
        _owner = pilot;
    }


    /**
     * This method is used to test if caller has been granted enough permissions
     */
    function hasPermission( uint level) private view returns (bool) {
        return (msg.sender == _owner) || (_permission[msg.sender] >= level);
    }

    /**
     * Add flight to the pilot's book
     * @param date is a Unix Timestamp for the flight. @see https://www.unixtimestamp.com/
     * @param duration is the duration of the flight in minutes
     * @return total time in minutes and flights count in this log book
     */
    function addFlight( uint date, uint duration) public returns (uint, uint) {
        // confirm permissions to create this new record
        require( hasPermission(WRITE), "You don't have enough permissions to create a new flight in this log book");

        // give this pilot the number of minutes
        totalFlightMinutes += duration;

        // Create and store a new flight record
        flights.push( Flight( date, duration));

        return (totalFlightMinutes,flights.length);
    }

    /**
     * Pilots invoke this method to get their total flight time
     */ 
    function getTotalTime() public view returns (uint) {
        require(hasPermission(READ), "You don't have enough permissions to read the total time in this log book");

        return totalFlightMinutes;
    }

    /**
     * @return Total number of flights int he log
     */
    function getFlightsCount() public view returns (uint) {
        require( hasPermission(READ), "You don't have enough permissions to read the flights count in this log book");

        return flights.length;
    }

    /**
     * Changes permissions for a given address
     */
    function setPermission( address grantee, uint permission) public returns (uint) {
        require( hasPermission(GRANT), "You don't have enough permissions to update permissions in this log book");
        require( permission >= NONE && permission <= GRANT, "Invalid permission requested");
        _permission[grantee] = permission;

        return permission;
    }

    function getPermission( address grantee) public view returns (uint) {
        require( hasPermission(GRANT), "You don't have enough permissions to check permissions on this log book.");

        return _permission[grantee];
    }

    /**
     * Finds out of the caller is allowed to read this log book
     */
    function canRead() public view returns (bool) {
        return hasPermission( READ);
    }
}