//
//  WavesSDKTests.swift
//  WavesSDKTests
//
//  Created by rprokofev on 10/04/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import WavesSDKCrypto
import XCTest

/*
 All mocks (base64) taken from https://8gwifi.org/MessageDigest.jsp

 */

private enum Constants {
    static let mockSeed: String =
        "pattern voyage train body member denial nominee face useful engage fortune spatial inmate bright below"

    static let mockWord: String = "waves2019"

    static let mockWordBase64Blake2b256 = "EHqBDsj4L0zkfPkB0lhuOUIem1o7xrKIpDINJQSV3Mk="
    static let mockWordBase64Keccak256 = "+Q8IiiiFSOt0R/WkEbC1dm7KXzVCHPRixseZFyopD7A="
    static let mockWordBase64Sha256 = "mvYf4ZHT/K6e6KaHsIs5fb13G7qcZ/XsLS8kL9WQ/e4="

    static let mockWordBase64 = "d2F2ZXMyMDE5"
    static let mockWordBase58 = "2X8oUCZJopo2p"

    static let mockSeedPublicKey = "5PQRUkLfYuSN83HkQFTXdN3mXckzXs8Gfpp4VbrnzNiu"
    static let mockSeedPrivateKey = "F3i1BWjH6RhLHcxF7iW3tW7w3pcTVFLCSPbmiFo9q6zB"
    static let mockSeedAddress = "3PHtCsxV95dD6kh4LUM4QYV4ijXywWnB9uD"

    static let mockSeedInvalidAddress = "Maks3PHtCsxV95dD6kh4LUM4QYV4ijXywWnB9uD"

    static let chainId = "W".utf8.first ?? 0

    static let randomBytes: [UInt8] = [0, 3, 4, 5]
}

final class WavesCryptoTests: XCTestCase {
    private let wavesCrypto: WavesCrypto = WavesCrypto()

    override func setUp() {}

    override func tearDown() {}

    func testBlake2b256() {
        let mock = Constants.mockWord.utf8
        let bytes = wavesCrypto.blake2b256(input: Array(mock))
        let string = wavesCrypto.base64encode(input: bytes)

        XCTAssertTrue(!string.isEmpty)
        XCTAssertTrue(string == Constants.mockWordBase64Blake2b256)
    }

    func testKeccak256() {
        let mock = Constants.mockWord.utf8
        let bytes = wavesCrypto.keccak256(input: Array(mock))
        let string = wavesCrypto.base64encode(input: bytes)

        XCTAssertTrue(string == Constants.mockWordBase64Keccak256)
    }

    func testKeccak256Try1000() {
        for _ in 0 ... 1000 {
            let mock = Constants.mockWord.utf8

            let bytes = wavesCrypto.keccak256(input: Array(mock))
            let string = wavesCrypto.base64encode(input: bytes)

            if string != Constants.mockWordBase64Keccak256 {
                XCTAssert(false)
            }
        }

        XCTAssert(true)
    }

    func testSha256() {
        let mock = Constants.mockWord.utf8
        let bytes = wavesCrypto.sha256(input: Array(mock))
        let string = wavesCrypto.base64encode(input: bytes)

        XCTAssertTrue(string == Constants.mockWordBase64Sha256)
    }

    func testBase64Encode() {
        let mock = Constants.mockWord.utf8
        let string = wavesCrypto.base64encode(input: Array(mock))

        XCTAssertTrue(string == Constants.mockWordBase64)
    }

    func testBase64Decode() {
        let bytes = wavesCrypto.base64decode(input: Constants.mockWordBase64)

        XCTAssertTrue(bytes != nil)

        let string = String(bytes: bytes!, encoding: .utf8)

        XCTAssertTrue(string == Constants.mockWord)
    }

    func testBase58Encode() {
        let mock = Constants.mockWord.utf8
        let string = wavesCrypto.base58encode(input: Array(mock))

        XCTAssertTrue(string == Constants.mockWordBase58)
    }

    func testBase58Decode() {
        let bytes = wavesCrypto.base58decode(input: Constants.mockWordBase58)

        XCTAssertTrue(bytes != nil)

        let string = String(bytes: bytes!, encoding: .utf8)

        XCTAssertTrue(string == Constants.mockWord)
    }

    func testRandomSeed() {
        let seed = wavesCrypto.randomSeed()

        XCTAssertTrue(!seed.isEmpty)
    }

    func testKeyPair() {
        let pair = wavesCrypto.keyPair(seed: Constants.mockSeed)

        XCTAssertTrue(pair?.publicKey == Constants.mockSeedPublicKey)
        XCTAssertTrue(pair?.privateKey == Constants.mockSeedPrivateKey)
    }

    func testPublicKey() {
        let publicKey = wavesCrypto.publicKey(seed: Constants.mockSeed)
        XCTAssertTrue(publicKey == Constants.mockSeedPublicKey)
    }

    func testPrivateKey() {
        let privateKey = wavesCrypto.privateKey(seed: Constants.mockSeed)
        XCTAssertTrue(privateKey == Constants.mockSeedPrivateKey)
    }

    func testAddressFromPublicKey() {
        let address = wavesCrypto.address(publicKey: Constants.mockSeedPublicKey, chainId: Constants.chainId)
        XCTAssertTrue(address == Constants.mockSeedAddress)
    }

    func testAddressFromSeed() {
        let address = wavesCrypto.address(seed: Constants.mockSeed, chainId: Constants.chainId)
        XCTAssertTrue(address == Constants.mockSeedAddress)
    }

    func testAddressValid() {
        let address = wavesCrypto
            .verifyAddress(address: Constants.mockSeedAddress, chainId: Constants.chainId, publicKey: Constants.mockSeedPublicKey)
        XCTAssertTrue(address == true)
    }

    func testAddressInvalid() {
        let address = wavesCrypto
            .verifyAddress(address: Constants.mockSeedInvalidAddress, chainId: Constants.chainId, publicKey: nil)
        XCTAssertTrue(address == false)
    }

    func testSignValid() {
        let signature = wavesCrypto
            .signBytes(bytes: Constants.randomBytes, privateKey: wavesCrypto.privateKey(seed: Constants.mockSeed)!)

        let result = wavesCrypto
            .verifySignature(publicKey: wavesCrypto.publicKey(seed: Constants.mockSeed)!, bytes: Constants.randomBytes,
                             signature: signature!)

        XCTAssertTrue(result == true)
    }

    func testSignBytesByPrivateKey() {
        let publicKey = wavesCrypto.publicKey(seed: Constants.mockSeed)

        XCTAssertTrue(publicKey != nil)

        let result = wavesCrypto.verifyPublicKey(publicKey: publicKey!)

        XCTAssertTrue(result == true)
    }
}
