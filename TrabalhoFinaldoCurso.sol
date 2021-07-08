// SPDX-License-Identifier: MIT
// Author: Gabriel Ferreira Batista, based on the work of Jeff Prestes

pragma solidity 0.8.6;

contract LeaseRecord {

    struct Lease {
        string leaser;
        string leasee;
        string estateAddress;
        uint rentPayable;
    }

    address public government;
    
    address public owner;
    
    uint taxRate;
    
    Lease[] public rentals;

    modifier onlyGovernment{
        require(msg.sender == government, "Only the government can set the tax rate.");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        government = 0x389FCf4677912eAbC301C4D010119854159dd984;
        taxRate = 20;
    }
    
    function setTaxRate(uint) public onlyGovernment returns(uint newTaxRate){
        taxRate = newTaxRate;
    }
    
   function registerLease(
        string memory paramLeaser,
        string memory paramLeasee,
        string memory paramEstateAddress,
        uint paramRentPayable
    ) external returns (bool) {
        require(msg.sender == owner, "Only the owner can register a lease agreement.");
        Lease memory newLeaseRecord = Lease(paramLeaser, paramLeasee, paramEstateAddress, paramRentPayable);
        rentals.push(newLeaseRecord);
        return true;
    }
    
}
