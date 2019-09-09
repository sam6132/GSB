pragma solidity ^0.5.10;



import './silverToken.sol';

import './bronzeToken.sol';

import './goldToken.sol';


contract Supreme  {
    
    SilverToken s;
    BronzeToken b;
    GoldToken g;
    
    
    address admin;
    
    constructor(address payable gold, address payable silver, address payable bronze) public {
     s =  SilverToken(silver);
     b =  BronzeToken(bronze);
     g = GoldToken(gold);
     
     admin = msg.sender;
    }
    
    function isContract(address _addr) public view returns(bool){
        uint32 size;
        assembly{
            size := extcodesize(_addr)
        }
        return (size > 0);
    }   
    
    
    function transferBronze(address from , address to, uint tokens) public returns(bool success) {
        
        require(!isContract(to) && to != address(0), "To address cannot be contract address or zero address");
        require(from != to, "sender and reciver cannot be same");
        
        require(b.balanceOf(from) > tokens, "Insufficent bronze tokens");
        
        uint balance = b.balanceOf(to) + tokens;
        
        uint silverToken = balance / 1000;
        
        require(s.balanceOf(admin) > silverToken, "Insufficent silver token in admin");
      
        
        b.transferFromTo(from, to, tokens);    
        
        
        if(silverToken >= 1){
            s.exchangeFromAdmin(to, silverToken);
        }
        
        
        return true;
        
    }
    
    
    function transferSilver(address from , address to, uint tokens) public returns (bool success){
        
        require(!isContract(to) && to != address(0), "To address cannot be contract address or zero address");
        require(from != to, "sender and reciver cannot be same");
        
        require(b.balanceOf(from) > tokens, "Insufficent bronze tokens");
        
        uint balance = b.balanceOf(to) + tokens;
        
        uint goldTokens = balance / 1000;
        
        require(s.balanceOf(admin) > goldTokens, "Insufficent silver token in admin");
      
        
        s.transferFromTo(from, to, tokens);    
        
        
        if(goldTokens >= 1){
            g.exchangeFromAdmin(to, goldTokens);
        }
        
        
        return true;
        
    }
    
    
    
    
    function getBalanceGold(address user) view public returns (uint256) {
        return g.balanceOf(user);
    }
    
    
    function getBalanceSilver(address user) view public returns (uint256) {
        return s.balanceOf(user);
    }
    
    function getBalanceBronze(address user) view public returns (uint256) {
        return b.balanceOf(user);
    }
    
    
}