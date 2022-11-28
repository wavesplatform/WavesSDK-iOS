//
//  String+URL.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 22/10/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public extension String {

    var isValidUrl: Bool {
        let urlRegEx = "[(http(s)?)://(www\\.)?a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#?&//=]*)"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
    func urlByAdding(params: [String : String]) -> String {
    
        var url = self
        for key in params.keys {
            if let value = params[key] {
                if (url as NSString).range(of: "?").location == NSNotFound {
                    url.append("?")
                }
                
                if url.last != "?" {
                    url.append("&")
                }
                url.append(key + "=" + value)
            }
        }
        return url
    }
}
