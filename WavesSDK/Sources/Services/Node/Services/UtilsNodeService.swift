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

final class UtilsNodeService: InternalWavesService, UtilsNodeServiceProtocol {
    
    private let utilsProvider: MoyaProvider<NodeService.Target.Utils>
    
    init(utilsProvider: MoyaProvider<NodeService.Target.Utils>, enviroment: Enviroment) {
        self.utilsProvider = utilsProvider
        super.init(enviroment: enviroment)
    }
    
    private struct Utils: Decodable {
        let bytes: [Int]
    }
    
    func transactionSerialize(query: NodeService.Query.Transaction)-> Observable<[Int]> {
        
        return self
            .utilsProvider
            .rx
            .request(.init(nodeUrl: enviroment.nodeUrl,
                           kind: .transactionSerialize(query)),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(Utils.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .map { $0.bytes }
            .asObservable()
    }
    

    public func time() -> Observable<NodeService.DTO.Utils.Time> {
    
        return utilsProvider
            .rx
            .request(.init(nodeUrl: enviroment.nodeUrl, kind: .time),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.Utils.Time.self)
            .asObservable()
    }
}
