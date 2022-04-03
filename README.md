# Speed Running Ethereum

I'm [speeding running ethereum](https://speedrunethereum.com/) by [Austin Griffith](https://twitter.com/austingriffith)! 

Here are my notes & key learnings on the way!

----

## ✅ Challenge 0: 🎟 Simple NFT Example

**[Demo](https://challenge0-speedrunning.surge.sh/)**,  **[Contract](https://rinkeby.etherscan.io/address/0x1aEda3999686e3933DEf92bF6A87228043985398)**

- Working with IPFS, how it uses hash. Here's a [video on IPFS.](https://www.youtube.com/watch?v=5Uj6uR3fp-U&ab_channel=SimplyExplained)
- Minting the NFT & transfer to wallet 
- ERC721
- Verifing a contract 
- Notes: you can run **yarn test** for automated testing!!

## ✅ Challenge 1: 🥩 Decentralized Staking App

**[Demo](https://challenge1-speedrunning.surge.sh/)**, **[Contract](https://rinkeby.etherscan.io/address/0x1175D26ff811ccCf7FB54CC889295df66876CE8C#code)**

A staking app basically 'locks' up your digital tokens for a certain time. 
You stake because the blockchain puts these tokens to work: Proof of Stake. If you stake your crypto it will become part of the process, transactions are validated by people who stake the tokens. 

It coordinates economic activity.

For more on Staking: [Ethereum Staking](https://ethereum.org/en/staking/#stake) and [WhiteBoard Crypto.](https://www.youtube.com/watch?v=vZ2UZdB07fo&ab_channel=WhiteboardCrypto)
 
- Interacting with user address and balances: solidity practice (payable, msg.sender, msg.balance)
- Solidity Modifiers 
- Recap events in soildity 
- Designing a staking app
![staking app](./images/staking_app_design.png)
- Execute function: need to be run by the user, can not auto execute 
- When the stake period if over, its completed. User shouldn't be able to make any actions. 

## [In Progress on Checkpoint 4] Challenge 2: 🏵 Token Vendor

A token vendor is a place where you can buy and sell tokens. 
- Create your own token 
- Create a place to buy and sell your own token.

ERC20 practice:
 -  YourToken.sol inherits this openzepplin contract 
 -  balanceOf allows you to check the balance of the address directly in ERC 20 :-)
 -  ERC 20 has a transfer() function, many of the functions are already there.

Vendor.sol notes:
- When someone buys from the vendor, the vendor tokens will decrease, and the vendor eth balance will increase (you could have guessed ,but strangely easy to make this happen, you already inherit many things)
-  Getting the balance of the contract (address(this).balance)
-  Withdrawl from the contract that has funds is a common pattern, can be found [here](https://docs.soliditylang.org/en/v0.8.7/common-patterns.html)
-  Ownership in contracts (this allows you to verify the actual owner and I think that they can append or something like that to the contract—need to verify this)--> Directly use the onlyOwner in your functions

