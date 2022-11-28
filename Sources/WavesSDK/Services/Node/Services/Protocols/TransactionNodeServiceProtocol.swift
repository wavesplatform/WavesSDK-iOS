//
//  TransactionNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol TransactionNodeServiceProtocol {

  /**
   Broadcast transaction one of type = [0; 16]
   */
  
  func transactions(query: NodeService.Query.Transaction) -> Observable<NodeService.DTO.Transaction>

  /**
   Get list of transactions where specified address has been involved
   - Parameter: address Address
   - Parameter: limit Number of transactions to be returned. Max is last 1000.
   */

  func transactions(by address: String, offset: Int, limit: Int) -> Observable<NodeService.DTO.TransactionContainers>

  func calculateFee(for tx: NodeService.Query.Transaction) -> Observable<NodeService.DTO.TransactionFee>
}
