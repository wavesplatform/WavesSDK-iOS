Pod::Spec.new do |spec|

  spec.name         = 'WavesSDKCrypto'  
  spec.version      = '0.1'
  spec.ios.deployment_target = '10.0'
  spec.requires_arc = true
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://wavesplatform.com'
  spec.authors      = { 'Mefilt' => 'Mefilt@gmail.com' }
  spec.summary      = 'The library contains method, variable and other entities for development on crypto'  

  spec.source_files =  'WavesSDKSource/Crypto/**/*.{swift}'
  spec.source       = { 'git' => 'https://github.com/wavesplatform/WavesSDK-iOS.git' }
  
  spec.ios.framework = 'Foundation'
  spec.ios.framework = 'UIKit'
  spec.ios.framework = 'Security'  

  spec.dependency 'RxSwift', '~> 4.0'
  spec.dependency 'WavesSDKExtension'
  spec.dependency 'CryptoSwift'
  spec.dependency 'Curve25519'
  spec.dependency 'Base58'
  spec.dependency 'Keccak'
  spec.dependency 'Blake2'
end
