//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract OceanToken is ERC20Capped, ERC20Burnable{

    address payable public owner;
    uint256 public blockReward;

    constructor(uint256 initialSupply, uint256 cap, uint256 reward) ERC20("AbhiToken", "ATC") ERC20Capped(cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        _mint(owner, initialSupply * (10 ** decimals()));
        blockReward = reward * (10 ** decimals());

    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    // function  _beforeTokenTransfer(address from , address to, uint256 value) internal virtual override {
    //     if(from !=address(0) && to != block.coinbase && block.coinbase !=address(0))
    //         _mintMinerReward();
    //     super._beforeTokenTransfer(from, to, value);
    // }
    function _update(address from , address to, uint256 value) internal virtual override(ERC20, ERC20Capped){
        require(from !=address(0) && block.coinbase !=to && block.coinbase != address(0));
        _mintMinerReward();

        super._update(from, to, value);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());
    }

}

