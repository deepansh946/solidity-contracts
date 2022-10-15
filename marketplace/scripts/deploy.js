// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')

async function main() {
  const Token = await hre.ethers.getContractFactory('Token')
  const token = await Token.deploy('test', 'T')

  await token.deployed()
  console.log('token deployed!')

  console.log(token.address)

  const Asset = await hre.ethers.getContractFactory('Asset')
  const asset = await Token.deploy('https://google.com')

  await asset.deployed()
  console.log(asset.address)
  console.log('asset deployed!')

  const Marketplace = await hre.ethers.getContractFactory('Marketplace')
  const marketplace = await Marketplace.deploy(asset.address, token.address)

  await marketplace.deployed()
  console.log(marketplace.address)
  console.log('Marketplace deployed!')
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
