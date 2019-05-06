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

public final class TransactionNodeService: TransactionNodeServiceProtocol {

    private let transactions: MoyaProvider<Node.Service.Transaction> = .nodeMoyaProvider()
    
    public func broadcast(query: Node.Query.Broadcast, enviroment: EnviromentService) -> Observable<Node.DTO.Transaction> {
        
        return self
            .transactions
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
            .transactions
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

