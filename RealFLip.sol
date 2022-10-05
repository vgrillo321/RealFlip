// SPDX-License-Identifier: MIT

/*
 /$$$$$$$  /$$$$$$$$  /$$$$$$  /$$             /$$$$$$$$ /$$       /$$$$$$ /$$$$$$$         /$$$$$$  /$$       /$$   /$$ /$$$$$$$ 
| $$__  $$| $$_____/ /$$__  $$| $$            | $$_____/| $$      |_  $$_/| $$__  $$       /$$__  $$| $$      | $$  | $$| $$__  $$
| $$  \ $$| $$      | $$  \ $$| $$            | $$      | $$        | $$  | $$  \ $$      | $$  \__/| $$      | $$  | $$| $$  \ $$
| $$$$$$$/| $$$$$   | $$$$$$$$| $$            | $$$$$   | $$        | $$  | $$$$$$$/      | $$      | $$      | $$  | $$| $$$$$$$ 
| $$__  $$| $$__/   | $$__  $$| $$            | $$__/   | $$        | $$  | $$____/       | $$      | $$      | $$  | $$| $$__  $$
| $$  \ $$| $$      | $$  | $$| $$            | $$      | $$        | $$  | $$            | $$    $$| $$      | $$  | $$| $$  \ $$
| $$  | $$| $$$$$$$$| $$  | $$| $$$$$$$$      | $$      | $$$$$$$$ /$$$$$$| $$            |  $$$$$$/| $$$$$$$$|  $$$$$$/| $$$$$$$/
|__/  |__/|________/|__/  |__/|________/      |__/      |________/|______/|__/             \______/ |________/ \______/ |_______/ 
*/

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface USDC {

    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}


/********************
USDC Staking Contract
*********************/

contract RealFlipBalance {

/* 
To be able to run this smart contract successfully, you need to approve the smart contract address and an amount in the
USDC smart contract with a pre-approved amunt (expressed by the amount in USDC followed by six decimal places
 ex. 1 USDC = 1000000)
 */

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

/************ 
 NFT CONTRACT
*************/

contract RealFLipNFTs is ERC1155, Ownable {
    uint256 public constant Genesis = 0;
    uint256 public constant Hodl = 1;
    uint256 public constant Whale = 2;
    
    // TODO: Should we mint on a constructor? Or mint by directly calling a minting function? 
    constructor() ERC1155("") {
        _mint(msg.sender, Genesis, 10**3, "");
        _mint(msg.sender, Hodl, 10**2, "");
        _mint(msg.sender, Whale, 10, "");
    }
    
    /*
    TODO: This function would be used to mint the NFT, 
    other way to do it is by transfering ownership of the NFT tokens 
    */

    // function mintNFT(uint256 amount) public onlyOwner {
    //     for(uint256 i = 0; i < amount; i++) {
    //         // Loop to increment amount of tokens in circulation everytime it is minted
    //         _mint(msg.sender, tokensInCirculation, 1, "");
    //         tokensInCirculation++;
    //     }
    // }
}