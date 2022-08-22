require("@nomiclabs/hardhat-ethers");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.7",
  networks: {
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/UuBu99cUYgcsF_A1hmt53eJ40L0J-2gM",
      accounts: [
        "fda7ba9187b122f3aa337e68065ec51e7c844d4d034725f8c8324455e54e9f92",
      ],
    },
  },
};
