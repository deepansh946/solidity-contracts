// SPDX-License-Identifier: BUSL-1

pragma solidity =0.8.7;

import "hardhat/console.sol";
import "./Token.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CrowdSale {
    Token token;

    constructor(Token _token) {
        token = _token;
        token.mint(100000);
    }

    using SafeMath for uint256;

    uint8 public maxAllocationPerUser = 200;
    uint8 public conversionRateForEth = 50;
    uint8 public startTime;
    uint8 public endTime;
    uint256 totalSupply = 100000;
    mapping(address => uint256) balances;

    // Change the money variable to something more explainable
    event TokenBought(address _address, uint256 _amount, uint256 _money);

    function startSale(uint8 _startTime, uint8 _endTime) public {
        startTime = _startTime;
        endTime = _endTime;
    }

    modifier saleIsLive() {
        require(startTime < endTime, "Sale has ended!");
        _;
    }

    function getNumberOfTokens(uint256 _amt) public view returns (uint256) {
        uint256 t = SafeMath.div(_amt, conversionRateForEth);
        return t;
    }

    function buyToken(address _address)
        public
        payable
        saleIsLive
    {
        uint256 _amount = msg.value;
        uint256 tokensBought = getNumberOfTokens(_amount);
        uint256 total = SafeMath.add(balances[_address], tokensBought);

        require(total < maxAllocationPerUser, "Crowdsale: User balance exceeds max allocation!");
        require(tokensBought < totalSupply, "Crowdsale: Can't buy tokens more than total supply!");

        balances[_address] = total;
        token.transferFrom(msg.sender, _address, tokensBought);

        emit TokenBought(_address, _amount, msg.value);
    }

    function getBalance(address _address) public view returns (uint256) {
        return balances[_address];
    }
}
