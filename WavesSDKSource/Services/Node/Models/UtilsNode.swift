//
//  UtilsNode.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 3/12/19.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation

public extension NodeService.DTO {
    enum Utils {}
}

public extension NodeService.DTO.Utils {
    
    struct Time: Decodable {
        public let system: Int64
        public let NTP: Int64
    }
}
