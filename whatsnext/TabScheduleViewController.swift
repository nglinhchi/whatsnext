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
    @IBOutlet weak var dateBTN: UIButton!
    @IBOutlet weak var journalLabel: UILabel!
    
    // BUTTONS *********************************************************
    @IBAction func addTaskBTN(_ sender: Any) {
        // show add task VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddItemViewController else {
            return
        }
        vc.completion = { name, category in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let item = Item(name: name, category: category, done: false)
                self.models.append(item)
                self.table.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editDiaryBTN(_ sender: Any) {
        // show edit diary VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "journal") as? EditJournalViewController  else {
            return
        }
        vc.currentJournal = journalLabel.text
        vc.completion = {journal in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                self.journalLabel.text = journal
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func dateBTN(_ sender: Any) {
        let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(changeDate(sender:)), for: UIControl.Event.valueChanged)
        picker.frame.size = CGSize(width: 0, height: 250)
        //        dateBTN.setTitle("HELLO", for: .normal)
        
    }
    
    
    @objc func changeDate(sender: UIDatePicker) {
        
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
        
        // name
        cell.nameLabel?.text = models[indexPath.row].name
        
        
        // category
        cell.categoryTagLabel?.text = models[indexPath.row].category
        switch models[indexPath.row].category {
        case "home":
            cell.categoryTagLabel?.backgroundColor = UIColor(red: 5/255, green: 147/255, blue: 23/255, alpha: 1)
        case "uni":
            cell.categoryTagLabel?.backgroundColor = UIColor(red: 230/255, green: 87/255, blue: 5/255, alpha: 1)
        default:
            cell.categoryTagLabel?.backgroundColor = .tintColor
        }
        
        
        // handle cell's button
         if models[indexPath.row].done {
            // show filled circle
         } else {
            // show empty circle
         }
        
        
        return cell
        
    }
    
    
}


struct Item {
    let name: String
    let category: String
    var done: Bool
}



class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTagLabel: UILabel!
    @IBOutlet weak var timeTagLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func checkBTN(_ sender: Any) {
        // change item's done to !done
//        models[indexPath.row].done = !(models[indexPath.row].done)
    }
    
}
