// SPDX-License-Identifier: BUSL-1

pragma solidity =0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {}

    function mint(uint256 amount) external {
        _mint(msg.sender, amount);
    }
}
