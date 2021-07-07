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
    
    uint totalAmountPayable;
    
    uint taxRate;
    
    Lease[] public rentals;

    modifier onlyGovernment{
        require(msg.sender == government, "Only the government can set the tax rate.");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function setTaxRate(uint newTaxRate) public onlyGovernment returns{
        taxRate = newTaxRate;
    }

    function calculateTotalAmountPayable() public view returns(uint totalAmountPayable){
        totalAmountPayable = rentPayable+((rentPayable*20)*(taxRate/100));
    }
    
    function registerLease(
        string memory paramLeaser,
        string memory paramLeasee,
        string memory paramEstateAddress,
        uint memory paramRentPayable,
    ) external returns (bool) {
        require(msg.sender == owner, "Only the owner can register a lease agreement.");
        Lease memory newLeaseRecord = Lease(paramLeaser, paramLeasee, paramEstateAddress, paramRentPayable);
        rentals.push(newLeaseRecord);
        return true;
    }
    
}
