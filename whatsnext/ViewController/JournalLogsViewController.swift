//
//  JournalLogsViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 10/6/2022.
//

import UIKit

class JournalLogsViewController: UIViewController {
    
    // VARIABLES -------------------------------------------------------------------------------------
    var journals = [Journal]()
    
    // UTILS -----------------------------------------------------------------------------------------
    let dayFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayFormatter.locale = Locale(identifier: "en_US")
        dayFormatter.dateFormat = "EEEE, dd/MM/yyyy"
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 600
        table.rowHeight = UITableView.automaticDimension
        fetchJournals()
    }
    
    func fetchJournals() {
        do {
            journals = try context.fetch(Journal.fetchRequest())
            journals = journals.sorted(by: { $0.day.compare($1.day) == .orderedDescending })
            table.reloadData()
        }
        catch { print(error)}
    }

}

extension JournalLogsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension JournalLogsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journals.count
    }
    
    // DISPLAY JOURNAL LOGS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JournalLogsTableViewCell
        cell.dateLabel.text = dayFormatter.string(from: journals[indexPath.row].day)
        cell.diaryLabel.text = journals[indexPath.row].diary
        return cell
    }
    
}

class JournalLogsTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var diaryLabel: UILabel!
}
