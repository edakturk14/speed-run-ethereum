# Speed Running Ethereum

I'm [speeding running ethereum](https://speedrunethereum.com/) by [Austin Griffith](https://twitter.com/austingriffith)! 

Here are my notes & key learnings on the way!

----

## ✅ Challenge 0: 🎟 Simple NFT Example

**[Demo](https://challenge0-speedrunning.surge.sh/)**,  **[Contract](https://rinkeby.etherscan.io/address/0x1aEda3999686e3933DEf92bF6A87228043985398)**

- Working with IPFS, how it uses hash. Here's a [video on IPFS.](https://www.youtube.com/watch?v=5Uj6uR3fp-U&ab_channel=SimplyExplained)
- Minting the NFT & transfer to wallet 
- ERC721
- Verifing a contract on Etherscan
- Notes: you can run **yarn test** for automated testing in speedrun!!

## ✅ Challenge 1: 🥩 Decentralized Staking App

**[Demo](https://challenge1-speedrunning.surge.sh/)**, **[Contract](https://rinkeby.etherscan.io/address/0x1175D26ff811ccCf7FB54CC889295df66876CE8C#code)**

A staking app basically 'locks' up your digital tokens for a certain time. 
You stake because the blockchain puts these tokens to work: Proof of Stake. If you stake your crypto it will become part of the process, transactions are validated by people who stake the tokens. 

It coordinates economic activity.

For more on Staking: [Ethereum Staking](https://ethereum.org/en/staking/#stake) and [WhiteBoard Crypto.](https://www.youtube.com/watch?v=vZ2UZdB07fo&ab_channel=WhiteboardCrypto)
 
- Interacting with user address & balances: solidity practice (more on payable functions, msg.sender, msg.balance)
- Solidity Modifiers (keep track of a state)
- Recap events in soildity (events & emit --> send to the frontend)
- Designing a staking app 
![staking app](./images/staking_app_design.png)
- Execute function: need to be run by the user, smart contract does not auto execute 
- When the stake period is over, its completed. User shouldn't be able to make any actions (it's like game over)

## ✅  Challenge 2: 🏵 Token Vendor


**[Demo](https://challenge1-speedrunningethereum.surge.sh/)**, **[Contract](https://rinkeby.etherscan.io/address/0xA966A7776Eb58772dF33C52CA481b6C934A03415#code)**


A token vendor is a place where you can buy and sell tokens. In this app you will:
- Create your own ERC20 token 
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
- there are different options you can uses when sending eth: send(), transfer(), and call(). Here's a more info on the [topic](https://github.com/scaffold-eth/scaffold-eth/tree/send-ether-reentrancy). And a short quote:
'recommended method for sending ether is the verbose: """ (bool sent, bytes memory _data) = msg.sender.call{value:a mount}(""); require(sent, "Failed to send Ether");` """'
(also over [here](https://blockchain-academy.hs-mittweida.de/courses/solidity-coding-beginners-to-intermediate/lessons/solidity-2-sending-ether-receiving-ether-emitting-events/topic/sending-ether-send-vs-transfer-vs-call/) it states that call is the recommended way to send eth)
(I used transfer in my contract, and after researching more learned that the call function whould have been a better way) Also on [solidity by example](https://solidity-by-example.org/sending-ether/) -- for better gas usage use call
- There is an approve pattern for ERC 20. Read more about it [here.](https://docs.ethhub.io/guides/a-straightforward-guide-erc20-tokens/) Basically you need to approve the tokens for transaction before the vendor can buy them back. The user approves that the tokens can go to the vendor. On the UI, you'll need to test with approve before directly selling the tokens back to the vendor. (It's a 2 process step and you need to sign 2 different transactions w/metamask as the user 1. to apporove the selling 2. to actually sell the tokens)


## (to be started) Challenge 3: ⚖️ Build a DEX



