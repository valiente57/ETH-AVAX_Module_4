// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, ERC20Burnable, Ownable {

    mapping(uint256 => uint256) private marketValue;
    mapping(address => string[]) private redeemedItems;

    event TokensMinted(address indexed to, uint256 amount);
    event TokensRedeemed(address indexed by, uint256 choice, uint256 amount);
    event TokensBurned(address indexed by, uint256 amount);
    event TokensTransferred(address indexed from, address indexed to, uint256 amount);

    constructor() ERC20("DEGEN", "DGN") Ownable(msg.sender) {
        marketValue[1] = 199;
        marketValue[2] = 49;  
        marketValue[3] = 249;
        marketValue[4] = 299;  
    }

    function mintDegen(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function burnToken(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }

    function transferTokensTo(address _receiver, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        transfer(_receiver, amount);
        emit TokensTransferred(msg.sender, _receiver, amount);
    }

    function getDegenBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function gameStore() public pure returns (string[] memory) {
        string[] memory items = new string[](4);
        items[0] = "1. Character Kong = 199";
        items[1] = "2. Thunderbolt Weapon = 49";
        items[2] = "3. Qilin Companion = 249";
        items[3] = "4. Hundun Companion = 299";
        return items;
    }

    function redeemTokens(uint256 choice) external {
        require(choice >= 1 && choice <= 4, "Invalid selection");

        uint256 amountToRedeem = marketValue[choice];
        require(amountToRedeem > 0, "Invalid choice");

        require(balanceOf(msg.sender) >= amountToRedeem, "Insufficient balance");
        
        // Burn the tokens after redeeming the items
        _burn(msg.sender, amountToRedeem);

        // Add redeemed item to the user's list
        if (choice == 1) {
            redeemedItems[msg.sender].push("Character Kong");
        } else if (choice == 2) {
            redeemedItems[msg.sender].push("Thunderbolt Weapon");
        } else if (choice == 3) {
            redeemedItems[msg.sender].push("Qilin Companion");
        }else if (choice == 4) {
            redeemedItems[msg.sender].push("Hundun Companion");}

        emit TokensRedeemed(msg.sender, choice, amountToRedeem);
    }

    function getRedeemedItems() external view returns (string[] memory) {
        return redeemedItems[msg.sender];
    }
}
