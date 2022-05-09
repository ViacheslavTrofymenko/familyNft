const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("FamilyNftFactory contract", function () {
let owner, acc1, acc2, acc3, acc4, manNft, womanNft, familyNft;

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
  })

  it("should be succesfully deployed", async function() {
    expect(familyNft.address).to.be.properAddress;    
  })

  it("allows to create new ManNft", async function() {
      const age = 21;
      let level = 15;
      const name = "Tom";
      const lastName = "Cruise";
      await manNft.createNewMan(owner.address, age, level,name, lastName);

      let level1 = 56;
      await manNft.createNewMan(owner.address, age, level1,name, lastName);
      
  })

  it("allows to create new WomanNft", async function() {
    const age = 19;
    let level = 32;
    const name = "Sara";
    const lastName = "Connor";
    await womanNft.createNewWoman(owner.address, age, level,name, lastName);
  })

  it("allows to create new FamilyNft", async function() {
    await womanNft.createNewWoman(owner.address, 19, 20, "Sara", "Connor");

    await manNft.createNewMan(owner.address, 22, 30, "Tom", "Cruise")
    
    await familyNft.createNewFamily(owner.address, 0, 0)
    console.log(await familyNft.familyNfts(0));
  })


})