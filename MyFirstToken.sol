/*
SPDX-License-Identifier: CC-BY-4.0
(c) Desenvolvido por Gabriel Ferreira Batista baseado no trabalho de Jeff Prestes.
This work is licensed under a Creative Commons Attribution 4.0 International License.
*/

pragma solidity 0.8.4;

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract LegalCounselServices {
    address payable lawFirm;

    constructor() { 
        lawFirm = payable(msg.sender); 
    }
}

contract Mortal is LegalCounselServices  {
    function kill() public {
        require(msg.sender==lawFirm, "Only the Law Firm can destroy the contract.");
        selfdestruct(lawFirm);
    }
}

contract TicketERC20 is IERC20, Mortal {
    string private myName;
    string private mySymbol;
    uint256 private myTotalSupply;
    uint256 public decimals;

    mapping (address=>uint256) balances;
    mapping (address=>mapping (address=>uint256)) ownerAllowances;

    constructor() {
        myName = "One hour worth of legal counsel";
        mySymbol = "1HCOUNSEL";
        _mint(msg.sender, 46);
    }

    function name() public view returns(string memory) {
        return myName;
    }

    function symbol() public view returns(string memory) {
        return mySymbol;
    }

    function totalSupply() public override view returns(uint256) {
        return myTotalSupply;
    }

    function balanceOf(address tokenOwner) public override view returns(uint256) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public override view returns(uint256) {
        return ownerAllowances[tokenOwner][spender];
    }

    function transfer(address to, uint256 amount) public override  hasEnoughBalance(msg.sender, amount) tokenAmountValid(amount) returns(bool) {
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[to] = balances[to] + amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    } 

    function approve(address spender, uint limit) public override returns(bool) {
        ownerAllowances[msg.sender][spender] = limit;
        emit Approval(msg.sender, spender, limit);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public override 
    hasEnoughBalance(from, amount) isAllowed(msg.sender, from, amount) tokenAmountValid(amount)
    returns(bool) {
        balances[from] = balances[from] - amount;
        balances[to] += amount;
        ownerAllowances[from][msg.sender] = amount;
        emit Transfer(from, to, amount);
        return true;
    }
    
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address.");

        myTotalSupply = myTotalSupply + amount;
        balances[account] = balances[account] + amount;
        emit Transfer(address(0), account, amount);
    }
    
    function purchase() public payable {
        require(msg.value >= (1 ether)/10);
        transfer(msg.sender, 1);
        lawFirm.transfer(msg.value);
    }

    modifier hasEnoughBalance(address owner, uint amount) {
        uint balance;
        balance = balances[owner];
        require (balance >= amount); 
        _;
    }

    modifier isAllowed(address spender, address tokenOwner, uint amount) {
        require (amount <= ownerAllowances[tokenOwner][spender]);
        _;
    }

    modifier tokenAmountValid(uint256 amount) {
        require(amount > 0);
        require(amount <= myTotalSupply);
        _;
    }

}
