//
//  LogInViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 27/4/2022.
//

import UIKit

class LogInViewController: UIViewController, DatabaseListener {

    // UI ELEMENTS !!!!!!!!!!!!!!!
    
    @IBOutlet weak var appLogo: UIView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
//    var allAccounts = ["user1": "abc", "user2" : "asd", "user3" : "qwe"]
    var accounts: [Account] = []
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .account
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        var username: String!
        var password: String!
        
        
//        username = usernameTF.text
//        password = passwordTF.text
        
//        guard let _ = username, let _ = password else {
//            return
//        }
//
//        for (un, pw) in allAccounts {
//            if (username, password) == (un, pw) {
//                print("valid")
//                break
//            } else {
//                print("invalid")
//            }
//        }
        
        
//        guard let username = usernameTF.text, let password = passwordTF.text else {
//            return
//        }
//        if username.isEmpty || password.isEmpty {
//            displayMessage(title: "Invalid", message: "Username/password cannot be empty.")
//            return
//        }
//        else {
//            displayMessage(title: "Invalid", message: "Invalid email")
//        }
    
        guard let username = usernameTF.text, let password = passwordTF.text else {
            return
        }
        var flag = false
        for i in accounts {
            if username == i.username && password == i.password {
                flag = true
            }
        }
        
        if username.isEmpty || password.isEmpty {
            displayMessage(title: "Invalid", message: "Username/password cannot be empty.")
            return
        }
        if flag {
//            performSegue(withIdentifier: "logInSegue", sender: sender)
            displayMessage(title: "Message", message: "Logged in successfully")
        }
        else {
            displayMessage(title: "Message", message: "Incorrect username/password")
        }
        
    }
    
    func onAccountChange(change: DatabaseChange, accounts: [Account]) {
        self.accounts = accounts
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
