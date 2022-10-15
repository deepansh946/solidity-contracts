// SPDX-License-Identifier: BUSL-1

pragma solidity =0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Asset is ERC1155 {
    constructor(string memory _uri) ERC1155(_uri) {}
}
