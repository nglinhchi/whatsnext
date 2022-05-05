//
//  EditJournalViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 5/5/2022.
//

import UIKit

class EditJournalViewController: UIViewController {

    
    // VARIABLES + CONSTANTS *******************************************
    public var completion: ((String) -> Void)?
    
    
    
    @IBOutlet weak var journalTF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveBTN(_ sender: Any) {
        if let journal = journalTF.text, !journal.isEmpty {
            completion?(journal)
        }
        
    }
    
    
}
