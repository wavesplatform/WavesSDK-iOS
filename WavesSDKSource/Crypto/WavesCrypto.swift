//
//  СRypto.swift
//  Base58
//
//  Created by rprokofev on 17/04/2019.
//

import Foundation
import Keccak
import Blake2
import Curve25519
import Base58
import CommonCrypto
import CryptoSwift

public typealias Bytes = [UInt8]
public typealias PublicKey = String
public typealias PrivateKey = String
public typealias Seed = String
public typealias Address = String

public struct KeyPair {
    public let publicKey: PublicKey
    public let privateKey: PrivateKey
}

public enum WavesCryptoConstants {
    public static let publicKeyLength: Int = 32
    public static let privateKeyLength: Int = 32
    public static let signatureLength: Int = 64
    
    internal static let keyLength: Int = 32
    internal static let addressVersion: UInt8 = 1
    internal static let checksumLength: Int = 4
    internal static let hashLength: Int = 20
    internal static let addressLength: Int = 1 + 1 + hashLength + checksumLength
}

public protocol WavesCryptoProtocol {

    func blake2b256(input: Bytes) -> Bytes
    func keccak256(input: Bytes) -> Bytes
    func sha256(input: Bytes) -> Bytes

    func base58encode(input: Bytes) -> String?
    func base58decode(input: String) -> Bytes?
    func base64encode(input: Bytes) -> String
    func base64decode(input: String) -> Bytes?

    func randomSeed() -> Seed
    func keyPair(seed: Seed) -> KeyPair?
    func publicKey(seed: Seed) -> PublicKey?
    func privateKey(seed: Seed) -> PrivateKey?

    func address(publicKey: PublicKey, chainId: String?) -> Address?
    func address(seed: Seed, chainId: String?) -> Address?
    
    func signBytes(bytes: Bytes, privateKey: PrivateKey) -> Bytes?
    func signBytes(bytes: Bytes, seed: Seed) -> Bytes?

    func verifySignature(publicKey: PublicKey, bytes: Bytes, signature: Bytes) -> Bool
    func verifyPublicKey(publicKey: PublicKey) -> Bool
    func verifyAddress(address: Address, chainId: String?, publicKey: PublicKey?) -> Bool
}

public class WavesCrypto: WavesCryptoProtocol {

    public init() {}
    
    public static let shared: WavesCrypto  = WavesCrypto()

    public func address(publicKey: PublicKey, chainId: String?) -> Address? {
        
        guard let publicKeyDecode = base58decode(input: publicKey) else { return nil }
        
        let bytes = secureHash(publicKeyDecode)
        let publicKeyHash = Array(bytes[0..<WavesCryptoConstants.hashLength])
        
        let withoutChecksum: Bytes = [WavesCryptoConstants.addressVersion, (chainId?.utf8.first ?? 0)] + publicKeyHash
        let checksum = calcCheckSum(withoutChecksum)
        
        return base58encode(input: withoutChecksum + checksum)
    }
    
    public func address(seed: Seed, chainId: String?) -> Address? {
        
        guard let key = publicKey(seed: seed) else { return nil }
        
        return address(publicKey: key, chainId: chainId)
    }

    public func signBytes(bytes: Bytes, privateKey: PrivateKey) -> Bytes? {
        
        guard let privateKeyDecode = base58decode(input: privateKey) else { return nil }
        
        return Array(Curve25519.sign(Data(bytes), withPrivateKey: Data(privateKeyDecode)))
    }

    public func signBytes(bytes: Bytes, seed: Seed) -> Bytes? {
        
        guard let pair = keyPair(seed: seed) else { return nil }
        
        return signBytes(bytes: bytes, privateKey: pair.privateKey)
    }
    
    public func verifySignature(publicKey: PublicKey, bytes: Bytes, signature: Bytes) -> Bool {
        
        guard let publicKeyDecode = base58decode(input: publicKey) else { return false }
        
        return Ed25519.verifySignature(Data(signature), publicKey: Data(publicKeyDecode), data: Data(bytes))
    }

    public func verifyPublicKey(publicKey: PublicKey) -> Bool {
        
        guard let publicKeyDecode = base58decode(input: publicKey) else { return false }
        
        return publicKeyDecode.count == WavesCryptoConstants.keyLength
    }

    public func verifyAddress(address: Address, chainId: String?, publicKey: PublicKey?) -> Bool {
        
        guard let bytes = base58decode(input: address) else { return false }
        
        if bytes.count == WavesCryptoConstants.addressLength
            && bytes[0] == WavesCryptoConstants.addressVersion
            && bytes[1] == (chainId?.utf8.first ?? 0) {
            let checkSum = Array(bytes[bytes.count - WavesCryptoConstants.checksumLength..<bytes.count])
            let checkSumGenerated = calcCheckSum(Array(bytes[0..<bytes.count - WavesCryptoConstants.checksumLength]))
            
            return checkSum == checkSumGenerated
        }
        
        return false
    }
}

// MARK: - Methods are creating keys

extension WavesCrypto {
    
    public func keyPair(seed: Seed) -> KeyPair? {
        
        let seedData = Data(seedHash(Array(seed.utf8)))
        
        guard let pair = Curve25519.generateKeyPair(seedData) else { return nil }
        
        guard let privateKeyData = pair.privateKey() else { return nil }
        let privateKeyBytes = privateKeyData.withUnsafeBytes {
            [UInt8]($0)
        }
        
        guard let publicKeyData = pair.publicKey() else { return nil }
        let publicKeyBytes = publicKeyData.withUnsafeBytes {
            [UInt8]($0)
        }
        
        guard let privateKey = base58encode(input: privateKeyBytes) else { return nil }
        guard let publicKey = base58encode(input: publicKeyBytes) else { return nil }
        
        return KeyPair(publicKey: publicKey,
                       privateKey: privateKey)
    }
    
    public func publicKey(seed: Seed) -> PublicKey? {
        return keyPair(seed: seed)?.publicKey
    }
    
    public func privateKey(seed: Seed) -> PrivateKey? {
        return keyPair(seed: seed)?.privateKey
    }
    
    public func randomSeed() -> Seed {
        return generatePhrase()
    }
}

// MARK: - Methods Hash

extension WavesCrypto {
    
    public func blake2b256(input: Bytes) -> Bytes {
        
        var data = Data(count: WavesCryptoConstants.keyLength)
        var key: UInt8 = 0
        data.withUnsafeMutableBytes { (rawPointer) -> Void in
            guard let bytes = rawPointer.bindMemory(to: UInt8.self).baseAddress else { return }
            crypto_generichash_blake2b(bytes, WavesCryptoConstants.keyLength, input, UInt64(input.count), &key, 0)
        }
        
        return Array(data)
    }
    
    public func keccak256(input: Bytes) -> Bytes {
        
        var data = Data(count: WavesCryptoConstants.keyLength)
        
        data.withUnsafeMutableBytes { (rawPointer) -> Void in
            guard let bytes = rawPointer.bindMemory(to: UInt8.self).baseAddress else { return }
            Keccak.keccak(Array(input), Int32(input.count), bytes, 32)
        }
        
        return Array(data)
    }
    
    public func sha256(input: Bytes) -> Bytes {
        
        let len = Int(CC_SHA256_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: len)
        
        CC_SHA256(input, CC_LONG(input.count), &digest)
        
        return Array(digest[0..<len])
    }
}

// MARK: - Method for encode/decode base58/64

extension WavesCrypto {
    
    public func base58encode(input: Bytes) -> String? {
        
        let result = Base58.encode(input)
        
        if result.count == 0 {
            return nil
        }
        
        return result
    }
    
    public func base58decode(input: String) -> Bytes? {
        
        let result = Base58.decode(input)
        
        if result.count == 0 {
            return nil
        }
        
        return result
    }
    
    public func base64encode(input: Bytes) -> String {
        return Data(input).base64EncodedString()
    }
    
    public func base64decode(input: String) -> Bytes? {
        
        guard let data = Data(base64Encoded: input) else { return nil }
        
        return Array(data)
    }
}

// MARK: - Hash for seed

private extension WavesCrypto {
    
    
    func secureHash(_ input: Bytes) -> Bytes {
        
        return keccak256(input: blake2b256(input: input))
    }
    
    func seedHash(_ seed: Bytes) -> Bytes {
        
        let nonce: [UInt8] = [0, 0, 0, 0]
        let input = nonce + seed

        return sha256(input: secureHash(input))
    }
    
    func calcCheckSum(_ withoutChecksum: Bytes) -> Bytes {
        return Array(secureHash(withoutChecksum)[0..<WavesCryptoConstants.checksumLength])
    }

}

// MARK: - Generate Phrase

private extension WavesCrypto {
    
    private func randomBytes(_ length: Int) -> Bytes {
        
        var data = Data(count: length)
        
        data.withUnsafeMutableBytes { (rawPointer) -> Void in
            guard let bytes = rawPointer.bindMemory(to: UInt8.self).baseAddress else { return }
            let _ = SecRandomCopyBytes(kSecRandomDefault, length, bytes)
        }
        
        return Array(data)
    }
    
    private func bytesToBits(_ data: Bytes) -> [Bool] {
        
        var bits: [Bool] = []
        for i in 0..<data.count {
            for j in 0..<8 {
                bits.append((data[i] & UInt8(1 << (7 - j))) != 0)
            }
        }
        return bits
    }
    
    private func generatePhrase() -> String {
        let nbWords = 15;
        let len = nbWords / 3 * 4;
        let entropy = randomBytes(len)
        
        let hash = sha256(input: entropy)
        let hashBits = bytesToBits(hash)
        
        let entropyBits = bytesToBits(entropy)
        let checksumLengthBits = entropyBits.count / 32
        
        let concatBits = entropyBits + hashBits[0..<checksumLengthBits]
        
        var words: [String] = []
        let nwords = concatBits.count / 11
        for i in 0..<nwords {
            var index = 0
            for j in 0..<11 {
                index <<= 1
                if concatBits[(i * 11) + j] { index |= 0x1 }
            }
            words += [Words.list[index]]
        }
        
        return words.joined(separator: " ")
    }
}
