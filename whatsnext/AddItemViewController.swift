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
    @IBOutlet weak var startTF: UITextField!
    @IBOutlet weak var endTF: UITextField!
    @IBOutlet weak var durationTF: UITextField!
    
    @IBOutlet weak var notesTF: UITextField!
    // missing subtask stack
    
    // BUTTONS *********************************************************
    @IBAction func addSubtaskBTN(_ sender: Any) {
    }
    
    @IBAction func saveBTN(_ sender: Any) {
        if let name = taskTF.text, !name.isEmpty {
            let category =
            categorySegment.titleForSegment(at: categorySegment.selectedSegmentIndex) ?? ""
            completion?(name, category)
        }
    }
    
    
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func timeSegmentControl(_ sender: Any) {
        
        
       // print(timeSegment.titleForSegment(at: timeSegment.selectedSegmentIndex) ?? "")
        
        
        switch timeSegment.selectedSegmentIndex {
        case 1:
            print("1")
            timeTF.isHidden = false
            startTF.isHidden = true
            endTF.isHidden = true
            durationTF.isHidden = true
        case 2:
            print("2")
            timeTF.isHidden = true
            startTF.isHidden = false
            endTF.isHidden = false
            durationTF.isHidden = true
        case 3:
            print("3")
            timeTF.isHidden = true
            startTF.isHidden = true
            endTF.isHidden = true
            durationTF.isHidden = false
        default:
            timeTF.isHidden = true
            startTF.isHidden = true
            endTF.isHidden = true
            durationTF.isHidden = true
        }
        
    }
    
    
    
    // METHODS *********************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        timeTF.isHidden = true
        startTF.isHidden = true
        endTF.isHidden = true
        durationTF.isHidden = true
    }
    
    
    


}
