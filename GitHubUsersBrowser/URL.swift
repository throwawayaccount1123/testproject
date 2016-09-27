//
//  Copyright © 2016 Sergey Lem. All rights reserved.
//

import Foundation

extension URL {
    
    func appending(queryParams: [String: Any]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        queryParams.forEach { (key: String, value: Any) in
            urlComponents.appendQueryItem(name: key, value: "\(value)")
        }
        return try! urlComponents.asURL()
    }
    
}


extension URLComponents {
    
    mutating func appendQueryItem(name: String, value: String) {
        var queryItems: [NSURLQueryItem] = self.queryItems as [NSURLQueryItem]? ?? [NSURLQueryItem]()
        queryItems.append(NSURLQueryItem(name: name, value: value))
        self.queryItems = queryItems as [URLQueryItem]?
    }
    
}
