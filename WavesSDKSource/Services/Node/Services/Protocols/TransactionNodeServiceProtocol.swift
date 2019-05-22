//
//  TransactionNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol TransactionNodeServiceProtocol {
    
    func broadcast(query: NodeService.Query.Broadcast, enviroment: EnviromentService) -> Observable<NodeService.DTO.Transaction>
    
    func list(address: String, offset: Int, limit: Int, enviroment: EnviromentService) -> Observable<NodeService.DTO.TransactionContainers>
}
