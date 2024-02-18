pragma solidity ^0.8.0;

contract Wallet {
    address public owner;

    mapping(address => uint256) public balances;

    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);
    event Transfer(address indexed sender, address indexed recipient, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0 && amount <= balances[msg.sender], "Invalid amount to withdraw");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount) public {
        require(amount > 0 && amount <= balances[msg.sender], "Insufficient balance");
        require(recipient != address(0), "Invalid recipient address");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
