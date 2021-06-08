//SPDX-License-Identifier: CC-BY-4.0
//Based on previous smart contracts written in Solidity by Jeff Prestes.
//This work is licensed under a Creative Commons Attribution 4.0 International License.

//O objetivo deste contrato é que fornecedores possam oferecer frutas para uma Quitanda e esta possa comprar as frutas oferecidas ao menor preço unitário, desde que o estoque esteja abaixo do mínimo.

pragma solidity 0.8.4;

contract GreegrocerSupply2 {

    struct Bid {
       string _supplierName;
       address payable _supplierWallet;
       uint _unitaryPrice;
       string _fruitName;
       uint _fruitQuantity;
       bool _alreadyPaid;
    }
    
    struct Fruit {
        string _fruitName;
        uint _fruitInventory;
        uint _fruitMinInventory;
    }

    uint currentFruitInventory;
    
    string fruitName;
    
    uint fruitInitialInventory;
    
    uint fruitMinInventory;
    
    string winningBid_supplierName;
    
    string winningBid_fruitName;
    
    string sale_fruitName;
    
    uint sale_fruitQuantity;
    
    address payable public greengrocerWallet;

    address public winningBid_supplierWallet;
    
    uint public winningBid_unitaryPrice;
    
    uint winningBid_fruitQuantity;
    
    mapping(address => Fruit) public fruitList;
    
    Fruit[] public _fruit;

    mapping(address => Bid) public biddingList;
    Bid[] public _bid;

    bool public buy;

    event newFruit(string _fruitName, uint _fruitInventory, uint _fruitMinInventory);
    
    event sale(string _fruitName, uint _fruitQuantity);
    
    event newWinningBid(string _fruitName, uint _fruitQuantity, address _supplierName, uint amountPayable);
   
    modifier onlyGreengrocer {
        require(msg.sender == greengrocerWallet, "This can only be performed by the Greengrocer");
        _;
    }

    constructor(address payable _greengrocerWallet){
        greengrocerWallet = _greengrocerWallet;
    }

    function verifyFruitInventory() public view returns(uint currentInventory){
        return currentFruitInventory = fruitInitialInventory + winningBid_fruitQuantity - sale_fruitQuantity;
    }
    
    function verifyWhetherToBuy(uint fruitInventory) public view
        returns (bool buy){require(Fruit._fruitName == Fruit._fruitName);
            if(Fruit._fruitInventory < Fruit._fruitMinInventory){
                return true;
            } else {
                return false;
            }
    }
    
    //Quitanda cadastra uma nova fruta.
    function addFruit(string memory fruitName, uint fruitInventory, uint fruitMinInventory) public onlyGreengrocer{
        
        fruitName;
        fruitInitialInventory;
        fruitMinInventory;
        
        Fruit memory newFruit = Fruit(fruitName, fruitInitialInventory, fruitMinInventory);
        Fruit.push(newFruit);
        fruitList[Fruit._fruitName] = newFruit;
        emit newFruit (fruitName, fruitInitialInventory, fruitMinInventory);
    }

    //Quitanda indica uma venda, que diminui o estoque.
    function sellfruit(string memory fruitName, uint _fruitQuantity) public onlyGreengrocer{
        require(sale_fruitName == _fruitName, "This fruit is not sold by the Greengrocer.") //Não é possível acusar a venda de uma fruta que não tenha sido primeiro adicionada.
        
        sale_fruitName;
        sale_fruitQuantity;
        
        Sale memory sale = Fruit(fruitName, fruitQuantity);
        emit sale (fruitName, fruitQuantity)
    }
    
    //Fornecedores podem colocar ofertas de frutas, dese que estas sejam comercializadas pela Quitanda (i.e., estar na lista de frutas).
    function placeBid(string memory _supplierName, address payable _supplierWallet, string memory _fruitName, uint _fruitQuantity, uint _unitaryPrice) public payable {
        require(winningBid_fruitName == _fruitName, "This fruit is not sold by the Greengrocer."); //A fruta a ser ofertada tem de já ter sido incluída pela Quitanda na lista de frutas.
        require(msg.value < (winningBid_fruitQuantity * winningBid_unitaryPrice), "Better prices have already been offered."); //A Quitanda só comprará as frutas oferecidas ao menor preço unitário para uma mesma fruta.
        
        winningBid_supplierName = Bid._supplierName;
        winningBid_supplierWallet = msg.sender;
        winningBid_fruitName = Bid._fruitName;
        winningBid_fruitQuantity = Bid._fruitQuantity;
        winningBid_unitaryPrice = Bid.unitaryPrice;
        
        for (uint i=0; i<Bid.length; i++) {
            Bid storage losingBid = Bid[i];
            if (!losingBid._alreadyPaid) {
                uint paymentAmount = losingBid._unitaryPrice*losingBid._fruitQuantity;
                losingBid._supplierWallet.transfer(paymentAmount);
                losingBid._alreadyPaid = true;
            }
        }
        
        Bid memory temporaryWinningBid = Bid(_supplierName, _supplierWallet, _unitaryPrice, _fruitName, _fruitQuantity, false);
        Bid.push(temporaryWinningBid);
        biddingList[temporaryWinningBid._supplierWallet] = temporaryWinningBid;
        emit newWinningBid (winningBid_fruitName, winningBid_fruitQuantity, msg.sender, msg.value);
    }

   
    function acceptBid() public onlyGreengrocer {
        require(!Fruit._fruitInventory < Fruit._fruitMinInventory, "The current inventory is enough.");
        buy = true;
        emit acceptBid(winningBid_supplierName, winningBid_supplierWallet, winningBid_fruitName, winningBid_fruitQuantity, winningBid_unitaryPrice);

        greengrocerWallet.transfer(address(this).balance);
    }
    
    function returnWinningBidder() public view onlyGreengrocer returns (address) {
        return winningBid_supplierName;
    }
}
