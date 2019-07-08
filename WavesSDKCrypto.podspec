Pod::Spec.new do |spec|

  spec.name         = 'WavesSDKCrypto'  
  spec.version      = '0.1.4'
  spec.ios.deployment_target = '10.0'
  spec.requires_arc = true
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://wavesplatform.com'
  spec.authors      = { 'Mefilt' => 'Mefilt@gmail.com' }
  spec.summary      = 'The library contains method, variable and other entities for development on crypto'  

  spec.source       = { 'git' => 'https://github.com/wavesplatform/WavesSDK-iOS.git', :tag => 'v' + spec.version.to_s }

  spec.source_files = 
   'WavesSDKCrypto/Sources/*.{swift}',
   'WavesSDKCrypto/Vendors/Curve25519/Sources/Curve25519/curve25519-donna.c',
   'WavesSDKCrypto/Vendors/Curve25519/Sources/Objc/*.{h,m}',    
   'WavesSDKCrypto/Vendors/Curve25519/Sources/ed25519/*.{c,h}',
   'WavesSDKCrypto/Vendors/Curve25519/Sources/ed25519/additions/*.{c,h}',
   'WavesSDKCrypto/Vendors/Curve25519/Sources/ed25519/nacl_sha512/*.{c,h}',
   'WavesSDKCrypto/Vendors/Curve25519/Sources/ed25519/nacl_includes/*.{c,h}',
   'WavesSDKCrypto/Vendors/Blake2/Sources/*.{h,c}',
   'WavesSDKCrypto/Vendors/Base58Encoder/Sources/*.{h,c,swift}',
   'WavesSDKCrypto/Vendors/Keccak/Sources/*{h,c}'
   
  spec.public_header_files = 
  'WavesSDKCrypto/Vendors/Curve25519/Sources/Objc/*.{h}',
  'WavesSDKCrypto/Vendors/Blake2/Sources/blake2.h',
  'WavesSDKCrypto/Vendors/Blake2/Sources/crypto_generichash_blake2b.h',
  'WavesSDKCrypto/Vendors/Blake2/Sources/export.h',
  'WavesSDKCrypto/Vendors/Base58Encoder/Sources/*.{h}',
  'WavesSDKCrypto/Vendors/Keccak/Sources/*{h}'  
  
  spec.swift_version = '5.0'

  spec.ios.framework = 'Foundation'
  spec.ios.framework = 'UIKit'
  spec.ios.framework = 'Security'
  spec.dependency 'WavesSDKExtensions'
end
