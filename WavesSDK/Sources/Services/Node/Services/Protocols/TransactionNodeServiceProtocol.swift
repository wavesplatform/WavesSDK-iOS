//
//  TransactionNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol TransactionNodeServiceProtocol {
    
    func transactions(query: NodeService.Query.Transaction) -> Observable<NodeService.DTO.Transaction>
        
    func list(address: String, offset: Int, limit: Int) -> Observable<NodeService.DTO.TransactionContainers>
}
