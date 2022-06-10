//
//  SignUpViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 28/4/2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    var authHandle: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?
    
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var retypeTF: UITextField!
    
    
    @IBAction func signupButton(_ sender: Any) {
        
        guard let email = emailTF.text, let password = passwordTF.text,
              let firstname = firstnameTF.text, let lastname = lastnameTF.text,
              let retype = retypeTF.text else {
            displayMessage(title: "Error", message: "Please fill in all fields")
            return
        }
        
        if email.isEmpty || password.isEmpty || firstname.isEmpty || lastname.isEmpty || retype.isEmpty {
            displayMessage(title: "Invalid", message: "Please fill in all fields.")
            return
        }
        
        guard password.count > 8 else {
            displayMessage(title: "Error", message: "Password must be at least 8 characters")
            return
        }

        if password != retype {
            displayMessage(title: "Error", message: "Password doesn't match, please try again")
            return
        }
        
        Task{
            do{
                let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                currentUser = authDataResult.user
            }
            catch {
//                displayMessage(title: "Error", message: "Firebase Authentication Failed with Error:\(String(describing: error))")
            }
        }
//        databaseController?.addAccount(username: username, password: password, firstname: firstname, lastname: lastname)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        databaseController?.addListener(listener: self)
        authHandle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            guard user != nil else { return }
            self.performSegue(withIdentifier: "signedupSegue", sender: nil)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        databaseController?.removeListener(listener: self)
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
    }

}
