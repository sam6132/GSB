pragma solidity ^0.5.7;


import './ownable.sol';
import './SafeMath.sol';
import './ERC20Interface.sol';


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and assisted
// token transfers
// ----------------------------------------------------------------------------
contract BronzeToken is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public  name;
    uint public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;


    address admin;

    address public supreme;
    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        symbol = "BRONZE";
        name = "bronze";
        decimals = 1;
        _totalSupply = 10000  * 10 ** decimals;
        admin = msg.sender;
        balances[msg.sender] = _totalSupply;
        supreme = admin;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function changeSupreme(address _newSupreme) public onlyOwner {
        supreme = _newSupreme;
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public onlySupreme returns (bool success) {

        require(balances[msg.sender] >= tokens,"insufficient balance to transfer");
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }


    function approve(address spender, uint tokens) public onlySupreme returns (bool success) {
        require(balances[msg.sender] >= tokens,"insufficient balance to approve");
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }


    function transferFrom(address from, address to, uint tokens) public onlySupreme returns (bool success) {

        require(allowed[from][msg.sender] >= tokens,"insufficient allowed balance");

        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }



    //transfer bronze tokens
    function transferFromTo(address from, address to, uint tokens) public onlySupreme returns(bool success) {

        require(balances[from] >= tokens, "insufficient balance");

        balances[from] = safeSub(balances[from], tokens);
        balances[to] = safeAdd(balances[to], tokens);

        uint silverTokens = balances[to] / (1000 *10 ** decimals); // number of silverToken Needed to be send

        // if number of number of silverToken is greater than 1 exchange token from admin
        if(silverTokens >= 1) {

            uint carryForwardTokens = safeMul(silverTokens, 1000 *10 **decimals);

            balances[owner] = safeAdd(balances[owner], carryForwardTokens);
            balances[to] = safeSub(balances[to], carryForwardTokens);
        }

        emit Transfer(from, to, tokens);
        return true;
    }


     function exchangeFromAdmin( address to, uint tokens) public onlySupreme returns(bool success){

        require(balances[admin] >= tokens,"insufficient balance to transfer");

        balances[admin] = safeSub(balances[admin], tokens );
        balances[to] = safeAdd(balances[to], tokens);
        // emit Transfer(admin, to, tokens);
        return true;
    }


    function allowance(address tokenOwner, address spender) public onlySupreme view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    function approveAndCall(address spender, uint tokens, bytes memory data) public onlySupreme returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }


    modifier onlySupreme(){
        require(msg.sender == supreme, "You are not allowed to call methods");
        _;
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
