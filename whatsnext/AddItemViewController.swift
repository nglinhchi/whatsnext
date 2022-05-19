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
    
    static var timeFormatter = DateFormatter()
    static var durationFormatter = DateFormatter()
    static var hourFormatter = DateFormatter()
    static var minuteFormatter = DateFormatter()
    static var timeField = ""
    
    
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
    
    // time picker
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    
    
    // METHODS *********************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exactTF.isHidden = true
        startTF.isHidden = true
        endTF.isHidden = true
        durationTF.isHidden = true
        timePicker.isHidden = true
        
        
        AddItemViewController.hourFormatter.dateFormat = "h"
        AddItemViewController.minuteFormatter.dateFormat = "m"
        
        AddItemViewController.timeFormatter.locale = Locale(identifier: "en_US")
        AddItemViewController.timeFormatter.dateFormat = "hh:mm a"
        
        AddItemViewController.durationFormatter.locale = Locale(identifier: "en_US")
        AddItemViewController.durationFormatter.dateFormat = "hh hours mm minutes"
    }
    
    
    
    
    
    
    // BUTTONS *********************************************************
    
    // SAVE BUTTON
    @IBAction func saveBTN(_ sender: Any) {
        guard let name = taskTF.text, !name.isEmpty else {
            displayMessage(title: "Invalid Task", message: "Please fill in the name.")
            return // display message
        }
        let timeIndex = timeSegment.selectedSegmentIndex
        let tType = timeSegment.titleForSegment(at: timeIndex)!
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
    
        let time: Time
        switch timeIndex {
        case 1:
            // exact
            guard let exact = timeFormatter.date(from: exactTF.text!) else {
                let e = timeFormatter.date(from: exactTF.text!)
                print(e)
                displayMessage(title: "Invalid Task", message: "Please fill in the time.")
                return
            }
            time = Time(type: tType, exact: exact)
        case 2:
            // start-end
            guard let start = timeFormatter.date(from: startTF.text!),
                  let end = timeFormatter.date(from: endTF.text!) else {
                displayMessage(title: "Invalid Task", message: "Please fill in all time intervals.")
                return
            }
            time = Time(type: tType, interval: DateInterval(start: start, end: end))
        case 3:
            // duration
            guard let duration = timeFormatter.date(from: durationTF.text!) else {
                displayMessage(title: "Invalid Task", message: "Please fill in the duration.")
                return
            }
            time = Time(type: tType, duration: duration)
        default:
            time = Time(type: tType)
        }
        
        let category = categorySegment.titleForSegment(at: categorySegment.selectedSegmentIndex) ?? ""
        let day = datePicker.date
        let notes = notesTF.text ?? ""
        let subtasks = [String]()
        let item = Item(name: name, category: category, day: day, time: time, notes: notes, subtasks: subtasks, completed: false)
        completion?(item)
    }
    
    
    // DISCARD BUTTON
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // TIME SEGMENT - SHOW WHAT TEXT FIELDS
    @IBAction func timeSegmentControl(_ sender: Any) {
        timePicker.isHidden     = true
        exactTF.isHidden        = true
        startTF.isHidden        = true
        endTF.isHidden          = true
        durationTF.isHidden     = true
        switch timeSegment.selectedSegmentIndex {
        case 1:
            exactTF.isHidden = false
        case 2:
            startTF.isHidden = false
            endTF.isHidden = false
        case 3:
            durationTF.isHidden = false
        default:
            return
        }
    }
    
    
    // might put repetitive code into 1 single methods, connect all text fields to it
    
    @IBAction func clickExact(_ sender: Any) {
        timePicker.datePickerMode = .time
        timePicker.isHidden = false
        AddItemViewController.timeField = "exact"
    }

    
    @IBAction func clickStart(_ sender: Any) {
        timePicker.datePickerMode = .time
        timePicker.isHidden = false
        AddItemViewController.timeField = "start"
    }
    
    
    @IBAction func clickEnd(_ sender: Any) {
        timePicker.datePickerMode = .time
        timePicker.isHidden = false
        AddItemViewController.timeField = "end"
    }
    
   
    @IBAction func clickDuration(_ sender: Any) {
        timePicker.datePickerMode = .countDownTimer
        timePicker.isHidden = false
        AddItemViewController.timeField = "duration"
    }
    
    
    @IBAction func changeTimePicker(_ sender: Any) {
        
        // check all types not just start end anymore, esp duration!!!!!
        
        let time = AddItemViewController.timeFormatter.string(from: timePicker.date)
        
        let hour = Calendar.current.component(.hour, from: timePicker.date)
        let minute = Calendar.current.component(.minute, from: timePicker.date)
        let hours = hour>0 ? "\(hour)hr" : ""
        let minutes = minute>0 ? "\(minute)min" : ""
        let duration = "\(hours) \(minutes)"
        
        switch AddItemViewController.timeField {
        case "exact":
            exactTF.text = time
        case "start":
            startTF.text = time
        case "end":
            endTF.text = time
        case "duration":
            durationTF.text = duration
        default:
            return
        }
    }
    
    
    // SUBTASK
    @IBAction func addSubtaskBTN(_ sender: Any) {
        // this is too hard, might just do so in view details screen
    }
    
    
}
