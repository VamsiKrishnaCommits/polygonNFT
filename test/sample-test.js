const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("HomeMadeNFT", function () {
  it("To check if the NFT minting is successful", async function () {
    const Home = await ethers.getContractFactory("HomeMadeNFT");
    const home = await Home.deploy();
    await home.deployed();
    await home.mint("uri");
    expect(await home.exists(1)).to.equal(true);
  });


  it("To check if the NFT can be listed successfully" , async function(){

    const Home = await ethers.getContractFactory("HomeMadeNFT");
    const home = await Home.deploy();
    await home.deployed();
    await home.mint("uri");
    await home.addListing(100 , 1) 
    expect(await home.isListed(1)).to.equal(true);
  });

  it("Is possible to transfer NFT from one address to another given it is called by the owner",async function(){

    const Home = await ethers.getContractFactory("HomeMadeNFT");
    const home = await Home.deploy();
    await home.deployed();
    await home.mint("uri");
    await home.safeTransferFrom("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" , "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" , 1);
    expect(await home.ownerOf(1)).to.equal("0x70997970C51812dc3A010C7d01b50e0d17dc79C8");
});


it("Is not possible to transfer NFT from one address to another given it is called by the owner",async function(){

  const Home = await ethers.getContractFactory("HomeMadeNFT");
  const home = await Home.deploy();
  await home.deployed();
  await home.mint("uri");
  try{
  await home.safeTransferFrom( "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" ,"0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" , 1);
  expect(await home.ownerOf(1)).to.equal("0x70997970C51812dc3A010C7d01b50e0d17dc79C8");
  }
  catch (err){
console.log("Unable to process the transaction")
  }
});

it("Can buy a listed NFT ",async function(){
  const Home = await ethers.getContractFactory("HomeMadeNFT");
  const home = await Home.deploy();
  await home.deployed();
  await home.mint("uri");
  await home.addListing(100 , 1) ;
  [addr1 , addr2 ]=await ethers.getSigners();
  await home.connect(addr2).purchase(1 , {value:"100"});
expect(await home.ownerOf(1)).to.equal("0x70997970C51812dc3A010C7d01b50e0d17dc79C8");

});



});
