//
//  Copyright © 2016 Sergey Lem. All rights reserved.
//

import UIKit

extension NSError {
    
    static func applicationError(code: Int, description: String?) -> Error {
        return NSError(domain: Bundle.main.bundleIdentifier!,
                       code: code,
                       userInfo: [
                        NSLocalizedDescriptionKey: description ?? "Unknown error"
            ])
    }
    
}
