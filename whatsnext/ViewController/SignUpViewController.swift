//
//  SignUpViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 28/4/2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    // VARIABLES -------------------------------------------------------------------------------------
    var currentUser: FirebaseAuth.User?
    var authHandle: AuthStateDidChangeListenerHandle?
    
    // UTILS -----------------------------------------------------------------------------------------
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var databaseController: FirebaseProtocol?
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypeTextField: UITextField!
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseController = appDelegate?.databaseFirebase
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authHandle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            guard user != nil else { return }
            self.performSegue(withIdentifier: "signedupSegue", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let authHandle = authHandle else { return }
        Auth.auth().removeStateDidChangeListener(authHandle)
    }
    
    // AUTHENTICATION ---------------------------------------------------------------------------------------
    @IBAction func signupButton(_ sender: Any) {
        // CHECK all fields filled
        guard let email = emailTextField.text, let password = passwordTextField.text,
              let firstname = firstnameTextField.text, let lastname = lastnameTextField.text,
              let retype = retypeTextField.text else {
            displayMessage(title: "Error", message: "Please fill in all fields")
            return
        }
        // CHECK all fields filled
        if email.isEmpty || password.isEmpty || firstname.isEmpty || lastname.isEmpty || retype.isEmpty {
            displayMessage(title: "Invalid", message: "Please fill in all fields.")
            return
        }
        // CHECK password length
        guard password.count >= 8 else {
            displayMessage(title: "Error", message: "Password must be at least 8 characters")
            return
        }
        // CHECK password retype matched
        if password != retype {
            displayMessage(title: "Error", message: "Password doesn't match, please try again")
            return
        }
        // CREATE new account
        Task{
            do{
                let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                currentUser = authDataResult.user
            }
            catch {
                print(error)
            }
        }
//        self.displayMessage(title: "Successful!", message: "Congrations, your account has been successfully created.")
        // databaseController?.addAccount(username: username, password: password, firstname: firstname, lastname: lastname)
    }


}
