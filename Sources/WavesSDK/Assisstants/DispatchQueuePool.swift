//
//  DispatchQueuePool.swift
//  WavesSDK
//
//  Created by rprokofev on 17.12.2020.
//  Copyright © 2020 Waves. All rights reserved.
//

import Foundation

struct DispatchQueuePool {
    static let userInteractive = DispatchQueue(label: "WavesSDK", qos: .userInteractive,
                                               attributes: .concurrent,
                                               autoreleaseFrequency: .inherit,
                                               target: nil)
    
}
