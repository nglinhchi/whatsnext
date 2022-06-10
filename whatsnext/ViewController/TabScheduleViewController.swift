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

class TabScheduleViewController: UIViewController {
     
    // VARIABLES -------------------------------------------------------------------------------------
    static var things = [Thing]() // TODO - switch to non-static later
    var journal: Journal?
    
    // UTILS -----------------------------------------------------------------------------------------
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var usersReference = Firestore.firestore().collection("users")
//    var storageReference = Storage.storage().reference()
    
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var journalLabel: UILabel!
    @IBOutlet weak var dateFilter: UIDatePicker!
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        dateFormatter.dateFormat = "dd/MM/yyyy"
//        testItems()
        fetchThings()
        fetchJournal()
        
    }
    
    // HIDE TITLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
                let request = Subtask.fetchRequest() as NSFetchRequest<Subtask>
                let pred = NSPredicate(format: "%K == %@", "thingID", thing.id as CVarArg)
                request.predicate = pred
                let subtasks = try self.context.fetch(request)
                for subtask in subtasks {
                    self.context.delete(subtask)
                }
            }
            catch { print(error) }
            // delete things
            self.context.delete(thing)
            // save
            do { try self.context.save() }
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
    func testItems() {
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
        item.id = UUID()
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
            TabScheduleViewController.things[button.tag].completed = !TabScheduleViewController.things[button.tag].completed
            do { try context.save()}
            catch { print(error) }
            TabScheduleViewController.things[button.tag].completed ?
            checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
            checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
}

