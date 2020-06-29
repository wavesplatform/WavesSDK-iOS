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
        public let senders: [String]?
        
        /// (ISO-8601 or timestamp in milliseconds)
        public let timeStart: String?
        
        /// (ISO-8601 or timestamp in milliseconds)
        public let timeEnd: String?
        
        ///
        public let recipient: String
        
        /// Фильтрация транзакций по asset id
        public let assetId: String?
        
        /// Курсор последней записи в списке (base64 строчка которая держит в себе инфу по оффсету, таймстампа и тд)
        public let after: String?
        
        /// признак сортировки
        public let sort: SortOrder
        
        /// признак предела загрузки за один раз
        public let limit: UInt?
        
        public init(senders: [String]?,
                    timeStart: String?,
                    timeEnd: String?,
                    recipient: String,
                    assetId: String?,
                    after: String?,
                    sort: SortOrder = .desc,
                    limit: UInt?) {
            self.timeStart = timeStart
            self.timeEnd = timeEnd
            self.recipient = recipient
            self.assetId = assetId
            self.after = after
            self.sort = sort
            self.limit = limit
            self.senders = senders
        }
    }
}
