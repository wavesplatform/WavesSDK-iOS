//
//  LeasingNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol LeasingNodeServiceProtocol {
    
    func activeLeasingTransactions(by address: String) -> Observable<[NodeService.DTO.LeaseTransaction]>
}
