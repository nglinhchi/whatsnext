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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var databaseController: FirebaseProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // VARIABLES
    var authHandle: AuthStateDidChangeListenerHandle?
    var currentUser: User?
    
    
    // FIREBASE
    static var firebaseRandom: [FBRandom] = []
    static var firebaseThing: [FBThing] = []
    static var firebaseDiary: [FBJournal] = []
    static var firebaseTime: [FBTime] = []
    static var firebaseSubClass: [FBSubClass] = []
    
    
    @IBAction func loginButton(_ sender: Any) {
    
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayMessage(title: "Error", message: "Please enter a password")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
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

//        loadEverything()
        
    }
    
//    func onAccountChange(change: DatabaseChange, accounts: [Account]) {
//        self.accounts = accounts
//    }
    
    
//    func loadEverything() {
//        databaseController = appDelegate?.databaseFirebase
//        databaseController?.getAllRandom()
//        for each in LogInViewController.firebaseRandom {
//            let id = each.id
//            let name = each.name
//            let completed = each.completed
//
//
//            let coreRandom = Random(context: context)
//            coreRandom.id = id
//            coreRandom.name = name!
//            coreRandom.completed = completed!
//        }
//        do { try context.save() }
//        catch { print(error) }
//
//
//    }
    
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "signupSegue" {
//            let destination = segue.destination as! SignUpViewController
////            destination.accounts = accounts
////            destination.databaseController = databaseController
//            }
//    }
    
}
