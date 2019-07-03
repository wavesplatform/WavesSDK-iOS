//
//  LeasingNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol LeasingNodeServiceProtocol {
    
    func leasingActiveTransactions(by address: String) -> Observable<[NodeService.DTO.LeaseTransaction]>
}
