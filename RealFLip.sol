// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

/* 
To be able to run this smart contract successfully, you need to approve the smart contract address and an amount in the
USDC smart contract with a pre-approved amunt (expressed by the amount in USDC followed by six decimal places
 ex. 1 USDC = 1000000)
Testing
 */
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface USDC {

    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}

contract RealFlipBalance {
    USDC public USDc;
    address owner;
    mapping(address => uint) public stakingBalance;

    constructor() {
        USDc = USDC(0x07865c6E87B9F70255377e024ace6630C1Eaa37F);
        owner = msg.sender;
    }
    function depositTokens(uint $USDC) public {

        // amount should be > 0
        require($USDC > 0, "You need to deposit USDC");

        // transfer USDC to this contract
        USDc.transferFrom(msg.sender, address(this), $USDC * 10 ** 6);
        
        // update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + $USDC * 10 ** 6;
    }

    // Unstaking Tokens (Withdraw)
    function withdrawalTokens(uint _amount) public {
        //Set balance and withdrawal value
        uint balance = stakingBalance[msg.sender];
        uint withdrawalBalance = _amount;

        // balance should be > 0
        require (balance > 0, "staking balance cannot be 0");
        require (balance > withdrawalBalance, "Not enough funds to withdraw amount");
        require (withdrawalBalance > 0, "Please add the amount you want to withdraw");

        // Transfer USDC tokens to the users wallet
        USDc.transfer(msg.sender, withdrawalBalance * 10 ** 6);

        // Reduce staking balance
        stakingBalance[msg.sender] = balance - withdrawalBalance * 10 ** 6;
    }
}