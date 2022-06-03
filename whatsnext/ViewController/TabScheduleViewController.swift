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
    static var models = [Item]()
    
    static var everything = [String : [Item]]() // store tasks based on day
    // store dictionary in core data
    // store customised class in core data
    // date as key? would it take all the components of date (incl. hour, minute, second) --> have many keys of same day
    // git, revert to previous commit, make changes on that commit and cannot save/push it to remote now
    
    let dateFormatter = DateFormatter()

    
    
    // UI ELEMENTS *****************************************************
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var journalLabel: UILabel!
    @IBOutlet weak var dateFilter: UIDatePicker!
    
    // METHODS *********************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        dateFormatter.dateFormat = "dd/MM/yyyy"
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    
    // BUTTONS *********************************************************
    
    @IBAction func dateChanged(_ sender: Any) { // TODO AFTER CHANGE DATA STRUCTURE
        if let filtered = TabScheduleViewController.everything[self.dateFormatter.string(from: self.dateFilter.date)] {
            TabScheduleViewController.models = filtered
        } else {
            TabScheduleViewController.models = [Item]()
        }
        self.table.reloadData()
    }

    
    
    
    // BUTTON - NEW TASK
    @IBAction func addTaskBTN(_ sender: Any) {
        // show add task VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddItemViewController else {
            return
        }
        vc.completion = { item in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
//                TabScheduleViewController.models.append(item)
                
                let date = self.dateFormatter.string(from: item.day)
                if let _ = TabScheduleViewController.everything[date] {
                    TabScheduleViewController.everything[date]?.append(item)
                    print("old date")
                } else {
                    TabScheduleViewController.everything[date] = [item]
                    print("new date")
                }
                
                self.dateChanged(self)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    // BUTTON - JOURNAL
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
}






extension TabScheduleViewController: UITableViewDelegate {
    
    // SELECT A TASK --> SEE ITS DETAILS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "details") as? ItemDetailsViewController  else {
            return
        }
        vc.item = TabScheduleViewController.models[indexPath.row]
        vc.completion = { item in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                TabScheduleViewController.models[indexPath.row] = item
                self.table.reloadData()
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
        return TabScheduleViewController.models.count
    }
    
    // LOAD DATA INTO THE ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemTableViewCell
        
        // name
        cell.nameLabel?.text = TabScheduleViewController.models[indexPath.row].name
        
        // category
        cell.categoryTagLabel?.text = TabScheduleViewController.models[indexPath.row].category

        cell.timeTagLabel?.text = TabScheduleViewController.models[indexPath.row].time.getTime()
        
        cell.checkView.tag = indexPath.row
//        cell.nameLabel.tag = self.dateFormatter.string(from: self.dateFilter.date)
        
        TabScheduleViewController.models[indexPath.row].completed ?
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
    
    @IBAction func checkBTN(_ sender: Any) {
        if let button = sender as? UIButton {
//            TabScheduleViewController.everything[self.dateFormatter.string(from: self.dateFilter)
            
            // TabScheduleViewController.models[button.tag].completed = !TabScheduleViewController.models[button.tag].completed
//            print(TabScheduleViewController.models[button.tag].completed)
//            print(button.tag)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let date = TabScheduleViewController.models[button.tag].day
            let index = button.tag
            
            
            TabScheduleViewController.everything[dateFormatter.string(from: date)]![index].completed = !TabScheduleViewController.everything[dateFormatter.string(from: date)]![index].completed
            
            // TODO keep changing the tag???
            TabScheduleViewController.everything[dateFormatter.string(from: date)]![index].completed ?
            checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
            checkView.setImage(UIImage(systemName: "circle"), for: .normal)
            
            
        }
        
        
        
    }
    
}
