platform :ios, '11.0'

use_frameworks!(true)


target 'WavesSDKTests' do

    inherit! :search_paths
    pod 'Fakery'  
    pod 'Nimble'
    # pod 'RxTest'

    #TODO: How it fix?
    pod 'RxSwift'
    pod 'Moya'
    pod 'Moya/RxSwift'
end

# Pods for WavesSDK
target 'StubTest' do
    inherit! :search_paths   
end

# Pods for InternalWavesSDKExtensionsK
target 'WavesSDKExtensions' do
    inherit! :search_paths
    pod 'RxSwift'
end

# Pods for InternalWavesSDK
target 'WavesSDK' do

    inherit! :search_paths
    pod 'RxSwift'
    pod 'Moya'
    pod 'Moya/RxSwift'
end

