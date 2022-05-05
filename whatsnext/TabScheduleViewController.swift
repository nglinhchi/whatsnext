//
//  TabScheduleViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 4/5/2022.
//

import UIKit
import UserNotifications

class TabScheduleViewController: UIViewController {

    
    // VARIABLES + CONSTANTS *******************************************
    var models = [Item]()
    
    
    // UI ELEMENTS *****************************************************
    @IBOutlet weak var table: UITableView!
    
    
    // BUTTONS *********************************************************
    @IBAction func addTaskBTN(_ sender: Any) {
        // show add task VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddItemViewController else {
            return
        }
        vc.completion = { name, category in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let item = Item(name: name, category: category)
                self.models.append(item)
                self.table.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editDiaryBTN(_ sender: Any) {
        // show edit diary VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "journal") as? EditJournalViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    // METHODS *********************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
}



extension TabScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



extension TabScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        cell.categoryTagLabel?.text = models[indexPath.row].category
        cell.nameLabel?.text = models[indexPath.row].name
        return cell
        
    }
    
    
}


struct Item {
    let name: String
    let category: String
}



class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTagLabel: UILabel!
    @IBOutlet weak var timeTagLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
}
