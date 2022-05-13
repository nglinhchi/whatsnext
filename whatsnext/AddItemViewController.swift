//
//  AddItemViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 4/5/2022.
//

import UIKit

class AddItemViewController: UIViewController {

    
    // VARIABLES + CONSTANTS *******************************************
    public var completion: ((Item) -> Void)?
    
    
    // UI ELEMENTS *****************************************************
    // task name
    @IBOutlet weak var taskTF: UITextField!
    // category
    @IBOutlet weak var categorySegment: UISegmentedControl!
    // date
    @IBOutlet weak var datePicker: UIDatePicker!
    // time
    @IBOutlet weak var timeSegment: UISegmentedControl!
    @IBOutlet weak var exactTF: UITextField!
    @IBOutlet weak var startTF: UITextField!
    @IBOutlet weak var endTF: UITextField!
    @IBOutlet weak var durationTF: UITextField!
    // notes
    @IBOutlet weak var notesTF: UITextField!
    // subtask
    @IBOutlet weak var subtaskStack: UIStackView!
    @IBOutlet weak var subtask1TF: UITextField!
    
    var timePicker = UIDatePicker()
    
    // BUTTONS *********************************************************
    
    
    // TIME AND SUBTASK TODO
    @IBAction func saveBTN(_ sender: Any) {
        guard let name = taskTF.text, !name.isEmpty else {
            return // display message
        }
        let category = categorySegment.titleForSegment(at: categorySegment.selectedSegmentIndex) ?? ""
        let day = datePicker.date
        
        
        
        let time = Time(type: "-", exact: Date(), interval: DateInterval(), duration: Date())
        
        
        
        let notes = notesTF.text ?? ""
        let subtasks = [String]()
        let item = Item(name: name, category: category, day: day, time: time, notes: notes, subtasks: subtasks, completed: false)
        completion?(item)
    }
    
    
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func timeSegmentControl(_ sender: Any) {
        switch timeSegment.selectedSegmentIndex {
        case 1:
            print("1")
            exactTF.isHidden = false
            startTF.isHidden = true
            endTF.isHidden = true
            durationTF.isHidden = true
        case 2:
            print("2")
            exactTF.isHidden = true
            startTF.isHidden = false
            endTF.isHidden = false
            durationTF.isHidden = true
        case 3:
            print("3")
            exactTF.isHidden = true
            startTF.isHidden = true
            endTF.isHidden = true
            durationTF.isHidden = false
        default:
            exactTF.isHidden = true
            startTF.isHidden = true
            endTF.isHidden = true
            durationTF.isHidden = true
        }
    }
    
    
    
    @IBAction func addSubtaskBTN(_ sender: Any) {
        // this is too hard, might just do so in view details screen
    }
    
    
    
    func createDatePicker(TF: UITextField) {
        
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = Locale(identifier: "en_US")
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBTN: UIBarButtonItem
        switch TF {
        case exactTF:
            doneBTN = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneExact))
        case startTF:
            doneBTN = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneStart))
        case endTF:
            doneBTN = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneEnd))
        case durationTF:
            doneBTN = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDuration))
            timePicker.datePickerMode = .countDownTimer
        default:
            return
        }
        let spaceBTN = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelBTN = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        
        toolbar.setItems([cancelBTN, spaceBTN, doneBTN], animated: true  )
        TF.inputAccessoryView = toolbar
        TF.inputView = timePicker
        
        
    }
    
    @objc func doneExact() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        exactTF.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    
    @objc func doneStart() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        startTF.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    
    @objc func doneEnd() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        endTF.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    
    @objc func doneDuration() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh hrs mm mins"
        dateFormatter.locale = Locale(identifier: "en_US")
        durationTF.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    
    @objc func cancelPressed() {
        self.view.endEditing(true)
    }
    
    
    // METHODS *********************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        exactTF.isHidden = true
        startTF.isHidden = true
        endTF.isHidden = true
        durationTF.isHidden = true
        createDatePicker(TF: exactTF)
        createDatePicker(TF: startTF)
        createDatePicker(TF: endTF)
        createDatePicker(TF: durationTF)
    }
    
    
    


}
