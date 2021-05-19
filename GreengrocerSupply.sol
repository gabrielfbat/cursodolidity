//SPDX-License-Identifier: CC-BY-4.0

pragma solidity 0.8.4;

contract GreengrocerSupply{

    string public fruit;
    uint256 fruitInventory;
    uint256 constant minInventory = 30;
    
    constructor(){
       fruit = "apple";
    }
    
    function setFruitInventory(uint fruitInventory) public{
       fruitInventory = 45;
    }
    
    function verifyWhetherToBuy(uint256 fruitInventory) public pure 
        returns (bool buy){
            if(fruitInventory < minInventory){
                    return true;
                } else {
                    return false;
                }
        }
    }
