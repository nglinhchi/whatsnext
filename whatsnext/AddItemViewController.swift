//
//  AddItemViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 4/5/2022.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {

    
    // VARIABLES + CONSTANTS *******************************************
    public var completion: ((Item) -> Void)?
    
    static var timeFormatter = DateFormatter()
    static var timeField = ""
    
    var item: Item?
    
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
    
    // subtask TO ADD
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var subtaskTF: UITextField!
    
    var subtasks = [Subtask]()
    
    
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
        
        table.delegate = self
        table.dataSource = self
        
        timePicker.locale = Locale(identifier: "en_US")
        
        AddItemViewController.timeFormatter.locale = Locale(identifier: "en_US")
        AddItemViewController.timeFormatter.dateFormat = "hh:mm a"
        
        
        // FOR EDIT TASK
        if let item = item {
            taskTF.text = item.name
            let cat_index: Int
            switch item.category {
            case "home":
                cat_index = 0
            case "uni":
                cat_index = 1
            case "work":
                cat_index = 2
            default:
                cat_index = 0
            }
            categorySegment.selectedSegmentIndex = cat_index
            datePicker.date = item.day
            let time_index: Int
            switch item.time.type {
            case "-":
                time_index = 0
            case "exact":
                time_index = 1
                clickExact(self)
                timePicker.date = item.time.exact
                self.changeTimePicker(self)
            case "start-end":
                time_index = 2
                clickStart(self)
                timePicker.date = item.time.interval.start
                self.changeTimePicker(self)
                clickEnd(self)
                timePicker.date = item.time.interval.end
                self.changeTimePicker(self)
            case "duration":
                time_index = 3
                durationTF.text = item.time.duration
            default:
                time_index = 0
            }
            timeSegment.selectedSegmentIndex = time_index
            self.timeSegmentControl(self)
            notesTF.text = item.notes
            self.subtasks = item.subtasks
        }
        
        
        taskTF.delegate = self
        notesTF.delegate = self
        subtaskTF.delegate = self
        
        taskTF.becomeFirstResponder()
        
    }
    
    
    
    
    // BUTTONS *********************************************************
    
    // SAVE BUTTON
    @IBAction func saveBTN(_ sender: Any) {
        
        
        /* acceptance criteria
         * name filled
         * exact: exact filled
         * start-end: start filled, end filled, start < end
         * duration: duration filled
        */
        
        // AC task name filled
        guard let name = taskTF.text, !name.isEmpty else {
            displayMessage(title: "Invalid Task", message: "Please fill in the name.")
            return
        }
        
        let timeIndex = timeSegment.selectedSegmentIndex
        let timeType = timeSegment.titleForSegment(at: timeIndex)!
        let time: Time
        
        let fullFormatter = DateFormatter()
        fullFormatter.locale = Locale(identifier: "en_US")
        fullFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        
        switch timeIndex {
        
        case 1:
            // AC exact time filled
            guard let stringTime = exactTF.text, !stringTime.isEmpty else {
                displayMessage(title: "Invalid Task", message: "Please fill in the time.")
                return
            }
            let stringExact = "\(date) \(stringTime)"
            let exact = fullFormatter.date(from: stringExact)!
            time = Time(type: timeType, exact: exact)
            
        case 2:
            // AC start filled, end filled, start > end
            guard let stringTimeStart = startTF.text, !stringTimeStart.isEmpty,
                  let stringTimeEnd = endTF.text, !stringTimeEnd.isEmpty else {
                displayMessage(title: "Invalid Task", message: "Please fill in all time intervals.")
                return
            }
            let stringStart = "\(date) \(stringTimeStart)"
            let start = fullFormatter.date(from: stringStart)!
            let stringEnd = "\(date) \(stringTimeEnd)"
            let end = fullFormatter.date(from: stringEnd)!
            guard start < end else {
                displayMessage(title: "Invalid Task", message: "End time cannot be earlier than start time.")
                return
            }
            time = Time(type: timeType, interval: DateInterval(start: start, end: end))
            
        case 3:
            // AC duration filled
            guard let duration = durationTF.text, !duration.isEmpty else {
                displayMessage(title: "Invalid Task", message: "Please fill in the duration.")
                return
            }
            time = Time(type: timeType, duration: duration)
        default:
            time = Time(type: timeType)
        }
        
        let category = categorySegment.titleForSegment(at: categorySegment.selectedSegmentIndex) ?? ""
        let day = datePicker.date
        let notes = notesTF.text ?? ""
        let item = Item(name: name, category: category,
                        day: day, time: time,
                        notes: notes, subtasks: self.subtasks,
                        completed: false)
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
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == subtaskTF {
                addSubtaskBTN(self)
            } else {
                self.view.endEditing(true)
            }
            return false
        }
    
    // done time
    
    // with animation
    /*
     UIView.transition(with: button, duration: 0.4,
                       options: .transitionCrossDissolve,
                       animations: {
                      button.hidden = false
                   })
     */
    
    
    @IBAction func doneExact(_ sender: Any) {
        timePicker.isHidden = true
    }
    
    
    @IBAction func doneStart(_ sender: Any) {
        timePicker.isHidden = true
    }
    
    
    @IBAction func doneEnd(_ sender: Any) {
        timePicker.isHidden = true
    }
    
    
    @IBAction func doneDuration(_ sender: Any) {
        timePicker.isHidden = true
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
        guard let subtask = subtaskTF.text, !subtask.isEmpty else {
            return
        }
        print("addeddddd")
        subtasks.append(Subtask(name: subtask, completed: false))
        subtaskTF.text = ""
        self.table.reloadData()
    }
    
    
}






// *********************************************************************************************


extension AddItemViewController: UITableViewDelegate {
    
    // SELECT A TASK --> SEE ITS DETAILS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension AddItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtasks.count
    }
    
    // LOAD DATA INTO THE ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubtaskTableViewCell

        // put the strings from subtasks t subtask table
        cell.subtaskLabel.text = subtasks[indexPath.row].name
        
        return cell
    }

}


// *********************************************************************************************



class SubtaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subtaskLabel: UILabel!
    
}
