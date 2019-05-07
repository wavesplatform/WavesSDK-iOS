//
//  TransactionNodeService.swift
//  Alamofire
//
//  Created by rprokofev on 26/04/2019.
//

import Foundation
import RxSwift
import Moya

public protocol TransactionNodeServiceProtocol {
    
    func broadcast(query: Node.Query.Broadcast, enviroment: EnviromentService) -> Observable<Node.DTO.Transaction>
    
    func list(address: String, offset: Int, limit: Int, enviroment: EnviromentService) -> Observable<Node.DTO.TransactionContainers>
}

final class TransactionNodeService: TransactionNodeServiceProtocol {

    private let transactionsProvider: MoyaProvider<Node.Service.Transaction>
    
    init(transactionsProvider: MoyaProvider<Node.Service.Transaction>) {
        self.transactionsProvider = transactionsProvider
    }
    
    public func broadcast(query: Node.Query.Broadcast, enviroment: EnviromentService) -> Observable<Node.DTO.Transaction> {
        
        return self
            .transactionsProvider
            .rx
            .request(.init(kind: .broadcast(query),
                           nodeUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(Node.DTO.Transaction.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .asObservable()

    }
    
    public func list(address: String, offset: Int, limit: Int, enviroment: EnviromentService) -> Observable<Node.DTO.TransactionContainers> {
        
        return self
            .transactionsProvider
            .rx
            .request(.init(kind: .list(accountAddress: address,
                                       limit: limit),
                           nodeUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(Node.DTO.TransactionContainers.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .asObservable()
    }
}

