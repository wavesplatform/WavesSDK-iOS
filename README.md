## WavesSDK is a collection of libraries used to integrate Waves blockchain features into your iOS application

## What is Waves?
Waves is an open-source [blockchain platform](https://wavesplatform.com).

You can use it to build your own decentralised applications. Waves provides full blockchain ecosystem including smart contracts language called RIDE. 

<img src="https://s3.eu-central-1.amazonaws.com/it-1639.waves.mobile.pictures/social/v1/bannerSDKiOS.png" />

## iOS SDK QuickStart
To build your first Waves platform integrated application please go directly to the [Waves iOS SDK QuickStart tutorial](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Get-started-with-WavesSDK-for-iOS) and follow the instructions. 

## SDK main parts
* [Waves Crypto](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Waves-Crypto) handles interaction with crypto part of blockchain, allows to generate seed-phrases, convert public and private keys, obtain and verify addresses, translate bytes to string and back, sign the data with a private key, etc.
* [Waves Models](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Waves-Models) contains models of transactions and other data transfer objects that are needed for building correct services
* [Waves Services](https://github.com/wavesplatform/WavesSDK-iOS/wiki/Waves-Services) provides network services for sending transactions to the blockchain nodes, handling the responses and requesting data.

It's impossible to integrate Waves blockchain platform features into your app without touching all of these parts: for example, transactions can't be sent using Waves Services functionality without being prepared using Waves Crypto and Waves Models first.

## Testing
To test your app you can use [Testnet](https://testnet.wavesplatform.com). This is a Waves Main Net duplicate where it's possible to repeat the real accounts structure without spending paid WAVES tokens. You can create multiple accounts, top up their balances using [Faucet](https://wavesexplorer.com/testnet/faucet) (just insert the account address to the input field and get 10 test tokens) and deploying RIDE scripts (as known as "smart contracts") to them using [Waves RIDE IDE](https://ide.wavesplatform.com/). 

## Useful links
* [Client Mainnet](https://client.wavesplatform.com) – Waves Platform client
* [Explorer Mainnet](https://wavesexplorer.com) – Waves Platform transactions explorer
* [Testnet](https://testnet.wavesplatform.com) – the alternative Waves blockchain platform being used for testing
* [Testnet Explorer](https://wavesexplorer.com/testnet) – Test Net transactions explorer
* [RIDE](https://github.com/wavesplatform/waves-documentation/blob/master/en/ride/ride-script.md) – Waves smart contract coding language
* [Waves Ride IDE](https://ide.wavesplatform.com/) – software for RIDE coding

## Support
Keep up with the latest news and articles, and find out all about events happening on the [Waves Platform](https://wavesplatform.com/).

* [Waves Docs](https://docs.wavesplatform.com/)
* [Community Forum](https://forum.wavesplatform.com/)
* [Community Portal](https://wavescommunity.com/)
* [Waves Blog](https://blog.wavesplatform.com/)
* [Support](https://support.wavesplatform.com/)

##

_Please see the [issues](https://github.com/wavesplatform/WavesSDK-iOS/issues) section to report any bugs or feature requests and to see the list of known issues_ 🤝😎

<a href="https://wavesplatform.com/" target="_blank"><img src="https://cdn.worldvectorlogo.com/logos/waves-6.svg"
alt="wavesplatform" width="113" height="24" border="0" /></a>

[**Website**](https://wavesplatform.com/) | [**Discord**](https://discord.gg/cnFmDyA) | [**Forum**](https://forum.wavesplatform.com/) | [**Support**](https://support.wavesplatform.com/) | [**Documentation**](https://docs.wavesplatform.com)
