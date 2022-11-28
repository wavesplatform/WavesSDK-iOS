//
//  MassTransferDataQuery.swift
//  WavesSDK
//
//  Created by vvisotskiy on 10.03.2020.
//  Copyright © 2020 Waves. All rights reserved.
//

import Foundation

extension DataService.Query {
    
    /// Sorting methods
    public enum SortOrder: String, Encodable, Hashable {
        /// ascending
        case asc
        
        /// descending
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
        public let recipient: String?
        
        /// Filtering transactions by asset id
        public let assetId: String?
        
        /// Cursor of the last entry in the list (base64 line that contains info on offset, timestamp, etc.)
        public let after: String?
        
        /// sort sign
        public let sort: SortOrder
        
        /// download limit at one time
        public let limit: UInt?
        
        public init(senders: [String]?,
                    timeStart: String?,
                    timeEnd: String?,
                    recipient: String?,
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
