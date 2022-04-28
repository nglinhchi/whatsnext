//
//  SignUpViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 28/4/2022.
//

import UIKit

class SignUpViewController: UIViewController {

    weak var accountsDelegate: LoadAccountsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var retypeTF: UITextField!
    
    
    @IBAction func signupButton(_ sender: Any) {
        guard let username = usernameTF.text, let password = passwordTF.text,
              let firstname = firstnameTF.text, let lastname = lastnameTF.text,
              let retype = retypeTF.text else {
            return
        }
        if username.isEmpty || password.isEmpty || firstname.isEmpty || lastname.isEmpty || retype.isEmpty {
            displayMessage(title: "Invalid", message: "Please fill in all fields.")
            return
        }
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
