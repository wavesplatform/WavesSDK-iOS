source 'https://github.com/wavesplatform/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

use_frameworks!(true)

# Pods for WavesSDK
target 'WavesSDKExample' do

    inherit! :search_paths
    pod 'WavesSDKExtensions',  :path => '.'    
    pod 'WavesSDK',  :path => '.'   
    pod 'WavesSDKCrypto',  :path => '.'        
end

# Pods for InternalWavesSDKExtensionsK
target 'InternalWavesSDKExtensions' do

    inherit! :search_paths
    pod 'RxSwift', '~> 4.0'    
end

# Pods for InternalWavesSDK
target 'InternalWavesSDK' do

    inherit! :search_paths
    pod 'RxSwift', '~> 4.0'
    pod 'Moya', '~> 12.0.1'
    pod 'Moya/RxSwift', '~> 12.0.1'
    pod 'WavesSDKExtensions',  :path => '.'         
    pod 'WavesSDKCrypto',  :path => '.'        
end

# Pods for InternalWavesSDKCrypto
target 'InternalWavesSDKCrypto' do

    inherit! :search_paths
    pod 'CryptoSwift'
    pod 'Curve25519'
    pod 'Base58'
    pod 'Keccak'
    pod 'Blake2'    
    pod 'WavesSDKExtensions',  :path => '.'        
end

target 'WavesSDKTests' do

    inherit! :search_paths
    pod 'WavesSDKExtensions',  :path => '.'    
    pod 'WavesSDKCrypto',  :path => '.' 
    pod 'WavesSDK',  :path => '.'  
    pod 'Fakery'  
    pod 'Nimble'
    pod 'RxTest'
end
