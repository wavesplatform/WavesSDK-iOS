//
//  BlocksNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import RxSwift
import Moya

final class BlocksNodeService: InternalWavesService, BlocksNodeServiceProtocol {
    
    private let blocksProvider: MoyaProvider<NodeService.Target.Blocks>
    
    init(blocksProvider: MoyaProvider<NodeService.Target.Blocks>, enviroment: WavesEnvironment) {
        self.blocksProvider = blocksProvider
        super.init(enviroment: enviroment)
    }

    public func height(address: String) -> Observable<NodeService.DTO.Block> {
        
        return self
            .blocksProvider
            .rx
            .request(NodeService.Target.Blocks(nodeUrl: enviroment.nodeUrl,
                                         kind: .height))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.Block.self)
            .asObservable()
    }
}


