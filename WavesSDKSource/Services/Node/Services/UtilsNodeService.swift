//
//  UtilsNodeService.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 3/12/19.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public protocol UtilsNodeServiceProtocol {
    
    func time(serverUrl: URL) -> Observable<Node.DTO.Utils.Time>
}

final class UtilsNodeService: UtilsNodeServiceProtocol {
    
    private let utilsProvider: MoyaProvider<Node.Service.Utils>
    
    init(utilsProvider: MoyaProvider<Node.Service.Utils>) {
        self.utilsProvider = utilsProvider
    }
    
    public func time(serverUrl: URL) -> Observable<Node.DTO.Utils.Time> {
    
        return utilsProvider
            .rx
            .request(.init(nodeUrl: serverUrl, kind: .time),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(Node.DTO.Utils.Time.self)
            .asObservable()
        .debug("ALAZ", trimOutput: true)
    }
    
    deinit {
        print("DEINIT")
    }
}
