# Homemade ERC721

This project demonstrates a homemade ERC721 with additional functionalities such as listing your NFT for sale and purchasing . It comes with a  contract, a test for that contract, a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

This smart contract has all the functions that make it ERC721 compliant and it is fully documented.

It has the below functions implemented from scratch :
``` function
balanceOf(owner)

ownerOf(tokenId)

safeTransferFrom(from, to, tokenId)

transferFrom(from, to, tokenId)

approve(to, tokenId)

getApproved(tokenId)

setApprovalForAll(operator, _approved)

isApprovedForAll(owner, operator)

safeTransferFrom(from, to, tokenId, data)
```

It additionally has two primary functionality apart from other standard functions :
``` function
addListing (uint256 price , uint256 tokenId) -  which helps users list their NFT for a price they want to sell

purchase (uint256 tokenId) - which helps users purchase the NFT
```


This smart contract is written using best practices that optimise for gas.

