//
//  NumberFormatter+Once.swift
//  WavesSDKExtensions
//
//  Created by Sergey Gusev on 24.12.2020.
//  Copyright © 2020 Waves. All rights reserved.
//

import Foundation

public extension NumberFormatter {

    static func sharedFormatter(key: String) -> NumberFormatter {
        return Thread
            .threadSharedObject(key: key,
                                create: { return NumberFormatter() })
    }
}
