//
//  BlocksNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import RxSwift
import Moya

public protocol BlocksNodeServiceProtocol {
    
    func height(address: String, enviroment: EnviromentService) -> Observable<Node.DTO.Block>
}

public final class BlocksNodeService: BlocksNodeServiceProtocol {
    
    private let blockNode: MoyaProvider<Node.Service.Blocks> = .nodeMoyaProvider()
    
    public func height(address: String, enviroment: EnviromentService) -> Observable<Node.DTO.Block> {
        
        return self
            .blockNode
            .rx
            .request(Node.Service.Blocks(nodeUrl: enviroment.serverUrl,
                                         kind: .height))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(Node.DTO.Block.self)
            .asObservable()
    }
}


