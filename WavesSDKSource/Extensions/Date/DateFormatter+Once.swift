//
//  DateFormatter+Once.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 29/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension DateFormatter {

    static func sharedFormatter(key: String) -> DateFormatter {
        return Thread
            .threadSharedObject(key: key,
                                create: { return DateFormatter() })
    }
}
