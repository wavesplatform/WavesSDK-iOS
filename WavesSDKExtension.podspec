Pod::Spec.new do |spec|
  
  spec.name         = 'WavesSDKExtension'  
  spec.version      = '0.1'
  spec.ios.deployment_target = '10.0'
  spec.requires_arc = true
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://wavesplatform.com'
  spec.authors      = { 'Mefilt' => 'Mefilt@gmail.com' }
  spec.summary      = 'Extensions are helping for developer fast write code'  

  spec.source_files =  'WavesSDKSource/Extensions/**/*.{swift}'
  spec.source =  {  :git => 'https://github.com/wavesplatform/WavesSDK-iOS.git' }
  
  spec.ios.framework = 'Foundation'
  spec.ios.framework = 'UIKit'

  spec.dependency 'RxSwift', '~> 4.0'
end
