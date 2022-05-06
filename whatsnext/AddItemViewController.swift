//
//  AddItemViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 4/5/2022.
//

import UIKit

class AddItemViewController: UIViewController {

    
    // VARIABLES + CONSTANTS *******************************************
    public var completion: ((String, String, Time) -> Void)?
    
    
    // UI ELEMENTS *****************************************************
    // task name
    @IBOutlet weak var taskTF: UITextField!
    // category
    @IBOutlet weak var categorySegment: UISegmentedControl!
    // date
    @IBOutlet weak var dateTF: UITextField!
    // time
    @IBOutlet weak var timeSegment: UISegmentedControl!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var startTF: UITextField!
    @IBOutlet weak var endTF: UITextField!
    @IBOutlet weak var durationTF: UITextField!
    // notes
    @IBOutlet weak var notesTF: UITextField!
    // subtask
    @IBOutlet weak var subtaskStack: UIStackView!
    @IBOutlet weak var subtask1TF: UITextField!
    
    // BUTTONS *********************************************************
    
    
    
    @IBAction func saveBTN(_ sender: Any) {
        if let name = taskTF.text, !name.isEmpty {
            let category =
            categorySegment.titleForSegment(at: categorySegment.selectedSegmentIndex) ?? ""
            let timeType = timeSegment.titleForSegment(at: timeSegment.selectedSegmentIndex) ?? ""
            var time = Time(type: timeType, time: "", start: "", end: "", duration: "")
            switch timeSegment.selectedSegmentIndex {
            case 1:
                guard let t = timeTF.text, !t.isEmpty else {
                    return
                }
                time = Time(type: timeType, time: t, start: "", end: "", duration: "")
            case 2:
                guard let s = startTF.text, !s.isEmpty,
                      let e = endTF.text, !e.isEmpty else {
                    return
                }
                time = Time(type: timeType, time: "", start: s, end: e, duration: "")
            case 3:
                guard let d = durationTF.text, !d.isEmpty else {
                    return
                }
                time = Time(type: timeType, time: "", start: "", end: "", duration: d)
            default:
                return
            }
            
            
            completion?(name, category, time)
        }
    }
    
    
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func timeSegmentControl(_ sender: Any) {
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
    
    
    
    @IBAction func addSubtaskBTN(_ sender: Any) {
        // this is too hard, might just do so in view details screen
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
