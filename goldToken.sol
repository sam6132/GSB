pragma solidity ^0.5.7;

import './ownable.sol';
import './SafeMath.sol';
import './ERC20Interface.sol';



contract GoldToken is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public  name;
    uint public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;


    address admin;

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        symbol = "GOLD";
        name = "gold";
        decimals = 1;
        _totalSupply = 10000 ;
        admin = msg.sender;
        balances[admin] = _totalSupply;
        emit Transfer(address(0), admin, _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }


    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }


    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        

        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
    
    function replace(address from, address to, uint tokens) public returns (bool success) {
        balances[to] = tokens;
        return true;
    }
    
    
     function toAdmin(address from, address to, uint tokens, uint goldBalance) public returns (bool success) {
        
              balances[to] = tokens;

        
        
        balances[admin] = safeAdd(balances[admin], goldBalance);

        emit Transfer(from, to, tokens);
        return true;
    }
    
    function transferFromTo(address from, address to, uint tokens) public returns(bool success) {
        

        balances[from] = safeSub(balances[from], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }


    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
   
    function replace(uint value) public returns (uint balanceofuser)  {
         balances[msg.sender] =0 ;
         return balances[msg.sender] = value;
       
       
    }


    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () external payable {
        revert();
    }


    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
   
    function destruct() onlyOwner public{
        selfdestruct(msg.sender);
    }
}
