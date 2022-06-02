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
    
    
    // VARIABLES
    var accounts: [Account] = []
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .account
    
    
    @IBAction func loginButton(_ sender: Any) {
    
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
            displayMessage(title: "Huhhhh", message: "Username/password cannot be empty.")
            return
        }
        if flag {
//            performSegue(withIdentifier: "logInSegue", sender: sender)
            displayMessage(title: "Ah yessss", message: "Logged in successfully")
        }
        else {
            displayMessage(title: "Oh nooooo", message: "Incorrect username/password")
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
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signupSegue" {
            let destination = segue.destination as! SignUpViewController
            destination.accounts = accounts
            destination.databaseController = databaseController
            }
    }
    
}
