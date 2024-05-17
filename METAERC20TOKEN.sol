// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19; // Specifies the version of Solidity used

// Interface declaration for an ERC20 token
interface IERC20 {
    function totalSupply() external view returns (uint); // Returns the total token supply

    function balanceOf(address account) external view returns (uint); // Returns the balance of the specified account

    function transfer(address recipient, uint amount) external returns (bool); // Transfers a specified amount of tokens to a specified address

    event Transfer(address indexed from, address indexed to, uint amount); // Event emitted on a successful token transfer
}

// Main contract for META tokens, implementing the IERC20 interface
contract Tokens is IERC20 {
    address public owner; // Owner of the contract
    uint public override totalSupply; // Total supply of META tokens
    mapping(address => uint) public override balanceOf; // Mapping of account balances
    string public name = "META Tokens"; // Name of the token
    string public symbol = "META"; // Symbol of the token
    uint8 public decimals = 18; // Number of decimals the token uses

    // Modifier to restrict function execution to the contract's owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can mint META tokens"); // Ensures that only the owner can call the function
        _; // Continues execution of the function
    }

    // Constructor sets the deploying address as the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to transfer tokens from the caller's account to another account
    function transfer(
        address recipient,
        uint amount
    ) external override returns (bool) {
        balanceOf[msg.sender] -= amount; // Deducts the amount from the sender's balance
        balanceOf[recipient] += amount; // Adds the amount to the recipient's balance
        emit Transfer(msg.sender, recipient, amount); // Emits the transfer event
        return true; // Returns true to indicate success
    }

    // Function to create new tokens and add them to the owner's balance
    function mint(uint amount) external onlyOwner {
        balanceOf[msg.sender] += amount; // Adds the amount to the sender's (owner's) balance
        totalSupply += amount; // Increases the total supply of tokens
        emit Transfer(address(0), msg.sender, amount); // Emits an event indicating tokens were minted
    }

    // Function to destroy tokens from the owner's balance
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount; // Deducts the amount from the sender's balance
        totalSupply -= amount; // Decreases the total supply of tokens
        emit Transfer(msg.sender, address(0), amount); // Emits an event indicating tokens were burned
    }
}
