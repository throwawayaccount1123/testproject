//
//  Copyright © 2016 Sergey Lem. All rights reserved.
//

import Foundation

protocol UsersFetcherDelegate {
    func didStartLoad()
    func didFinishLoad()
}

class UsersFetcher {
    
    //MARK:- Types
    
    typealias FetchResult = (Error?) -> Void
    
    //MARK:- Static
    
    //MARK:- Props
    
    var users: [GUser] = [GUser]()
    
    var delegate: UsersFetcherDelegate?
    
    var busy: Bool = false {
        didSet {
            if self.busy {
                self.delegate?.didStartLoad()
            } else {
                self.delegate?.didFinishLoad()
            }
        }
    }
    
    private let client: GitHubClient = GitHubClient()
    private var nextURL: URL = GitHubClient.allUsersURL()
    
    //MARK:- Init
    
    //MARK:- Interface
    
    func setupForFetchingFollowers(user: GUser) {
        self.nextURL = GitHubClient.followersURLFor(user: user)
    }
    
    func fetchMore() {
        if !self.busy {
            self.busy = true
            self.client.fetchUsers(url: self.nextURL,
                                   handler: { (json, nextURL, err) in
                                    
                                    if let err = err {
                                        debugPrint("Error occured \(err.localizedDescription)")
                                    } else if let jsonObjects = json {
                                        var newUsers = [GUser]()
                                        for userJson in jsonObjects {
                                            if let user = GUser(json: userJson) {
                                                newUsers.append(user)
                                            }
                                        }
                                        self.users.append(contentsOf: newUsers)
                                        if let nextURL = nextURL {
                                            self.nextURL = nextURL
                                        }
                                    }
                                    
                                    self.busy = false
                                    
            })
        }
    }
    
    //MARK:- Lifecycle
    
    //MARK:- Private
    
    //MARK:- Helpers
    
}
