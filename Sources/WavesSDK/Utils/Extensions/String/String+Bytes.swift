//
//  String+Bytes.swift
//  WavesSDKExtensions
//
//  Created by Pavel Gubin on 09.07.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation

public extension String {
    
    var toBytes: [UInt8] {
        return [UInt8](self.utf8)
    }
}
