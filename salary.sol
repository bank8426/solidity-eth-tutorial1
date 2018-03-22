pragma solidity ^0.4.0;

contract Payroll {
  uint totalReceived = 0;
  address owner;
  mapping (address => uint) public salaryAmount;
  mapping (address => uint) public withdrawnSalary;
  function Payroll() payable public {
    updateTotalReceived();
    owner = msg.sender;
  }

  function () payable public {
    updateTotalReceived();
  }

  function updateTotalReceived() internal {
    totalReceived += msg.value;
  }

  function addAddress(address _salaryAddress, uint _salary) isOwner public {
    if (msg.sender == owner) {
      salaryAmount[_salaryAddress] = _salary;
    }
  }

  modifier isOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier canWithdraw() {
    require(salaryAmount[msg.sender] > 0);
    _;
  }

  function withdraw() canWithdraw public  {
    uint amountPaid = withdrawnSalary[msg.sender];
    uint senderSalary = salaryAmount[msg.sender];
    uint salaryToPay = senderSalary - amountPaid;

    if (salaryToPay > 0) {
      withdrawnSalary[msg.sender] = amountPaid + salaryToPay;
      msg.sender.transfer(salaryToPay);
    }
  }
}
