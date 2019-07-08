source 'https://github.com/wavesplatform/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

use_frameworks!(true)


target 'WavesSDKTests' do

    inherit! :search_paths
    pod 'Fakery'  
    pod 'Nimble'
    pod 'RxTest'

    #TODO: How it fix?
    pod 'RxSwift', '~> 4.0'
    pod 'Moya', '~> 12.0.1'
    pod 'Moya/RxSwift', '~> 12.0.1'
end

# Pods for WavesSDK
target 'WavesSDKExample' do
    inherit! :search_paths   
end

# Pods for InternalWavesSDKExtensionsK
target 'WavesSDKExtensions' do
    inherit! :search_paths
    pod 'RxSwift', '~> 4.0'    
end

# Pods for InternalWavesSDK
target 'WavesSDK' do

    inherit! :search_paths
    pod 'RxSwift', '~> 4.0'
    pod 'Moya', '~> 12.0.1'
    pod 'Moya/RxSwift', '~> 12.0.1'
end

