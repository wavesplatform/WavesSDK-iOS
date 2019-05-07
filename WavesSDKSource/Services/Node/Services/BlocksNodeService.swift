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

final class BlocksNodeService: BlocksNodeServiceProtocol {
    
    private let blocksProvider: MoyaProvider<Node.Service.Blocks>
    
    init(blocksProvider: MoyaProvider<Node.Service.Blocks>) {
        self.blocksProvider = blocksProvider
    }
    
    public func height(address: String, enviroment: EnviromentService) -> Observable<Node.DTO.Block> {
        
        return self
            .blocksProvider
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


