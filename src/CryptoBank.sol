// SPDX-License-Identifier: MIT

pragma solidity ^0.8.33;

contract CryptoBank {
    uint public maxBalance;
    address public admin;
    mapping(address => uint) public userBalance;

    event Deposit(address user_, uint128 amount_);
    event WithdrawEther(address user_, uint128 amount_);

    modifier onlyAdmin() {
        require(msg.sender == admin, "No eres admin");
        _;
    }

    constructor(uint maxBalancec_, address admin_) {
        require(admin_ != address(0), "...");
        maxBalance = maxBalance_;
        admin = admin_;
    }


    function DepositEther() external payable {
        require(userBalance[msg.sender] + msg.value <= maxBalance, "MaxBalance rehased");
        userBalance += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    receive() external payable {
        userBalance[msg.sender] = msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function Withdraw(uint128 amount_) external {
        require(userBalance >= amount_, "Fondos insuficientes");

        userBalance[msg.sender] -= amount_;

        (bool success, ) = msg.sender.call{value: amount_}("");
        require(success, "Fallo la tranferecia");

        emit WithdrawEther(msg.sender, amount_);
    }

    // modify MaxBalance
    function modifyMaxBalance(uint newMaxBalance_) external onlyAdmin {
        maxBalance = newMaxBalance_;
    }
}
