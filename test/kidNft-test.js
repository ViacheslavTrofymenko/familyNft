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
    await kidNft.createNewKid(owner.address, 0, "Adam");
    console.log(await kidNft.kidsNfts(0));
  })
})