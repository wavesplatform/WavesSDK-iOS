//
//  BlocksNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol BlocksNodeServiceProtocol {
    
    func height(address: String) -> Observable<NodeService.DTO.Block>
}
