//
//  MassTransferDataQuery.swift
//  WavesSDK
//
//  Created by vvisotskiy on 10.03.2020.
//  Copyright © 2020 Waves. All rights reserved.
//

import Foundation

extension DataService.Query {
    
    /// Способы сортировок
    public enum SortOrder: String, Encodable, Hashable {
        /// по возростанию
        case asc
        
        /// по убыванию
        case desc
    }
    
    public struct MassTransferDataQuery: Encodable, Hashable {
        
        ///
        public let sender: String?
        
        ///
        public let timeStart: String?
        
        ///
        public let timeEnd: String?
        
        ///
        public let recipient: String?
        
        /// Фильтрация транзакций по asset id
        public let assetId: String?
        
        /// Курсор последней записи в списке (base64 строчка которая держит в себе инфу по оффсету, таймстампа и тд)
        public let after: String?
        
        /// признак сортировки
        public let sort: SortOrder
        
        /// признак предела загрузки за один раз
        public let limit: UInt
        
        public init(sender: String?,
                    timeStart: String?,
                    timeEnd: String?,
                    recipient: String?,
                    assetId: String?,
                    after: String?,
                    sort: SortOrder = .desc,
                    limit: UInt = 25) {
            self.sender = sender
            self.timeStart = timeStart
            self.timeEnd = timeEnd
            self.recipient = recipient
            self.assetId = assetId
            self.after = after
            self.sort = sort
            self.limit = limit
        }
    }
}
