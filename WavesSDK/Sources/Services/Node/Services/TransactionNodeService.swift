//
//  TransactionNodeService.swift
//  Alamofire
//
//  Created by rprokofev on 26/04/2019.
//

import Foundation
import RxSwift
import Moya

final class TransactionNodeService: TransactionNodeServiceProtocol {

    private let transactionsProvider: MoyaProvider<NodeService.Target.Transaction>
    var enviroment: Enviroment
    
    init(transactionsProvider: MoyaProvider<NodeService.Target.Transaction>, enviroment: Enviroment) {
        self.transactionsProvider = transactionsProvider
        self.enviroment = enviroment
    }
    
    public func broadcast(query: NodeService.Query.Broadcast) -> Observable<NodeService.DTO.Transaction> {
        
        return self
            .transactionsProvider
            .rx
            .request(.init(kind: .broadcast(query),
                           nodeUrl: enviroment.nodeUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.Transaction.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .asObservable()
    }
    
    //TODO: rename TransactionsByAddress
    public func list(address: String, offset: Int, limit: Int) -> Observable<NodeService.DTO.TransactionContainers> {
        
        return self
            .transactionsProvider
            .rx
            .request(.init(kind: .list(address: address,
                                       limit: limit),
                           nodeUrl: enviroment.nodeUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.TransactionContainers.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .asObservable()
    }
}

