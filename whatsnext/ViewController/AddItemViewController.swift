//
//  AddItemViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 4/5/2022.
//

import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseStorage
import UserNotifications

class AddItemViewController: UIViewController, UITextFieldDelegate {

    
    // VARIABLES -------------------------------------------------------------------------------------
    var item: Thing?
    var subtasks = [String]()
    var subtaskOldCount: Int = 0
    let notificationCenter = UNUserNotificationCenter.current()
    // UTILS -----------------------------------------------------------------------------------------
    static var timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    static var timeField = ""
    public var completion: ((String) -> Void)?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var databaseController: FirebaseProtocol?
//    var listenerType: ListenerType = .thing // not sure?????
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeSegment: UISegmentedControl!
    @IBOutlet weak var exactTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        
        super.viewDidLoad()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
                    (permissionGranted, error) in
                    if(!permissionGranted)
                    {
                        print("Permission Denied")
                    }
                }
        databaseController = appDelegate?.databaseFirebase
        
        exactTextField.isHidden = true
        startTextField.isHidden = true
        endTextField.isHidden = true
        durationTextField.isHidden = true
        timePicker.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        AddItemViewController.timeFormatter.locale = Locale(identifier: "en_US")
        AddItemViewController.timeFormatter.dateFormat = "hh:mm a"
        
        // FOR EDIT TASK - prefill detail
        if let item = item {
            taskTextField.text = item.name
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
                timePicker.date = item.time.exact!
                self.changeTimePicker(self)
            case "start-end":
                time_index = 2
                clickStart(self)
                timePicker.date = item.time.start!
                self.changeTimePicker(self)
                clickEnd(self)
                timePicker.date = item.time.end!
                self.changeTimePicker(self)
            case "duration":
                time_index = 3
                durationTextField.text = item.time.duration
            default:
                time_index = 0
            }
            timeSegment.selectedSegmentIndex = time_index
            self.timeSegmentControl(self)
            notesTextField.text = item.notes
            
            do {
                let request = Subtask.fetchRequest() as NSFetchRequest<Subtask>
                let pred = NSPredicate(format: "%K == %@", "thingID", item.id! as CVarArg)
                request.predicate = pred
                let s = try context.fetch(request)
                for subtask in s {
                    subtasks.append(subtask.name)
                }
                subtaskOldCount = subtasks.count
                tableView.reloadData()
            }
            catch { print(error) }
            
        }
        
        taskTextField.delegate = self
        notesTextField.delegate = self
        subtaskTextField.delegate = self
        taskTextField.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // ADD/UPDATE THING -----------------------------------------------------------------------------
    @IBAction func saveBTN(_ sender: Any) {
        
        /* acceptance criteria
         * name filled
         * exact: exact filled
         * start-end: start filled, end filled, start < end
         * duration: duration filled
        */
        
        // AC task name filled
        guard let name = taskTextField.text, !name.isEmpty else {
            displayMessage(title: "Invalid Task", message: "Please fill in the name.")
            return
        }
        
        let timeIndex = timeSegment.selectedSegmentIndex
        let timeType = timeSegment.titleForSegment(at: timeIndex)!
        
        let time = Time(context: self.context)
        
        let fullFormatter = DateFormatter()
        fullFormatter.locale = Locale(identifier: "en_US")
        fullFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        
        var fbDuration = ""
        var fbStart = ""
        var fbEnd = ""
        var fbExact = ""
        
        switch timeIndex {
        case 1:
            // AC exact time filled
            guard let stringTime = exactTextField.text, !stringTime.isEmpty else {
                displayMessage(title: "Invalid Task", message: "Please fill in the time.")
                return
            }
            let stringExact = "\(date) \(stringTime)"
            let exact = fullFormatter.date(from: stringExact)!
            time.type = timeType
            time.exact = exact
            fbExact = stringExact
        case 2:
            // AC start filled, end filled, start > end
            guard let stringTimeStart = startTextField.text, !stringTimeStart.isEmpty,
                  let stringTimeEnd = endTextField.text, !stringTimeEnd.isEmpty else {
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
            time.type = timeType
            time.start = start
            time.end = end
            fbStart = stringStart
            fbEnd = stringEnd
        case 3:
            // AC duration filled
            guard let duration = durationTextField.text, !duration.isEmpty else {
                displayMessage(title: "Invalid Task", message: "Please fill in the duration.")
                return
            }
            time.type = timeType
            time.duration = duration
            fbDuration = time.duration!
        default:
            time.type = timeType
        }
        
        let category = categorySegment.titleForSegment(at: categorySegment.selectedSegmentIndex) ?? ""
        let day = datePicker.date
        let notes = notesTextField.text ?? ""
        
        
        // UPDATE OR CREATE NEW ITEM
        
        if item == nil {
            print("nil - create thing")
            item = Thing(context: context) // coredata add thing
            item!.completed = false
            print("before add item")
            item!.id = (databaseController?.addThing(category: category, completed: false, date: dateFormatter.string(from: day), name: name, note: notes).id)! // firebase add thing
            time.id = databaseController?.addTime(
                duaration: fbDuration,
                end: fbEnd,
                exact: fbExact,
                start: fbStart,
                type: time.type,
                thingID: item!.id!).id // firebase add time
            print("after add item")
            for subtask in subtasks {
                let coreSubtask = Subtask(context: context)
                coreSubtask.thingID = item!.id
                coreSubtask.name = subtask
                coreSubtask.completed = false
                coreSubtask.id = (databaseController?.addSubClass(completed: coreSubtask.completed, name: coreSubtask.name, thingID: item!.id!).id)! // firebase add subtask
            }
            
            item!.name = name
            item!.category = category
            item!.day = day
            item!.time = time
            item!.notes = notes
            
        } else {
            print("not nil - update thing")
            
            item!.name = name
            item!.category = category
            item!.day = day
            
            item!.time.end = time.end
            item!.time.start = time.start
            item!.time.duration = time.duration
            item!.time.exact = time.exact
            item!.time.type = time.type
            item!.notes = notes
            
            if subtasks.count > subtaskOldCount {
                for i in subtaskOldCount...subtasks.count-1 {
                    let coreSubtask = Subtask(context: context)
                    coreSubtask.thingID = item!.id
                    coreSubtask.name = subtasks[i]
                    coreSubtask.completed = false // coredata add subtask
                    coreSubtask.id = (databaseController?.addSubClass(completed: coreSubtask.completed, name: coreSubtask.name, thingID: item!.id!).id)! // firebase add subtask
                }
            }
            databaseController?.editTime(id: item!.id!, duaration: fbDuration, end: fbEnd, exact: fbExact, start: fbStart, type: time.type) // firebase edit time
            databaseController?.editThing(id: item!.id!, name: name, date: dateFormatter.string(from: day), category: category, notes: notes) // firebase edit thing
        }
        
        do { try self.context.save() }
        catch { print(error) }
        
        // LOCAL NOTIFCATION
        if item?.time.type == "exact" || item?.time.type == "start-end" {
            
            let day: Date
            if item?.time.type == "exact" { day = (item?.time.exact)! }
            else { day = (item?.time.start)! }
                
            notificationCenter.getNotificationSettings { (settings) in
                        
                        DispatchQueue.main.async
                        {
                            let title = "asd"
                            let message = "asd"
                            let date = day
                            
                            if(settings.authorizationStatus == .authorized)
                            {
                                let content = UNMutableNotificationContent()
                                content.title = title
                                content.body = message
                                
                                let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                                
                                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                
                                self.notificationCenter.add(request) { (error) in
                                    if(error != nil)
                                    {
                                        print("Error " + error.debugDescription)
                                        return
                                    }
                                }
                                let ac = UIAlertController(title: "Notification Scheduled", message: "At " + self.formattedDate(date: date), preferredStyle: .alert)
                                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in}))
                                self.present(ac, animated: true)
                            }
                            else
                            {
                                let ac = UIAlertController(title: "Enable Notifications?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                                let goToSettings = UIAlertAction(title: "Settings", style: .default)
                                { (_) in
                                    guard let setttingsURL = URL(string: UIApplication.openSettingsURLString)
                                    else
                                    {
                                        return
                                    }
                                    
                                    if(UIApplication.shared.canOpenURL(setttingsURL))
                                    {
                                        UIApplication.shared.open(setttingsURL) { (_) in}
                                    }
                                }
                                ac.addAction(goToSettings)
                                ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
                                self.present(ac, animated: true)
                            }
                        }
                    }
        }
        
        completion?("done")
        
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "d MMM y HH:mm"
        return formatter.string(from: date)
    }
    
    // UI UNDERLYING MECHANISM ----------------------------------------------------------------------
    
    // CANCEL CREATE/UPDATE THING
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // SELECT TIME SEGMENT -> DECIDE WHICH TEXT FIELDS TO SHOW
    @IBAction func timeSegmentControl(_ sender: Any) {
        timePicker.isHidden     = true
        exactTextField.isHidden        = true
        startTextField.isHidden        = true
        endTextField.isHidden          = true
        durationTextField.isHidden     = true
        switch timeSegment.selectedSegmentIndex {
        case 1:
            exactTextField.isHidden = false
        case 2:
            startTextField.isHidden = false
            endTextField.isHidden = false
        case 3:
            durationTextField.isHidden = false
        default:
            return
        }
    }
    
    // START EDITING TIME TEXTFIELDS
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
    
    // DECIDE TIME PICKER MODE
    @IBAction func changeTimePicker(_ sender: Any) {
        let time = AddItemViewController.timeFormatter.string(from: timePicker.date)
        let hour = Calendar.current.component(.hour, from: timePicker.date)
        let minute = Calendar.current.component(.minute, from: timePicker.date)
        let hours = hour>0 ? "\(hour)hr" : ""
        let minutes = minute>0 ? "\(minute)min" : ""
        let duration = "\(hours) \(minutes)"
        switch AddItemViewController.timeField {
        case "exact":
            exactTextField.text = time
        case "start":
            startTextField.text = time
        case "end":
            endTextField.text = time
        case "duration":
            durationTextField.text = duration
        default:
            return
        }
    }
    
    // END EDITING TIME TEXTFIELDS
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
    
    // HIDE KEYBOARD ON RETURN KEY
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == subtaskTextField {
                addSubtaskBTN(self)
            } else {
                self.view.endEditing(true)
            }
            return false
        }
    
    // ADD SUBTASK
    @IBAction func addSubtaskBTN(_ sender: Any) {
        guard let subtask = subtaskTextField.text, !subtask.isEmpty else {
            return
        }
        subtasks.append(subtask)
        subtaskTextField.text = ""
        self.tableView.reloadData()
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
        cell.subtaskLabel.text = subtasks[indexPath.row]
        
        return cell
    }

}


// *********************************************************************************************


class SubtaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subtaskLabel: UILabel!
    
}
