//
//  BlocksNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import RxSwift
import Moya

final class BlocksNodeService: BlocksNodeServiceProtocol {
    
    private let blocksProvider: MoyaProvider<NodeService.Target.Blocks>
    var enviroment: Enviroment
    
    init(blocksProvider: MoyaProvider<NodeService.Target.Blocks>, enviroment: Enviroment) {
        self.blocksProvider = blocksProvider
        self.enviroment = enviroment
    }

    /**
      Get current Waves block-chain height
      - Parameter: address Address of account
     */
    public func height(address: String) -> Observable<NodeService.DTO.Block> {
        
        return self
            .blocksProvider
            .rx
            .request(NodeService.Target.Blocks(nodeUrl: enviroment.nodeUrl,
                                         kind: .height))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.Block.self)
            .asObservable()
    }
}


