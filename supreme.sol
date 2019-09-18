pragma solidity ^0.5.7;



import './silverToken.sol';

import './bronzeToken.sol';

import './goldToken.sol';


contract Supreme  {

    SilverToken s;
    BronzeToken b;
    GoldToken g;
    uint decimals;

    address admin;

    constructor(address payable gold, address payable silver, address payable bronze, uint _decimals) public {
     s =  SilverToken(silver);
     b =  BronzeToken(bronze);
     g = GoldToken(gold);
     decimals = _decimals;

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

        require(b.balanceOf(from) >= tokens, "Insufficent bronze tokens"); // check if sender has enough bronze balance

        tokens = tokens *10 ** decimals;

        uint balance = b.balanceOf(to) + tokens;  // current balance + requested tokens


        uint silverToken = balance / (1000 * 10 ** decimals);  // calculate total silver token needed to be transfered


        require(s.balanceOf(admin) >= silverToken, "Insufficent silver token in admin");


        b.transferFromTo(from, to, tokens);    // transfer total bronze tokens (to address)


        if(silverToken >= 1){
            silverToken = (silverToken* 10** decimals);
            s.exchangeFromAdmin(to, silverToken);  // find how much silver token needed to be converted and send to receiver
        }


        return true;

    }


    function transferSilver(address from , address to, uint tokens) public returns (bool success){

        require(!isContract(to) && to != address(0), "To address cannot be contract address or zero address");
        require(from != to, "sender and reciver cannot be same");

        require(s.balanceOf(from) >= tokens, "Insufficent silver tokens");

          tokens = tokens * 10 ** decimals;

        uint balance = s.balanceOf(to) + tokens;



        uint goldTokens = balance / (1000 * 10 ** decimals);

        require(g.balanceOf(admin) >= goldTokens, "Insufficent gold token in admin");


        s.transferFromTo(from, to, tokens);


        if(goldTokens >= 1){
            goldTokens = (goldTokens *10 **decimals);
            g.exchangeFromAdmin(to, goldTokens);
        }


        return true;

    }
