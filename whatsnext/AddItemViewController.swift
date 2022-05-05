//
//  AddItemViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 4/5/2022.
//

import UIKit

class AddItemViewController: UIViewController {

    
    // VARIABLES + CONSTANTS *******************************************
    public var completion: ((String, String) -> Void)?
    
    
    // UI ELEMENTS *****************************************************
    @IBOutlet weak var taskTF: UITextField!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeSegment: UISegmentedControl!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var notesTF: UITextField!
    @IBOutlet weak var subtask1TF: UITextField!

    
    // BUTTONS *********************************************************
    @IBAction func addSubtaskBTN(_ sender: Any) {
    }
    
    @IBAction func saveBTN(_ sender: Any) {
        if let name = taskTF.text, !name.isEmpty {
            let category: String
            switch categorySegment.selectedSegmentIndex
               {
               case 0:
                   category = "home"
               case 1:
                   category = "uni"
               case 2:
                   category = "work"
                default:
                    category = "home"
               }
            completion?(name, category)
        }
    }
    
    
    @IBAction func discardBTN(_ sender: Any) {
    }
    
    
    // METHODS *********************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
