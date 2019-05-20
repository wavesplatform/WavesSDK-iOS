//
//  MatcherService.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 12/26/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import Moya

extension MatcherService.Target {
    
    struct MatcherPublicKey {
        var matcherUrl: URL
    }
}

extension MatcherService.Target.MatcherPublicKey: MatcherTargetType {
    
    private enum Constants {
        static let matcher: String = "matcher"
    }
    
    var path: String {
        return Constants.matcher
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
}
