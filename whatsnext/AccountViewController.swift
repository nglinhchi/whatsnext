//
//  AccountViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 26/5/2022.
//

import UIKit

class AccountViewController: UIViewController {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // temporary account, will pull from firebase later
    static var account = Account(username: "hi_itschloe", password: "asd123", firstname: "Chloe", lastname: "Nguyen")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "\(AccountViewController.account.firstname!) \(AccountViewController.account.lastname!)"
        usernameLabel.text = "@\(AccountViewController.account.username)"
        
        
    }
    
    
    
}
