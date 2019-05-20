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
    
    func height(address: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.Block>
}

final class BlocksNodeService: BlocksNodeServiceProtocol {
    
    private let blocksProvider: MoyaProvider<NodeService.Target.Blocks>
    
    init(blocksProvider: MoyaProvider<NodeService.Target.Blocks>) {
        self.blocksProvider = blocksProvider
    }
    
    public func height(address: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.Block> {
        
        return self
            .blocksProvider
            .rx
            .request(NodeService.Target.Blocks(nodeUrl: enviroment.serverUrl,
                                         kind: .height))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.Block.self)
            .asObservable()
    }
}


