//
//  TabScheduleViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 4/5/2022.
//

import UIKit
import UserNotifications
import CoreData
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestoreSwift

class TabScheduleViewController: UIViewController, DatabaseListener {
     
    // VARIABLES -------------------------------------------------------------------------------------
    static var things = [Thing]()
    var journals = [Journal]()
    var journal: Journal?
    var userJournal = [FBJournal()]
    var userThing = [FBThing()]
    var listenerType: ListenerType = .all
    
    // UTILS -----------------------------------------------------------------------------------------
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var databaseController: FirebaseProtocol?
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var journalLabel: UILabel!
    @IBOutlet weak var dateFilter: UIDatePicker!
    
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseController = appDelegate?.databaseFirebase
        dateFormatter.dateFormat = "dd/MM/yyyy"
        table.delegate = self
        table.dataSource = self
//        firebaseTestItems()
//        coredataTestItems()
        loadAllThing()
        loadAllJournal()
    }
    
    // FIREBASE ---------------------------------------------------------------------------------------
    
    func loadAllJournal() {
        userJournal = []
         for journal in LogInViewController.firebaseJournal{
            if( Auth.auth().currentUser?.uid == journal.userID){
                userJournal.append(journal)
            }
        }
        fetchJournal()
        if journals.isEmpty{
            for each in userJournal {
                let coreJournal = Journal(context: context)
                coreJournal.id = each.id
                coreJournal.day = coreJournal.stringToDate(string: each.date!)
                coreJournal.diary = each.diary!
            }
            do { try context.save() }
            catch { print(error) }
            fetchJournal()
        }
    }
    
    
    func loadAllThing() {
        userThing = []
         for thing in LogInViewController.firebaseThing{
             if( Auth.auth().currentUser?.uid == thing.userID){
                userThing.append(thing)
            }
        }
        fetchThings()
        if TabScheduleViewController.things.isEmpty{
            for each in userThing {
                
                let id = each.id!
                let category = each.category!
                let completed = each.completed!
                let day = dateFormatter.date(from: each.date!)!
                let name = each.name!
                let notes = each.note!
                let coreTime = Time(context: context)
                for time in LogInViewController.firebaseTime{
                    if time.thingID == each.id {
                        coreTime.type = time.type!
                        coreTime.id = time.id
//                        coreTime.thing
                        switch coreTime.type {
                        case "exact":
                            coreTime.exact = coreTime.stringToDate(string: time.exact!)
                        case "start-end":
                            coreTime.start = coreTime.stringToDate(string: time.start!)
                            coreTime.end = coreTime.stringToDate(string: time.end!)
                        case "duration":
                            coreTime.duration = time.duaration
                        default:
                            print("prob won't happen")
                        }
                    }
                }
                
                let coreThing = Thing(context: context)
                coreThing.id = id
                coreThing.category = category
                coreThing.completed = completed
                coreThing.day = day
                coreThing.name = name
                coreThing.notes = notes
                coreThing.time = coreTime
            }
            do { try context.save() }
            catch { print(error) }
            fetchThings()
        }
    }
    
    
    func onThingChange(change: DatabaseChange, things: [FBThing]) {
        LogInViewController.firebaseThing = things
    }
    
    func onTimeChange(change: DatabaseChange, times: [FBTime]) {
        LogInViewController.firebaseTime = times
    }
    
    func onSubClassChange(change: DatabaseChange, subClasses: [FBSubClass]) {
        LogInViewController.firebaseSubClass = subClasses
    }
    func onJournalChange(change: DatabaseChange, journals: [FBJournal]) {
        LogInViewController.firebaseJournal = journals
    }
    
    func onRandomChange(change: DatabaseChange, randoms: [FBRandom]) {
        LogInViewController.firebaseRandom = randoms
    
//        for random in randoms{
//            if random.userID == Auth.auth().currentUser?.uid{
//                userRandom.append(random)
//            }
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        databaseController?.addListener(listener: self)
    }
    
    
    // CRUD - JOURNAL ---------------------------------------------------------------------------------
    func fetchJournal() {
        journalLabel.text = ""
        do {
            let journals = try context.fetch(Journal.fetchRequest())
            print(journals.count)
            self.journal = nil
            for journal in journals {
                print(journal.day)
                if dateFormatter.string(from: journal.day) == dateFormatter.string(from: dateFilter.date) {
                    self.journal = journal
                    journalLabel.text = self.journal!.diary
                }
            }
        }
        catch { print(error)}
    }
    
    // CRUD - THINGS ----------------------------------------------------------------------------------
    
    // FETCH THINGS INTO VIEW
    func fetchThings() {
        do {
            let all = try context.fetch(Thing.fetchRequest())
            TabScheduleViewController.things = [Thing]()
            for thing in all {
                if dateFormatter.string(from: thing.day) == dateFormatter.string(from: dateFilter.date) {
                    TabScheduleViewController.things.append(thing)
                }
            }
//            TabScheduleViewController.things = try context.fetch(Thing.fetchRequest())
            self.table.reloadData()
        }
        catch { print(error) }
    }
    
    // FILTER THINGS BASED ON DAY
    @IBAction func dateChanged(_ sender: Any) {
        fetchJournal()
        fetchThings()
    }
    
    // CREATE THING
    @IBAction func addTaskBTN(_ sender: Any) {
        // show add task VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddItemViewController else {
            return
        }
        vc.completion = { message in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.fetchThings()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    
    // DELETE THING
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let thing = TabScheduleViewController.things[indexPath.row]
            // delete subtasks
            do {
                let allSubtasks = try self.context.fetch(Subtask.fetchRequest())
                for each in allSubtasks {
                    if each.thingID == thing.id {
                        self.databaseController?.deleteSubClass(id: each.id!) // firebase delete subtask
                        self.context.delete(each) // coredata delete subtask
                    }
                }
                
                let allTimes = try self.context.fetch(Time.fetchRequest())
                for each in allTimes {
                    if each.thing?.id == thing.id {
                        self.databaseController?.deleteTime(id: each.id!) // firebase delete time
                        self.context.delete(each) // coredata delete time
                    }
                }
                self.databaseController?.deleteThing(id: thing.id!) // firebase delete thing
                self.context.delete(thing) // coredata delete thing
                try self.context.save()
            }
            catch { print(error) }
            self.fetchThings()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // CRUD - JOURNAL ----------------------------------------------------------------------------------------
    
    // CREATE/UPDATE JOURNAL
    @IBAction func editDiaryBTN(_ sender: Any) {
        // show edit diary VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "journal") as? EditJournalViewController  else {
            return
        }
        if self.journal != nil { vc.currentJournal = self.journal }
        vc.currentDate = self.dateFilter.date
        vc.completion = {message in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
//                self.journalLabel.text = journal
                self.fetchJournal()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // TESTING -----------------------------------------------------------------------------------------------
    func coredataTestItems() {
        // create new ITEM
        let time = Time(context: self.context)
        time.type = "-"
        let item = Thing(context: self.context)
        item.name = "get grocceries"
        item.category = "home"
        item.completed = false
        item.day = dateFormatter.date(from: "10/06/2022")!
        item.time = time
        item.notes = "eat healthy baby"
        item.id = (databaseController?.addThing(category: item.category, completed: item.completed, date: dateFormatter.string(from: item.day), name: item.name, note: item.notes).id)!
        let subtask = Subtask(context: self.context)
        subtask.name = "task 1"
        subtask.completed = false
        subtask.thingID = item.id
        let subtask2 = Subtask(context: self.context)
        subtask2.name = "task 2"
        subtask2.completed = false
        subtask2.thingID = item.id
        // save the data
        do { try context.save() }
        catch { print(error) }
        // reload data
         self.fetchThings()
    }
    
    func firebaseTestItems() {
        databaseController?.addRandom(name: "Minh", completed: true)
        databaseController?.addJournal(date: "12/12/12", diary: "Hello world")
        databaseController?.addSubClass(completed: true, name: "asd", thingID:"123")
        databaseController?.addTime(duaration: "asd", end: "123", exact: "123", start: "123", type: "123", thingID: "123")
        databaseController?.addThing(category: "123", completed: false, date: "123", name: "123", note: "123")
    }
    
}


extension TabScheduleViewController: UITableViewDelegate {
    
    // SELECT A THING --> SEE ITS DETAILS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "details") as? ItemDetailsViewController  else {
            return
        }
        vc.thing = TabScheduleViewController.things[indexPath.row]
        vc.completion = { message in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.fetchThings()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension TabScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TabScheduleViewController.things.count
    }
    
    // DISPLAY FILTERED THINGS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        cell.nameLabel?.text = TabScheduleViewController.things[indexPath.row].name
        cell.categoryTagLabel?.text = TabScheduleViewController.things[indexPath.row].category
        cell.timeTagLabel?.text = TabScheduleViewController.things[indexPath.row].time.getTime()
        cell.checkView.tag = indexPath.row
        //  cell.nameLabel.tag = self.dateFormatter.string(from: self.dateFilter.date)
        TabScheduleViewController.things[indexPath.row].completed ?
        cell.checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
        cell.checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        return cell
    }
    
}

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTagLabel: UILabel!
    @IBOutlet weak var timeTagLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkView: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func checkBTN(_ sender: Any) {
        if let button = sender as? UIButton {
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            weak var databaseController: FirebaseProtocol?
            databaseController = appDelegate?.databaseFirebase
            let thingChanged = TabScheduleViewController.things[button.tag]
            databaseController?.toggleThing(id: thingChanged.id!, completed: !thingChanged.completed)
            
            TabScheduleViewController.things[button.tag].completed = !TabScheduleViewController.things[button.tag].completed // coredata edit thing's completed
            do { try context.save()}
            catch { print(error) }
            TabScheduleViewController.things[button.tag].completed ?
            checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
            checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
}

