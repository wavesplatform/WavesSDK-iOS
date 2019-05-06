//
//  BlockNode.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 10.09.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension Node.DTO {
    struct Block: Decodable {
        let height: Int64
    }
}
