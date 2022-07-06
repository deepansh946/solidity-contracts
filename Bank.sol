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

contract Bank {
    using SafeMath for uint256;
    IERC20 public token;
    mapping(address => uint256) public userBalance;
    uint8 public depositInterest = 6;
    uint8 public withdrawlInterest = 8;

    constructor(IERC20 _token) {
        token = _token;
    }

    function deposit(uint256 _amount) external {
        console.log(msg.sender, address(this));

        token.transferFrom(msg.sender, address(this), _amount);
        userBalance[address(this)] = _amount;
        userBalance[msg.sender] = _amount;
    }

    function allowWithdrawl(address _spender, uint256 _amount) external {
        token.approve(_spender, _amount);
    }

    function withdraw(uint256 _amount) external {
        console.log(address(this), msg.sender);

        token.transferFrom(address(this), msg.sender, _amount);

        userBalance[address(this)] = _amount;
        userBalance[msg.sender] = _amount;
    }

    function showBalance(address _owner, uint8 time)
        external
        view
        returns (uint256)
    {
        uint256 a = SafeMath.mul(userBalance[_owner], depositInterest);
        uint256 b = SafeMath.mul(a, time);
        uint256 c = SafeMath.div(b, 100);
        return SafeMath.add(userBalance[_owner], c);
    }

    function loanAmount(address _owner, uint8 time)
        external
        view
        returns (uint256)
    {
        uint256 a = SafeMath.mul(userBalance[_owner], withdrawlInterest);
        uint256 b = SafeMath.mul(a, time);
        uint256 c = SafeMath.div(b, 100);
        return SafeMath.add(userBalance[_owner], c);
    }
}
