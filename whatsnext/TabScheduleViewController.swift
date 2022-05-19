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
    
    
    
    // UI ELEMENTS *****************************************************
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var dateBTN: UIButton!
    @IBOutlet weak var journalLabel: UILabel!
    
    
    
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
    
    
    
    // BUTTONS *********************************************************
    @IBAction func addTaskBTN(_ sender: Any) {
        // show add task VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddItemViewController else {
            return
        }
        vc.completion = { item in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                TabScheduleViewController.models.append(item)
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
    
    // DATE SELECTOR
    @IBAction func dateBTN(_ sender: Any) {
        let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(changeDate(sender:)), for: UIControl.Event.valueChanged)
        picker.frame.size = CGSize(width: 0, height: 250)
        //        dateBTN.setTitle("HELLO", for: .normal)
        
    }
    
    @objc func changeDate(sender: UIDatePicker) {
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
        vc.completion = { journal in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
//                self.journalLabel.text = journal
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
        
        // handle cell's button
        if TabScheduleViewController.models[indexPath.row].completed {
            // show filled circle
         } else {
            // show empty circle
         }
        
        return cell
    }

    
}







class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTagLabel: UILabel!
    @IBOutlet weak var timeTagLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var checkView: UIButton!
    
    @IBAction func checkBTN(_ sender: Any) {
        // TODO change item's done to !done
//        models[indexPath.row].done = !(models[indexPath.row].done)
        
        checkView.currentImage == UIImage(systemName: "circle") ?
        checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
        checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        
        
    }
    
}

