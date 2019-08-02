Pod::Spec.new do |spec|

  spec.name         = 'WavesSDKCrypto'  
  spec.version      = '0.1.7'
  spec.ios.deployment_target = '11.0'
  spec.requires_arc = true
  spec.swift_version = '5.0'

  spec.license      = { :type => 'MIT License', :file => 'LICENSE' }
  spec.homepage     = 'https://wavesplatform.com'
  spec.authors      = { 'Mefilt' => 'mefilt@gmail.com', }

  spec.summary      = 'WavesSDK – it is mobile libraries for easy and simple co-working Waves blockchain platform and any mobile app'  

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
  
  spec.ios.framework = 'Foundation'
  spec.ios.framework = 'UIKit'
  spec.ios.framework = 'Security'
  spec.dependency 'WavesSDKExtensions'
  
end
