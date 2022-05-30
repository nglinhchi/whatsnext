//
//  JournalLogsViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 26/5/2022.
//

import UIKit

class JournalLogsViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    let dateFormatter = DateFormatter()
    let dayFormatter = DateFormatter()
    
    
    var logs = [(day: Date, journal: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dayFormatter.locale = Locale(identifier: "en_US")
        dayFormatter.dateFormat = "EEEE dd/MM/yyyy"
        
        
        for (key,value) in TabScheduleViewController.everything {
            let date = dateFormatter.date(from: key)!
            logs.append((day: date, journal: value.journal))
        }
        print(logs)
        
        table.delegate = self
        table.dataSource = self
        
        
    }

}



// *********************************************************************************************************


extension JournalLogsViewController: UITableViewDelegate {
    
    // SELECT A TASK --> SEE ITS DETAILS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



extension JournalLogsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    // LOAD DATA INTO THE ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JournalTableViewCell
        
        cell.journalLabel?.text = logs[indexPath.row].journal
        cell.dateLabel?.text = dayFormatter.string(from: logs[indexPath.row].day)
        return cell
        
        
        
        
        
        
    }
    
    
}

// *********************************************************************************************************


class JournalTableViewCell: UITableViewCell {
    

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var journalLabel: UILabel!
}
