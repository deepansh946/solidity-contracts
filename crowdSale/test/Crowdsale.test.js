const assert = require("assert");

let token, crowdsale;
const totalSupply = 100000

beforeEach(async () => {
	const Token = await hre.ethers.getContractFactory("Token");
	token = await Token.deploy('Test', 'T');

	await token.deployed();

	const { address } = token;

	const Crowdsale = await hre.ethers.getContractFactory('CrowdSale')
	crowdsale = await Crowdsale.deploy(address)
	await crowdsale.deployed()
})

describe('Crowdsale Contract', () => {
	it('Deploys contracts', () => {
		assert.ok(token.address);
		assert.ok(crowdsale.address);
	})

	it('Ensures token total supply', async () => {
		assert.equal(totalSupply, await token.totalSupply());
	})

	it('Start the sale', async () => {
		await crowdsale.startSale(1, 10)
		assert.equal(await crowdsale.startTime(), 1);
		assert.equal(await crowdsale.endTime(), 10);
	})

	it('Buy Token with max total supply', async () => {
		const amount = totalSupply;
		const address = 'testAddress'
		try {
			await crowdsale.buyToken(amount, address)
			assert(false);
		} catch (err) {
			assert(err);
		}
	})

	it('Buy Token with max allocation of user', async () => {
		const amount = 200;
		const address = 'testAddress'
		try {
			await crowdsale.buyToken(amount, address)
			const balance = await crowdsale.balances(address)
			assert.equal(balance, amount)

			// Fails
			await crowdsale.buyToken(amount, address)
			assert(false)
		} catch (err) {
			assert(err);
		}
	})
})
