// SPDX-License-Identifier: BUSL-1
pragma solidity =0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract Token is ERC20 {
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {}

    function mint(uint256 amount) external {
        _mint(msg.sender, amount);
    }
}

contract ERC20Factory {
    constructor() {}

    using SafeMath for uint256;

    Token[] public tokens;

    function deployToken(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        bool _feeManager,
        bool _referralManager
    ) public payable {
        Token token = new Token(_name, _symbol);
        token.mint(_totalSupply);
        if (_feeManager) {
            console.log(token.name());
            uint256 a = SafeMath.mul(_totalSupply, 3);
            uint256 fees = SafeMath.div(a, 1000);
            require(msg.value == fees, "Error: Not enough money");
        }

        if (_referralManager) {
            uint256 a = SafeMath.mul(_totalSupply, 2);
            uint256 fees = SafeMath.div(a, 1000);
            require(msg.value == fees, "Error: Not enough money");
        }
        tokens.push(token);
    }

    function supply() public view returns (uint256) {
        return tokens[0].totalSupply();
    }

    function balanceOf(address _address) public view returns (uint256) {
        return tokens[0].balanceOf(_address);
    }
}
