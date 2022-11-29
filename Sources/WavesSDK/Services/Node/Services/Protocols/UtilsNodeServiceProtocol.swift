//
//  UtilsNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol UtilsNodeServiceProtocol {

  /**
   Current Node time (UTC)
   */
  func time() -> Observable<NodeService.DTO.Utils.Time>

  func transactionSerialize(query: NodeService.Query.Transaction)-> Observable<[Int]>

  func scriptEvaluate(address: String, expr: String) -> Observable<NodeService.DTO.Utils.ScriptEvaluation>
}
