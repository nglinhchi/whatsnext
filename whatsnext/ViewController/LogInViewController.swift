//
//  LogInViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 27/4/2022.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    // VARIABLES -------------------------------------------------------------------------------------
    var authHandle: AuthStateDidChangeListenerHandle?
    var currentUser: User?
    static var firebaseRandom: [FBRandom] = []
    static var firebaseThing: [FBThing] = []
    static var firebaseJournal: [FBJournal] = []
    static var firebaseTime: [FBTime] = []
    static var firebaseSubClass: [FBSubClass] = []
    
    // UTILS -----------------------------------------------------------------------------------------
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var databaseController: FirebaseProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseFirebase
        self.tabBarController?.tabBar.isHidden = true
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        authHandle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            guard user != nil else { return }
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
    
    @IBAction func loginButton(_ sender: Any) {
    
        // CHECK password filled
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayMessage(title: "Error", message: "Please enter a password")
            return
        }
        
        // CHECK email filled
        guard let email = emailTextField.text, !email.isEmpty else {
            displayMessage(title: "Error", message: "Please enter an email")
            return
        }
        
        // CHECK authentication
        let authDataResult = Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            guard error == nil else {
                // error message
                self.displayMessage(title: "Error", message: "Wrong email/password combination, please try again")
                return
            }
        })
        
    }
    
}
