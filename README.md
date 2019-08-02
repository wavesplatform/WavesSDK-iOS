## WavesSDK is a collection of libraries used to integrate Waves blockchain features into your iOS application

## What is Waves?
Waves is an open source [blockchain platform](https://wavesplatform.com).

You can use it to build your own decentralised applications. Waves provides full blockchain ecosystem including smart contracts language called RIDE. 

<img src="https://s3.eu-central-1.amazonaws.com/it-1639.waves.mobile.pictures/social/v1/bannerSDKiOS.png" />

### How does the blockchain network work?
There is a huge collection of nodes deloyed by miners that store all of the network information in the chain of blocks (aka blockchain), process requests and can add new transactions to the network after checking their compliance with the rules. The miners are rewarded with the network coins called MRT. <br><br>
The main advantage of this technology is that each node is a synchronized copy of the main blockchain: it means that the information is stored decentralized and won't be overwritten globally if one of the users changes it at one of the node storages. This can garantee that the user's information will stay fair and unchangable. <br><br>
The important addition is that the service built using Waves blockchain looks like a usual web application and doesn't make user experience more difficult. <br><br>
You can read the [Waves node description](https://docs.wavesplatform.com/en/waves-node/what-is-a-full-node.html) and the [definitions page](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Main-Definitions) for a better understanding of the blockchain functionality.

## iOS SDK QuickStart
To build your first Waves platform integrated application and start using all of the blockchain features please go directly to the [Waves iOS SDK QuickStart tutorial](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Get-started-with-WavesSDK-for-iOS) and follow the instructions. 
<br>

## Waves SDK structure
There are two important SDK parts that are needed to prepare crypto data and create models. You will have to use them to build the services correctly:
* [Waves Crypto](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Waves-Crypto) handles interaction with crypto part of blockchain, allows to generate seed-phrases, convert public and private keys, obtain and verify addresses, translate bytes to string and back, sign the data with a private key, etc.
* [Waves Models](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Waves-Models) contain models of transactions and other data transfer objects that are needed for building correct services.

Furthermore, there are three main SDK services that provide the blockchain interactions:
* [Waves Node Service](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Node-Service) allows the application to cooperate directly with the blockchain: you can create transacations, broadcast them and load data from the node using these features. This is the main part of the SDK.
* [Waves Data Service](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Data-Service) suggests the easier way to access the data that is stored in the node. The methods presented in this service are the most efficient way to read blockchain data but do not help writing it. 
* [Waves Matcher Service](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Matcher-Service) contains the methods that give ability to integrate [Waves DEX](https://dex.wavesplatform.com) (decentralized exchange platform) features into the iOS application. You can collect and add users' orders and work with exchange transactions using this service.

## Testing
To test your app you can use [Testnet](https://testnet.wavesplatform.com). This is a Waves Mainnet duplicate where it's possible to repeat the real accounts structure without spending paid WAVES tokens. You can create multiple accounts, top up their balances using [Faucet](https://wavesexplorer.com/testnet/faucet) (just insert the account address into the input field and get 10 test tokens) and deploy RIDE scripts (as known as "smart contracts") using [Waves RIDE IDE](https://ide.wavesplatform.com/). 

## Useful links
* [Official Documentation](https://docs.wavesplatform.com)
* [Client Mainnet](https://client.wavesplatform.com) – Waves Platform client
* [Explorer Mainnet](https://wavesexplorer.com) – Waves Platform transactions explorer
* [Testnet](https://testnet.wavesplatform.com) – the alternative Waves blockchain being used for testing
* [Testnet Explorer](https://wavesexplorer.com/testnet) – Test Net transactions explorer
* [RIDE](https://github.com/wavesplatform/waves-documentation/blob/master/en/ride/ride-script.md) – Waves smart contract coding language
* [Waves Ride IDE](https://ide.wavesplatform.com/) – software for RIDE coding

## Support
Keep up with the latest news and articles, and find out all about events happening on the [Waves Platform](https://wavesplatform.com/).

* [Telegram Dev Chat](https://t.me/waves_ride_dapps_dev)
* [Community Forum](https://forum.wavesplatform.com/)
* [Community Portal](https://wavescommunity.com/)
* [Waves Blog](https://blog.wavesplatform.com/)
* [Support](https://support.wavesplatform.com/)

##

_Please see the [issues](https://github.com/wavesplatform/WavesSDK-iOS/issues) section to report any bugs or feature requests and to see the list of known issues_ 🤝😎

<a href="https://wavesplatform.com/" target="_blank"><img src="https://cdn.worldvectorlogo.com/logos/waves-6.svg"
alt="wavesplatform" width="113" height="24" border="0" /></a>

[**Website**](https://wavesplatform.com/) | [**Discord**](https://discord.gg/cnFmDyA) | [**Forum**](https://forum.wavesplatform.com/) | [**Support**](https://support.wavesplatform.com/) | [**Documentation**](https://docs.wavesplatform.com)
