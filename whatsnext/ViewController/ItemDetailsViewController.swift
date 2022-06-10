//
//  ItemDetailsViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 11/5/2022.
//

import UIKit
import CoreData

class ItemDetailsViewController: UIViewController {

    // VARIABLES -------------------------------------------------------------------------------------
    var thing = Thing()
    var subtasks = [Subtask]()
    
    // UTILS -----------------------------------------------------------------------------------------
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    public var completion: ((String) -> Void)?
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryTag: UILabel!
    @IBOutlet weak var timeTag: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var notesLabel: UILabel!
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        taskNameLabel.text = thing.name
        dateLabel.text = dateFormatter.string(from: thing.day)
        categoryTag.text = thing.category
        timeTag.text = thing.time.getTime()
        notesLabel.text = thing.notes
        
        table.delegate = self
        table.dataSource = self
        
        fetchSubtasks()
    }
    
    @IBAction func discardBTN(_ sender: Any) {
        completion?("done") // just completion to come back
    }
    
    // CRUD - THING -------------------------------------------------------------------------------
    
    // FILTER SUBTASKS
    func fetchSubtasks() {
        do {
            let request = Subtask.fetchRequest() as NSFetchRequest<Subtask>
            let pred = NSPredicate(format: "%K == %@", "thingID", thing.id as CVarArg)
            request.predicate = pred
            subtasks = try context.fetch(request)
            table.reloadData()
        }
        catch { print(error) }
    }
    
    // EDIT THING
    @IBAction func editBTN(_ sender: Any) {
        // open up add new task screen
        // load the current data into view
        // if discard do nothing
        // if save then send that item to view details screen - it will do the magic to models
        
        // show add task VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddItemViewController else {
            return
        }
        vc.item = thing
        vc.completion = { message in
            DispatchQueue.main.async {
//                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
//                self.thing = item
                self.viewDidLoad()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // DELETE SUBTASK
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let subtask = self.subtasks[indexPath.row]
            self.context.delete(subtask)
            do { try self.context.save() }
            catch { print(error) }
            self.fetchSubtasks()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}


// ***************************************************************************************************

extension ItemDetailsViewController: UITableViewDelegate {
    
    // SUBTASK - TOGGLE COMPLETED
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        subtasks[indexPath.row].completed = !subtasks[indexPath.row].completed
        do { try context.save() }
        catch { print(error) }
        fetchSubtasks()
    }
    
}


extension ItemDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtasks.count
    }
    
    // DISPLAY SUBTASKS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubtaskTableViewCell
        // put the strings from subtasks t subtask table
        cell.subtaskLabel.text = subtasks[indexPath.row].name
        cell.accessoryType = subtasks[indexPath.row].completed ? .checkmark : .none
        return cell
        // TODO ability to delete AND update subtask
    }
    
}
