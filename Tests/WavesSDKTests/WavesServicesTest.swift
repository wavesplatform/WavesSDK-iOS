//
//  WaveSDKTransactions.swift
//  WavesSDKTests
//
//  Created by rprokofev on 28.06.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import XCTest
import WavesSDK
import WavesSDKCrypto

class WavesServicesTest: XCTestCase {
        
    var chainId: UInt8!
    var seed: String!
    var address: String!
    var senderPublicKey: String!
    
    override func setUp() {
        
        SweetLogger.current.add(plugins: [SweetLoggerConsole(visibleLevels: [.network, .error], isShortLog: false)])
        SweetLogger.current.visibleLevels = [.network, .error]
        
        WavesSDK.initialization(servicesPlugins: .init(data: [],
                                                       node: [],
                                                       matcher: []),
                                enviroment: .init(server: .testNet, timestampServerDiff: 0))
        
        //TODO: Loading Seed
        self.seed = "great ivory wealth decide crowd devote fiction wool net ethics dog hurry cost aunt daring"
                
        guard let chainId = WavesSDK.shared.enviroment.chainId else { return }
        guard let address = WavesCrypto.shared.address(seed: seed, chainId: chainId) else { return }
        guard let senderPublicKey = WavesCrypto.shared.publicKey(seed: seed) else { return }
        
        self.chainId = chainId
        self.address = address
        self.senderPublicKey = senderPublicKey
    }
    
    override func tearDown() {}

}
