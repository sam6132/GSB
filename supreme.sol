pragma solidity ^0.5.10;



import './silverToken.sol';

import './bronzeToken.sol';

import './goldToken.sol';


contract Supreme  {
    
    SilverToken s;
    BronzeToken b;
    GoldToken g;
    
    constructor(address payable gold, address payable silver, address payable bronze) public {
     s =  SilverToken(silver);
     b =  BronzeToken(bronze);
     g = GoldToken(gold);
    }
    
 
    
    function buyBronze(address from,address to, uint256 amount) external {
        
        uint balance = b.balanceOf(to) + amount;
        
        uint silverValue = balance / 1000;
        uint bronzeValue = balance % 1000;
        
        uint bronzeToken = amount % 1000;
        
        uint toadminTokens = amount - bronzeValue;

        
        uint silverBalance = s.balanceOf(to) + silverValue;
        // require(silverValue < 1000, "Sorry you cannot buy bronze greater than 999999")
        if(silverBalance < 1000){
            
            if(silverValue >= 1) {
                
            s.transferFromTo(from, to, silverValue);
            // b.toAdmin(toadminTokens);
            b.replace(from, to,bronzeValue, bronzeToken);
            //toadmin
         }
         else {
             b.replace(from,to,bronzeValue, bronzeToken);
         }
        }
        else {
        
            buySilver(from,to, silverValue);
            b.replace(from,to,bronzeValue, bronzeToken);
        }
    }
    
    
    //toadmin
    
    function buySilver(address from,address to, uint256 amount) public {
        
        uint balance = s.balanceOf(to) + amount;
        
        uint goldvalue = balance / 1000;
        uint silverValue = balance % 1000;
        
        uint silverToken = amount % 1000;
        
        uint toadminTokens = amount - silverValue;
        
        if(goldvalue >= 1) {
            g.transferFromTo(from, to, goldvalue);
            s.replace(from, to,silverValue, silverToken);
            // s.toAdmin(toadminTokens);

         }
         else {
             s.replace(from, to,silverValue, silverToken);
         }
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