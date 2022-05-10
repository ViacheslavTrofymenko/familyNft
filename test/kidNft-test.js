const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("KidNftFactory contract", function () {
let owner, acc1, manNft, womanNft, familyNft, kidNft;

beforeEach(async function() {
    [owner, acc1, acc2, acc3, acc4] = await ethers.getSigners();

    const ManNft = await ethers.getContractFactory("ManNftFactory", owner);
    manNft = await ManNft.deploy();
    await manNft.deployed();
    
    const WomanNft = await ethers.getContractFactory("WomanNftFactory", owner);
    womanNft = await WomanNft.deploy();
    await womanNft.deployed();

    const FamilyNft = await ethers.getContractFactory("FamilyFactory", owner);
    familyNft = await FamilyNft.deploy(
        manNft.address,
        womanNft.address
    );
    await familyNft.deployed();

    const KidNft = await ethers.getContractFactory("KidsFactory", owner);
    kidNft = await KidNft.deploy(
        familyNft.address
    );
    await kidNft.deployed();
  })

  it("should be succesfully deployed", async function() {
    expect(kidNft.address).to.be.properAddress;    
  })

  it("allows to create new familyNft", async function() {
    await womanNft.createNewWoman(owner.address, 19, 20, "Sara", "Connor");

    await manNft.createNewMan(owner.address, 22, 30, "Tom", "Cruise");
    
    await familyNft.createNewFamily(owner.address, 0, 0, 3);
    console.log(await familyNft.familyNfts(0));
  })

  it("allows to create new KidNft", async function() {
    await womanNft.createNewWoman(owner.address, 19, 20, "Sara", "Connor");

    await manNft.createNewMan(owner.address, 22, 30, "Tom", "Cruise");
    
    await familyNft.createNewFamily(owner.address, 0, 0, 3);
    const tx = await kidNft.createNewKid(owner.address, 0, "Adam");

    await expect(tx).to.emit(kidNft, 'NewKidNft').withArgs(0, 25, "Adam", "Cruise", 0, 0);
    
    console.log(await kidNft.kidsNfts(0));
  })

  it("allows to create new KidNft only for Owner of KidsFactory", async function() {
    await womanNft.createNewWoman(owner.address, 19, 20, "Sara", "Connor");

    await manNft.createNewMan(owner.address, 22, 30, "Tom", "Cruise");
    
    await familyNft.createNewFamily(owner.address, 0, 0, 3);
    
    await expect(kidNft.connect(acc1).createNewKid(owner.address, 0, "Adam"))
  .to.be.revertedWith("Ownable: caller is not the owner");   
  })

  it("allows to update actual age of a kid", async function() {
    await womanNft.createNewWoman(owner.address, 19, 20, "Sara", "Connor");

    await manNft.createNewMan(owner.address, 22, 30, "Tom", "Cruise");
    
    await familyNft.createNewFamily(owner.address, 0, 0, 3);
    await kidNft.createNewKid(owner.address, 0, "Adam");

    const age = 2 * 60 * 60;

    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    const timestampBefore = blockBefore.timestamp;

    await ethers.provider.send('evm_increaseTime', [age]);
    await ethers.provider.send('evm_mine');

    const blockNumAfter = await ethers.provider.getBlockNumber();

    const blockAfter = await ethers.provider.getBlock(blockNumAfter);
    const timestampAfter = blockAfter.timestamp;
    expect(blockNumAfter).to.be.equal(blockNumBefore + 1);
    expect(timestampAfter).to.be.equal(timestampBefore + age);

    await kidNft.getActualAge(0);
    console.log(await kidNft.kidsNfts(0));
  })

})  