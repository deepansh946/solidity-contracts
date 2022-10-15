const { expect } = require('chai')
const { ethers } = require('hardhat')
const chai = require('chai')
const { solidity } = require('ethereum-waffle')

chai.use(solidity)

let marketplace

const ETH_TOKEN_ADDRESS = '0x00000000219ab540356cbb839cbe05303d7705fa'
const ASSET_ADDRESS = '0x5cC3108884AF30D0B4A32263173dc905FB5e97B3'
const ASSET_OWNER_ADDRESS = '0x007216A0a85d9dab14b23783e51a56cb0416eC88'
const MARKETPLACE_OWNER_ADDRESS = '0x6C8f2A135f6ed072DE4503Bd7C4999a1a17F824B'
const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000'

beforeEach(async () => {
  const Marketplace = await hre.ethers.getContractFactory('Marketplace')
  marketplace = await Marketplace.deploy(ASSET_ADDRESS, ETH_TOKEN_ADDRESS)

  await marketplace.deployed()
})

describe('Marketplace Contract', () => {
  it('Deploys contract', () => {
    expect(marketplace.address).to.exist
  })

  it('Create sale', async () => {
    const numberOfAssets = 20
    const price = 10
    const assetId = 4

    await expect(
      marketplace.createSale(1, 2, ZERO_ADDRESS, 1)
    ).to.be.revertedWith('Marketplace: No sale to 0 address')

    await expect(
      marketplace.createSale(1, 0, ASSET_OWNER_ADDRESS, 1)
    ).to.be.revertedWith('Marketplace: Asset price can not be zero')

    await expect(
      marketplace.createSale(0, 1, ASSET_OWNER_ADDRESS, 1)
    ).to.be.revertedWith('Marketplace: Number of assets can not be zero')

    const sale = await marketplace.createSale(
      numberOfAssets,
      price,
      ASSET_OWNER_ADDRESS,
      assetId
    )

    expect(await marketplace.assetOwners(assetId)).to.be.equal(
      ASSET_OWNER_ADDRESS
    )
    expect(await marketplace.assetPrices(assetId)).to.be.equal(price)
    expect(await marketplace.numberOfAssets(assetId)).to.be.equal(
      numberOfAssets
    )
    expect(await marketplace.assetsSold(assetId)).to.be.equal(false)
  })

  it('Buy Asset', async () => {
    const numberOfAssets = 50
    const price = 1000
    const assetId = 10

    const accounts = await ethers.getSigners()
    const msgSender = accounts[0].address

    // Completed - To make it work uncomment this error
    // await marketplace.createSale(
    //   numberOfAssets,
    //   price,
    //   ASSET_OWNER_ADDRESS,
    //   assetId
    // )
    // await expect(marketplace.buyAsset(1)).to.be.revertedWith(
    //   'Marketplace: Address can not receive funds'
    // )

    // Completed
    // await marketplace.createSale(
    //   numberOfAssets,
    //   price,
    //   ASSET_OWNER_ADDRESS,
    //   assetId
    // )
    // await expect(
    //   marketplace.buyAsset(assetId, { value: 10 })
    // ).to.be.revertedWith('Marketplace: No sufficient funds')

    // Completed
    // await marketplace.createSale(numberOfAssets, price, msgSender, assetId)
    // await expect(marketplace.buyAsset(assetId)).to.be.revertedWith(
    //   'Marketplace: Can not sell to current owner'
    // )

    await marketplace.createSale(1, price, ASSET_OWNER_ADDRESS, assetId)

    await marketplace.buyAsset(assetId, { value: price + 1000 })

    await expect(marketplace.buyAsset(assetId)).to.be.revertedWith(
      'Marketplace: Can not sell already sold assets'
    )
  })
})
