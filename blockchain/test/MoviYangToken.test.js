const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('MoviYangToken', function () {
  let moviYangToken;
  let owner, user1, user2;

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();

    const MoviYangToken = await ethers.getContractFactory('MoviYangToken');
    moviYangToken = await MoviYangToken.deploy();
    await moviYangToken.deployed();
  });

  describe('Token Creation', function () {
    it('Should have correct initial supply', async function () {
      const totalSupply = await moviYangToken.totalSupply();
      expect(totalSupply).to.equal(ethers.parseUnits('1000000', 18));
    });

    it('Should have correct name and symbol', async function () {
      expect(await moviYangToken.name()).to.equal('MoviYang Token');
      expect(await moviYangToken.symbol()).to.equal('MYT');
    });
  });

  describe('Minting & Rewards', function () {
    it('Should mint tokens for transactions', async function () {
      const amount = ethers.parseUnits('100', 18);
      await moviYangToken.mintRewardsForTransaction(user1.address, amount, 1);

      const balance = await moviYangToken.balanceOf(user1.address);
      expect(balance).to.equal(amount);
    });

    it('Should update loyalty points on mint', async function () {
      const amount = ethers.parseUnits('100', 18);
      await moviYangToken.mintRewardsForTransaction(user1.address, amount, 1);

      const info = await moviYangToken.getUserInfo(user1.address);
      expect(info.loyaltyPoints).to.equal(10); // 100 / 10 = 10 points
    });
  });

  describe('VIP Levels', function () {
    it('Should calculate correct VIP level', async function () {
      const level1 = await moviYangToken.calculateVIPLevel(1);
      expect(level1).to.equal(1); // Bronze

      const level2 = await moviYangToken.calculateVIPLevel(11);
      expect(level2).to.equal(2); // Silver

      const level3 = await moviYangToken.calculateVIPLevel(51);
      expect(level3).to.equal(3); // Gold

      const level4 = await moviYangToken.calculateVIPLevel(150);
      expect(level4).to.equal(4); // Platinum
    });

    it('Should give correct fee discount by VIP level', async function () {
      const discount0 = await moviYangToken.getFeeDiscount(0);
      expect(discount0).to.equal(0);

      const discount1 = await moviYangToken.getFeeDiscount(1);
      expect(discount1).to.equal(2);

      const discount4 = await moviYangToken.getFeeDiscount(4);
      expect(discount4).to.equal(8);
    });
  });
});
