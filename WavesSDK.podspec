Pod::Spec.new do |spec|
  
  spec.name         = 'WavesSDK'
  spec.version      = '0.1.7'
  spec.ios.deployment_target = '11.0'
  spec.requires_arc = true
  spec.swift_version = '5.0'

  spec.license      = { :type => 'MIT License', :file => 'LICENSE' }
  spec.homepage     = 'https://wavesplatform.com'
  spec.authors      = { 'Mefilt' => 'mefilt@gmail.com', }
  spec.summary      = 'Extensions are helping for developer fast write code'  

  spec.source_files =  'WavesSDK/Sources/**/*.{swift}'
  spec.source =  {  :git => 'https://github.com/wavesplatform/WavesSDK-iOS.git', :tag => 'v' + spec.version.to_s}
  
  spec.ios.framework = 'Foundation'
  spec.ios.framework = 'UIKit'

  spec.dependency 'RxSwift', '~> 4.0'
  spec.dependency 'Moya', '~> 12.0.1'
  spec.dependency 'Moya/RxSwift', '~> 12.0.1'
  spec.dependency 'WavesSDKExtensions'
  spec.dependency 'WavesSDKCrypto'
    
end
