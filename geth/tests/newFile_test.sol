// SPDX-License-Identifier: GPL-3.0
    
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "../contracts/PilotLogBook.sol";
import "../contracts/GA.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    GA ga = new GA();

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        ga = new GA();
    }

    // #sender: account-0
    // function testGetLoogBook() public {
    //     (uint time, uint count) = ga.getMyLogBookTotals();
    //     Assert.equal( time, 0, "I should own my own log book");
    // }

    // As a pilot, I can log a new flight with date and time.
    // #sender: account-0
    function checkTotalTime() public {
        ga.signUp();
        PilotLogBook plb = ga.getMyLogBook();
        Assert.notEqual( (address)(plb), address(0), "PLB should exist by now");
        Assert.equal( 0, plb.getTotalTime(), "Pilot should have not time at this point");
        Assert.equal( 0, plb.getFlightsCount(), "Pilot should have not flights at this point");

        plb.addFlight(1640534001, 10);
        Assert.equal( 10, plb.getTotalTime(), "Time should account for first flight");
        Assert.equal( 1, plb.getFlightsCount(), "Flights should account for first flight");

        plb.addFlight(1640534002, 20);
        Assert.equal( 30, plb.getTotalTime(), "Time should account for second flight");
        Assert.equal( 2, plb.getFlightsCount(), "Flights should account for second flight");
    }

    // sender: account-0
    function testSelfPermissions() public {
        ga.signUp();
        PilotLogBook plb = ga.getMyLogBook();
        Assert.ok( plb.canRead(), "Pilot should be able to read its own log book");
        try ga.getPilotLogBook( TestsAccounts.getAccount(1)) {
            Assert.ok(false, "We should not be able to get this log book");
        } catch {}
    }


    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
//        Assert.ok(2 == 2, 'should be true');
//        Assert.greaterThan(uint(2), uint(1), "2 should be greater than to 1");
//        Assert.lesserThan(uint(2), uint(3), "2 should be lesser than to 3");
//        Assert.notEqual(uint(1), uint(1), "1 should not be equal to 1");
//        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
 

}
