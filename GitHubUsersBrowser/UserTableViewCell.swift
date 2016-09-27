//
//  Copyright © 2016 Sergey Lem. All rights reserved.
//

import UIKit
import ImageLoader

class UserTableViewCell: UITableViewCell {
    
    //MARK:- Types
    
    //MARK:- Static
    
    static func nib() -> UINib {
        return UINib(nibName: "UserTableViewCell", bundle: nil)
    }
    
    static let reuseIdentifier = "userCell"
    
    //MARK:- Props
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLink: UIButton!
    
    private var profileURL: URL? {
        didSet {
            if let url = self.profileURL {
                self.userLink.setTitle(url.absoluteString,
                                       for: .normal)
            } else {
                self.userLink.setTitle("",
                                       for: .normal)
            }
        }
    }
    
    //MARK:- Init
    
    //MARK:- Interface
    
    func reloadWithUser(user: GUser?) {
        self.userNameLabel.text = user?.login
        self.profileURL = user?.profileURL
        if let avatarURL = user?.avatarURL {
            self.userImageView.load(avatarURL,
                                    placeholder: nil,
                                    completionHandler: { (url, image, err, cache) in
            })
        }
    }
    
    @IBAction func openProfile(_ sender: AnyObject) {
        if let url = self.profileURL {
            UIApplication.shared.openURL(url)
        }
    }
    //MARK:- Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userImageView.image = nil
        self.userNameLabel.text = nil
    }
    
    //MARK:- Private
    
    //MARK:- Helpers
    
}
