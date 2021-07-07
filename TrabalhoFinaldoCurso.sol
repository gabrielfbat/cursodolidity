// SPDX-License-Identifier: MIT
// Author: Gabriel Ferreira Batista, based on the work of Jeff Prestes

pragma solidity 0.8.6;

contract LeaseRecord {

    struct Lease {
        string leaser;
        string leasee;
        string estateAddress;
        uint rentPayable;
        uint taxPayable;
        uint totalAmountPayable;
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
        totalAmountPayable = rentPayable + taxPayable;
        taxPayable = (rentPayable * 20) * (taxRate / 100);
    }
    
    function setTaxRate() public onlyGovernment returns{
        taxRate = newTaxRate;
    }

    function registerLease(
        string memory paramLeaser,
        string memory paramLeasee,
        string memory paramEstateAddress,
        uint memory paramRentPayable,
        uint memory paramTaxPayable,
        uint memory paramTotalAmountPayable
    ) external returns (bool) {
        require(msg.sender == owner, "Only the owner can register a lease agreement.");
        Lease memory newLeaseRecord = Lease(paramLeaser, paramLeasee, paramEstateAddress, paramRentPayable, paramTaxPayable, paramTotalAmountPayable);
        rentals.push(newLeaseRecord);
        return true;
    }
    
}
