//
//  Copyright © 2016 Sergey Lem. All rights reserved.
//

import Foundation
import Alamofire

class GitHubClient {
    
    //MARK:- Types
    
    typealias FetchResult = ([Dictionary<String,Any>]?, URL?, Error?) -> Void
    
    enum Const {
        static let githubHTMLBaseURL = URL(string: "https://github.com/")!
        static let githubAPIBaseURL = URL(string: "https://api.github.com/")!
        
        static let fetchPageDefaultSize = 20
        
        static let nextURLLinkHeader = "Link"
        
        static let githubAPIUsersPath = "users"
        static let githubAPIFollowersPath = "followers"
        static let unknownResponseError = NSError.applicationError(code: 1, description: "Invalid response")
    }
    
    //MARK:- Static
    
    static func allUsersURL() -> URL {
        return Const.githubAPIBaseURL
            .appendingPathComponent(Const.githubAPIUsersPath)
            .appending(queryParams: ["per_page" : Const.fetchPageDefaultSize])
    }
    
    static func followersURLFor(user: GUser) -> URL {
        return Const.githubAPIBaseURL
            .appendingPathComponent(Const.githubAPIUsersPath)
            .appendingPathComponent(user.login)
            .appendingPathComponent(Const.githubAPIFollowersPath)
            .appending(queryParams: ["per_page" : Const.fetchPageDefaultSize])
    }
    
    //MARK:- Props
    
    //MARK:- Init
    
    init() { }
    
    deinit { }
    
    //MARK:- Interface
    
    func fetchUsers(url: URL,
                    handler: @escaping FetchResult) {
        
        Alamofire
            .request(url)
            .validate()
            .responseJSON { response in
                
                let nextURL = self.parseNextURL(str: response.response?.allHeaderFields[Const.nextURLLinkHeader] as? String)
                
                switch response.result {
                case .success:
                    if let json = response.result.value as? [Dictionary<String,Any>] {
                        handler(json, nextURL, nil)
                    } else {
                        handler(nil, nil, Const.unknownResponseError)
                    }
                case .failure(let error):
                    handler(nil, nil, error)
                }
        }
        
    }
    
    //MARK:- Lifecycle
    
    //MARK:- Private
    
    //MARK:- Helpers
    
    private func parseNextURL(str: String?) -> URL? {
        
        guard let str = str else {
            return nil
        }
        
        let regexp = try! NSRegularExpression(pattern: "<(.+)>", options: .caseInsensitive)
        
        if
            let urlInBrackets = str.components(separatedBy: ";").first,
            let match = regexp.firstMatch(in: urlInBrackets,
                                          options: [],
                                          range: NSMakeRange(0, urlInBrackets.characters.count)),
            match.numberOfRanges > 1 {
            
            let range = match.rangeAt(1)
            
            let lo = urlInBrackets.index(urlInBrackets.startIndex, offsetBy: range.location)
            let hi = urlInBrackets.index(urlInBrackets.startIndex, offsetBy: range.location + range.length)
            
            return URL(string: urlInBrackets[lo..<hi])
        }
        return nil
    }
    
}
