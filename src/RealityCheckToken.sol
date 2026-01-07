// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20 } from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; 
import { ERC20Burnable } from "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "openzeppelin-contracts/contracts/access/Ownable.sol";

contract RealityCheckToken is ERC20, ERC20Burnable, Ownable {
    uint256 public immutable MAX_SUPPLY;

    event TokensMinted(address indexed to, uint256 amount);
    event MaxSupplyReached(uint256 maxSupply);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_
    ) ERC20(name_, symbol_) Ownable(msg.sender) {  // Call Ownable() constructor here
        require(maxSupply_ > 0, "Max supply must be > 0");
        MAX_SUPPLY = maxSupply_;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Invalid recipient");
        require(totalSupply() + amount <= MAX_SUPPLY, "Cap exceeded");

        _mint(to, amount);
        emit TokensMinted(to, amount);

        if (totalSupply() == MAX_SUPPLY) {
            emit MaxSupplyReached(MAX_SUPPLY);
        }
    }
}
