//
//  LogInViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 27/4/2022.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    
    // UI ELEMENTS !!!!!!!!!!!!!!!
//    @IBOutlet weak var appLogo: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    weak var databaseController: FirebaseProtocol?
    
    // VARIABLES
//    var accounts: [Account] = []
//    weak var databaseController: DatabaseProtocol?
//    var listenerType: ListenerType = .account
    var authHandle: AuthStateDidChangeListenerHandle?
    var currentUser: User?
    
    
    @IBAction func loginButton(_ sender: Any) {
    
        guard let password = passwordTF.text, !password.isEmpty else {
            displayMessage(title: "Error", message: "Please enter a password")
            return
        }
        
        guard let email = emailTF.text, !email.isEmpty else {
            displayMessage(title: "Error", message: "Please enter an email")
            return
        }
        
        
        let authDataResult = Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            guard error == nil else {
                // error message
                self.displayMessage(title: "Error", message: "Wrong email/password combination, please try again")
                return
            }

        })
        

        
        
//        Task{
//            do{
//                let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
//                currentUser = authDataResult.user
//                self.performSegue(withIdentifier: "loginSegue", sender: Any?.self)
//            }
//            catch {
////            displayMessage(title: "Error", message: "Firebase Authentication Failed with Error:\(String(describing: error))")
//            }
//        }
    }
    
//    func onAccountChange(change: DatabaseChange, accounts: [Account]) {
//        self.accounts = accounts
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseFirebase
        self.tabBarController?.tabBar.isHidden = true
        emailTF.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        databaseController?.addListener(listener: self)
        authHandle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            guard user != nil else { return }
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        databaseController?.removeListener(listener: self)
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signupSegue" {
            let destination = segue.destination as! SignUpViewController
//            destination.accounts = accounts
//            destination.databaseController = databaseController
            }
    }
    
}
