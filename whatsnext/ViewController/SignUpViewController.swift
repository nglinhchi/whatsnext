//
//  SignUpViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 28/4/2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, DatabaseListener {

    // VARIABLES -------------------------------------------------------------------------------------
    var currentUser: FirebaseAuth.User?
    var authHandle: AuthStateDidChangeListenerHandle?
    var userRandom = [FBRandom()]
    var listenerType: ListenerType = .all
    
    // UTILS -----------------------------------------------------------------------------------------
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var databaseController: FirebaseProtocol?
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var retypeTF: UITextField!
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseController = appDelegate?.databaseFirebase
    }
    
    // AUTHENTICATION ---------------------------------------------------------------------------------------
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
//                loadFirebaseIntoCoredata()
            }
            catch {
//                displayMessage(title: "Error", message: "Firebase Authentication Failed with Error:\(String(describing: error))")
            }
        }
//        databaseController?.addAccount(username: username, password: password, firstname: firstname, lastname: lastname)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        databaseController?.addListener(listener: self)
        authHandle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            guard user != nil else { return }
            self.databaseController?.addListener(listener: self)
            self.performSegue(withIdentifier: "signedupSegue", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        databaseController?.removeListener(listener: self)
        guard let authHandle = authHandle else { return }
        databaseController?.removeListener(listener: self)
        Auth.auth().removeStateDidChangeListener(authHandle)
    }

    // LOAD DATA INTO CORE DATA ----------------------------------------------------------------------------------
    
    func loadFirebaseIntoCoredata() { // curent doesn't work
        for each in userRandom {
            let random = Random(context: context)
            random.name = each.name!
            random.completed = each.completed!
            // waht about id? --> all doesn't work
        }
        do { try context.save() }
        catch { print("cant save because \(error)") }
    }
    
    
    func onThingChange(change: DatabaseChange, things: [FBThing]) {
//
    }
    
    func onTimeChange(change: DatabaseChange, times: [FBTime]) {
//
    }
    
    func onSubClassChange(change: DatabaseChange, subClasses: [FBSubClass]) {
//
    }
    func onJournalChange(change: DatabaseChange, journals: [FBJournal]) {
//
    }
    
    func onRandomChange(change: DatabaseChange, randoms: [FBRandom]) {
        print(randoms)
        for random in randoms{
            if random.userID == Auth.auth().currentUser?.uid{
                userRandom.append(random)
                print(random.id)
                print(random.userID)
                print(random.name)
                print(random.completed)
            }
        }
    }

}
