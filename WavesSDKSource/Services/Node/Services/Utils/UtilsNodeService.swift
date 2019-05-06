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
    
    func time(enviroment: EnviromentService) -> Observable<Node.DTO.Utils.Time>
}

public final class UtilsNodeService: UtilsNodeServiceProtocol {
    
    private let utilsProvider: MoyaProvider<Node.Service.Utils> = .nodeMoyaProvider()
    
    public func time(enviroment: EnviromentService) -> Observable<Node.DTO.Utils.Time> {
    
        return utilsProvider
            .rx
            .request(.init(nodeUrl: enviroment.serverUrl, kind: .time),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(Node.DTO.Utils.Time.self)
            .asObservable()
    }
}
