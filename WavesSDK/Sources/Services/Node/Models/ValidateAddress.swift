//
//  BlockNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 10.09.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    
    struct ValidateAddress: Decodable {
        public let address: String
        public let valid: Bool
    }
    
}
