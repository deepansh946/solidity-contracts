// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.7;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Marketplace {
    using SafeMath for uint;

    ERC1155 asset;
    ERC20 token;

    address marketplaceOwnerAddress;

    mapping(address => mapping(uint => uint)) saleOrders;
    mapping(uint => address) public assetOwners;
    mapping(uint => uint) public assetPrices;
    mapping(uint => bool) public assetsSold;
    mapping(uint => uint) public numberOfAssets;

    string uri;

    event SaleCreated(
        uint _numberOfAssets,
        uint _price,
        address _owner,
        uint _id
    );

    event AssetSold(uint _id);

    constructor(ERC1155 _asset, ERC20 _token) {
        asset = _asset;
        token = _token;
    }

    function _isContract(address addr) internal view returns (bool) {
        return addr.code.length > 0;
    }

    function createSale(
        uint _numberOfAssets,
        uint _price,
        address _owner,
        uint _id
    ) external {
        require(_owner != address(0), "Marketplace: No sale to 0 address");
        require(_price > 0, "Marketplace: Asset price can not be zero");
        require(
            _numberOfAssets > 0,
            "Marketplace: Number of assets can not be zero"
        );

        assetOwners[_id] = _owner;
        assetPrices[_id] = _price;
        assetsSold[_id] = false;
        numberOfAssets[_id] = _numberOfAssets;

        emit SaleCreated(_numberOfAssets, _price, _owner, _id);
    }

    function buyAsset(uint _id) public payable {
        uint value = SafeMath.mul(assetPrices[_id], 55);
        uint fee = SafeMath.div(value, 100);

        // TODO: How to put marketplace address?
        // require(
        //     _isContract(marketplaceOwnerAddress),
        //     "Marketplace: Address can not receive funds"
        // );

        require(
            msg.sender != assetOwners[_id],
            "Marketplace: Can not sell to current owner"
        );
        require(
            msg.value >= assetPrices[_id] + fee,
            "Marketplace: No sufficient funds"
        );
        require(
            assetsSold[_id] != true,
            "Marketplace: Can not sell already sold assets"
        );
        require(
            numberOfAssets[_id] > 0,
            "Marketplace: Can not sell to unavailable assets"
        );

        numberOfAssets[_id] -= 1;

        if (numberOfAssets[_id] == 0) {
            assetsSold[_id] = true;
        }

        token.transferFrom(msg.sender, marketplaceOwnerAddress, fee);

        asset.safeTransferFrom(
            msg.sender,
            assetOwners[_id],
            _id,
            msg.value,
            ""
        );

        emit AssetSold(_id);
    }

    function setMarketplaceOwnerAddress(address _address) external {
        marketplaceOwnerAddress = _address;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) pure external returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}
