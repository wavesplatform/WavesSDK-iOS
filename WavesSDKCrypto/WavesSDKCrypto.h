//
//  InternalWavesSDKCrypto.h
//  InternalWavesSDKCrypto
//
//  Created by rprokofev on 27.06.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif


#import "Curve25519.h"
#import "Ed25519.h"
#import "Randomness.h"
#import "crypto_generichash_blake2b.h"
#import "base58.h"
#import "keccak.h"

//! Project version number for InternalWavesSDKCrypto.
FOUNDATION_EXPORT double WavesSDKCryptoVersionNumber;

//! Project version string for InternalWavesSDKCrypto.
FOUNDATION_EXPORT const unsigned char WavesSDKCryptoVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <InternalWavesSDKCrypto/PublicHeader.h>


