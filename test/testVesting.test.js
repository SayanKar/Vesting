const Vest = artifacts.require("Vest");

contract("Vest", (accounts) => {
	let vest;
	let claimedTimestampList = [];
	let initialBalance;
	before(async () => {
		vest = await Vest.deployed();
	});

	it("should add tokens for addresses", async () => {
		const tokensForAddressZero = 1200;
		await vest.addTokensForAddresses([accounts[0]], [tokensForAddressZero]);
		const tokensForGivenAddress = await vest.tokensPerAddress(accounts[0]);
		assert.equal(BigInt(tokensForAddressZero) * BigInt(10**18) , BigInt(tokensForGivenAddress.tokens), "Not equal");
	});

	it("should update tokens for addresses", async () => {
		const tokensForAddressZero = 1200;
		await vest.addTokensForAddresses([accounts[0]], [tokensForAddressZero]);
		const tokensForGivenAddress = await vest.tokensPerAddress(accounts[0]);
		assert.equal(BigInt(2 * tokensForAddressZero) * BigInt(10**18) , BigInt(tokensForGivenAddress.tokens), "Not equal");
	});

	it("should raise error on calling claimFunds before vesting starts", async () => {
		try {
			await vest.claimFunds();
		} catch(err) {
			assert(err.message, "Vesting period not started");
			return;
		}
		assert(false);
	});

	it("should start vesting", async () => {
		await vest.startVesting();
		const startTime = await vest.startTime();
		assert.notEqual(0, startTime, "startTime is zero");
	});

	it("should not allow to add or update tokens for addresses after vesting", async () => {
		try {
			await vest.addTokensForAddresses([accounts[0]], [1000]);
		} catch (err) {
			assert(err.message, "Cannot update tokensPerAddess after Vesting period has started");
			return;
		}
		assert(false);
	});

	it("shouldn't allow to start vesting again", async () => {
		try {
			await vest.startVesting();
		} catch (err) {
			assert(err.message, "Vesting cannot be started more than once");
			return;
		}
		assert(false);
	});

	it("should release funds", async () => {
		const prevBalance = await vest.balanceOf(accounts[0]);
		await vest.claimFunds();
		const startTime = await vest.startTime();
		const tokenDetail = await vest.tokensPerAddress(accounts[0]);
		const vestingPeriod = await vest.vestingPeriod();
		const newBalance = await vest.balanceOf(accounts[0]);
		claimedTimestampList.push(startTime);
		claimedTimestampList.push(tokenDetail.lastClaimed);
		initialBalance = prevBalance;
		assert.equal(BigInt(newBalance) - BigInt(prevBalance), BigInt(tokenDetail.lastClaimed - startTime) * BigInt(tokenDetail.tokens) / BigInt(vestingPeriod), "Released funds not equal to the total rewards expected");
	});

	it("should release remaining fund", async () => {
		const prevBalance = await vest.balanceOf(accounts[0]);
		await vest.claimFunds();
		const lastClaimed = claimedTimestampList[claimedTimestampList.length - 1];
		const tokenDetail = await vest.tokensPerAddress(accounts[0]);
		const vestingPeriod = await vest.vestingPeriod();
		const newBalance = await vest.balanceOf(accounts[0]);
		claimedTimestampList.push(tokenDetail.lastClaimed);
		assert.equal(BigInt(newBalance) - BigInt(prevBalance), BigInt(tokenDetail.lastClaimed - lastClaimed) * BigInt(tokenDetail.tokens) / BigInt(vestingPeriod), "Released funds not equal to the total remaining rewards expected");
	});

	it("should release the full amount specified", async () => {
		
		function timeout(ms) {
			return new Promise(resolve => setTimeout(resolve, ms));
		}
		await timeout(130000);
		await vest.claimFunds();
		const tokenDetail = await vest.tokensPerAddress(accounts[0]);		
		const newBalance = await vest.balanceOf(accounts[0]);
		assert.equal(newBalance - initialBalance, tokenDetail.tokens,  "Released funds not equal to rewards assigned");	
	});

	it("should raise error on calling claimFunds after fully claiming rewards", async () => {
		try {
			await vest.claimFunds();
		} catch(err) {
			assert(err.message, "You have fully claimed your funds");
			return;
		}
		assert(false);
	});
});
