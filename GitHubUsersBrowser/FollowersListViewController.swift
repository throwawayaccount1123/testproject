//
//  Copyright © 2016 Sergey Lem. All rights reserved.
//

import UIKit

class FollowersListViewController: UIViewController,
UITableViewDataSource,
UITableViewDelegate,
UsersFetcherDelegate {
    
    //MARK:- Types
    
    //MARK:- Static
    
    static func controllerForUser(user: GUser) -> FollowersListViewController {
        let controller = UIStoryboard(name: "Main",
                                      bundle: nil).instantiateViewController(withIdentifier: "followersVC") as! FollowersListViewController
        controller.user = user
        return controller
    }
    
    //MARK:- Props
    
    @IBOutlet weak var tableView: UITableView!
    
    private var usersFetcher: UsersFetcher = UsersFetcher()
    
    private var user: GUser!
    
    //MARK:- Init
    
    //MARK:- Interface
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Followers for \(self.user.login)"
        
        self.tableView.register(UserTableViewCell.nib(),
                                forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        
        self.usersFetcher.setupForFetchingFollowers(user: self.user)
        
        self.usersFetcher.delegate = self
        self.usersFetcher.fetchMore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private
    
    //MARK:- Helpers
    
    private func objectFor(indexPath: IndexPath) -> GUser? {
        if self.usersFetcher.users.count > indexPath.row {
            return self.usersFetcher.users[indexPath.row]
        }
        return nil
    }
    
    //MARK:- UsersFetcherDelegate
    
    func didStartLoad() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        if self.usersFetcher.users.isEmpty {
            self.tableView.tableHeaderView = activityIndicator
        } else {
            self.tableView.tableFooterView = activityIndicator
        }
        
        activityIndicator.startAnimating()
    }
    
    func didFinishLoad() {
        (self.tableView.tableHeaderView as? UIActivityIndicatorView)?.stopAnimating()
        (self.tableView.tableFooterView as? UIActivityIndicatorView)?.stopAnimating()
        
        self.tableView.reloadData()
    }
    
    //MARK:- UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        if (scrollOffset + (scrollViewHeight * 1.5) > scrollContentSizeHeight) {
            self.usersFetcher.fetchMore()
        }
        
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    //MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersFetcher.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier) as? UserTableViewCell
        cell?.reloadWithUser(user: self.objectFor(indexPath: indexPath))
        return cell ?? UITableViewCell()
    }
}
