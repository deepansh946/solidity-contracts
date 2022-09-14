// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')

const ETH_TOKEN_ADDRESS = '0x00000000219ab540356cbb839cbe05303d7705fa'
const ASSET_ADDRESS = '0x5cC3108884AF30D0B4A32263173dc905FB5e97B3'

async function main() {
  const Marketplace = await hre.ethers.getContractFactory('Marketplace')
  const marketplace = await Marketplace.deploy(ASSET_ADDRESS, ETH_TOKEN_ADDRESS)

  await marketplace.deployed()
  console.log('Marketplace deployed!')

  const { address } = marketplace
  console.log(address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
