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
        
        
        uint silverBalance = s.balanceOf(to) + silverValue;
        
        // require(silverValue < 1000, "Sorry you cannot buy bronze greater than 999999")
        if(silverBalance < 1000){
            if(silverValue >= 1) {
                
            uint bronzeBalance = balance - bronzeValue;
            s.transferFromTo(from, to, silverValue);
            b.toAdmin(from, to,bronzeValue, bronzeBalance);
            //toadmin
         }
         else {
             b.replace(from,to,bronzeValue);
         }
        }
        else {
        
            buySilver(from,to, silverValue);
            b.replace(from,to,bronzeValue);
        }
    }
    
    
    //toadmin
    
    function buySilver(address from,address to, uint256 amount) public {
        
        uint balance = s.balanceOf(to) + amount;
        
        uint goldvalue = balance / 1000;
        uint silverValue = balance % 1000;
        
        if(goldvalue >= 1) {
            uint silverBalance = balance - silverValue;

            g.transferFromTo(from, to, goldvalue);
            s.toAdmin(from, to,silverValue, silverBalance);
         }
         else {
             s.replace(from, to,silverValue);
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
