Pod::Spec.new do |spec|
  
  spec.name         = 'WavesSDKExtensions'  
  spec.version      = '0.1.7'
  spec.ios.deployment_target = '11.0'
  spec.requires_arc = true
  spec.swift_version = '5.0'

  spec.license      = { :type => 'MIT License', :file => 'LICENSE' }
  spec.homepage     = 'https://wavesplatform.com'
  spec.authors      = { 'Mefilt' => 'mefilt@gmail.com', }
  spec.summary      = 'WavesSDK – it is mobile libraries for easy and simple co-working Waves blockchain platform and any mobile app'  
  
  spec.source_files =  'WavesSDKExtensions/Sources/**/*.{swift}'
  spec.source =  {  :git => 'https://github.com/wavesplatform/WavesSDK-iOS.git', :tag => 'v' + spec.version.to_s}
    
  spec.ios.framework = 'Foundation'
  spec.ios.framework = 'UIKit'

  spec.dependency 'RxSwift', '~> 4.0'
  
end
