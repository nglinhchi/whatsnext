//
//  ItemDetailsViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 11/5/2022.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryTag: UILabel!
    @IBOutlet weak var timeTag: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var notesLabel: UILabel!
    
    
    var item: Item?
    
    public var completion: ((Item) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        taskNameLabel.text = item!.name
        dateLabel.text = dateFormatter.string(from: item!.day)
        categoryTag.text = item!.category
        timeTag.text = item!.time.getTime()
        notesLabel.text = item!.notes
        
        table.delegate = self
        table.dataSource = self
        
    }
    
    
    
    @IBAction func discardBTN(_ sender: Any) {
        completion?(item!)
    }
    
    
    @IBAction func editBTN(_ sender: Any) {
        
        // open up add new task screen
        // load the current data into view
        // if discard do nothing
        // if save then send that item to view details screen - it will do the magic to models
        
        // show add task VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddItemViewController else {
            return
        }
        vc.item = item
        vc.completion = { item in
            DispatchQueue.main.async {
//                self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
                self.item = item
                self.viewDidLoad()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}



// *********************************************************************************************


extension ItemDetailsViewController: UITableViewDelegate {
    
    // SELECT A TASK --> SEE ITS DETAILS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        item!.subtasks[indexPath.row].completed = !item!.subtasks[indexPath.row].completed
        self.table.reloadData()
    }
    
}


extension ItemDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.subtasks.count ?? 0
    }
    
    // LOAD DATA INTO THE ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubtaskTableViewCell
        // put the strings from subtasks t subtask table
        cell.subtaskLabel.text = item?.subtasks[indexPath.row].name
        cell.accessoryType = item!.subtasks[indexPath.row].completed ? .checkmark : .none
        return cell
    }

}


// *********************************************************************************************
