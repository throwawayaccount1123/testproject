//
//  Copyright © 2016 Sergey Lem. All rights reserved.
//

import Foundation

class GUser {
    
    //MARK:- Types
    
    private enum Fields {
        static let id = "id"
        static let login = "login"
        static let profileURLString = "html_url"
        static let userAvatarURL = "avatar_url"
    }
    
    //MARK:- Static
    
    //MARK:- Props
    
    //MARK:- Init
    
    //MARK:- Interface
    
    //MARK:- Lifecycle
    
    //MARK:- Private
    
    //MARK:- Helpers
    
    let id: Int
    let login: String
    let profileURL: URL
    var avatarURL: URL?
    
    init?(json: [String: Any]) {
        
        guard
            let id = json[Fields.id] as? Int,
            let login = json[Fields.login] as? String
            else {
            return nil
        }
        
        self.login = login
        self.id = id
        if
            let profileURLString = json[Fields.profileURLString] as? String,
            let profileURL = URL(string: profileURLString) {
            
            self.profileURL = profileURL
        } else {
            self.profileURL = GitHubClient.Const.githubHTMLBaseURL.appendingPathComponent(login)
        }
        
        if let avatarURLString = json[Fields.userAvatarURL] as? String {
            self.avatarURL = URL(string: avatarURLString)
        }
    }
    
}
