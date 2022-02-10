// SPDX-License-Identifier: MIT

pragma solidity >= 0.7.0 < 0.9.0;

contract SmartBankAccount {
    uint totalContractBalance = 0;

    function getContractBalance() public view returns(uint) {
        return totalContractBalance;
    }

    mapping (address => uint) balances;
    mapping (address => uint) depositTimestamps;

    // => This addBalance function will not  identify whether this transaction is legit or not thus another function below is defined
    // function addBalance(address userAddress, uint amount) public payable {
    //     balances[userAddress] = amount;
    //     totalContractBalance = totalContractBalance + amount;
    // }

    // function to add balance in an account
    function addBalance() public payable {
        balances[msg.sender] = msg.value;
        totalContractBalance = totalContractBalance + msg.value;
        depositTimestamps[msg.sender] = block.timestamp;
    }

    function getBalance(address userAddress) public view returns(uint) {
        uint principal = balances[userAddress];
        uint timeElapsed = block.timestamp - depositTimestamps[userAddress]; // time in seconds.
        return principal * uint((principal * 7 * timeElapsed) / (100 * 365 * 24 * 60 * 60)) * 1; // single interest of 0.07 %
    }

    function withdraw() public payable {
        address payable withdrawTo = payable(msg.sender);
        uint amountToTransfer = getBalance(msg.sender);
        withdrawTo.transfer(amountToTransfer);
        totalContractBalance = totalContractBalance - amountToTransfer;
    }

    function addMoneyToContract() public payable { 
        totalContractBalance += msg.value;
    }
}
