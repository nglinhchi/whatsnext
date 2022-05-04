//
//  TabScheduleViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 4/5/2022.
//

import UIKit

class TabScheduleViewController: UIViewController {

    
    // VARIABLES + CONSTANTS *******************************************
    var models = [Item]()
    
    
    
    
    // UI ELEMENTS *****************************************************
    @IBOutlet weak var table: UITableView!
    
    
    
    // BUTTONS *********************************************************
    
    @IBAction func addTaskBTN(_ sender: Any) {
        // show add task VC
    }
    
    
    @IBAction func editDiaryBTN(_ sender: Any) {
        // show edit diary VC
    }
    
    
    // METHODS *********************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
    
        table.delegate = self
        table.dataSource = self
        

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let d = formatter.date(from: "18/04/2022")!

        let a = Item(title: "FIT3178 workshop", date: d, identifier: "ID")

        models.append(a)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        return cell
        
    }
    
    
}



struct Item {
    let title: String
    let date: Date
    let identifier: String
}
