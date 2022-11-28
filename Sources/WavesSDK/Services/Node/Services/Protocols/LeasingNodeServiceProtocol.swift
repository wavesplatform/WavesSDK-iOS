//
//  LeasingNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol LeasingNodeServiceProtocol {
    
/**
     Active leasing transactions of account
     - Parameter: address Address
*/
    func leasingActiveTransactions(by address: String) -> Observable<[NodeService.DTO.LeaseResponse]>
    
}
