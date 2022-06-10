//
//  EditJournalViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 5/5/2022.
//

import UIKit

class EditJournalViewController: UIViewController {

    
    // VARIABLES + CONSTANTS *******************************************
    public var completion: ((String) -> Void)?
    var currentJournal: Journal?
    var currentDate: Date?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var journalTV: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTV.text = currentJournal?.diary ?? ""
        journalTV.layer.cornerRadius = 10
        journalTV.layer.borderWidth = 1
        journalTV.layer.borderColor = .init(genericCMYKCyan: 0, magenta: 255, yellow: 0, black: 255, alpha: 1)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveBTN(_ sender: Any) {
        if let journal = journalTV.text, !journal.isEmpty {
            if currentJournal == nil {
                currentJournal = Journal(context: context)
                currentJournal!.day = currentDate!
            }
            currentJournal!.diary = journal
            do { try context.save()}
            catch { print(error)}
        } else {
            if currentJournal != nil {
                context.delete(currentJournal!)
                do { try context.save()}
                catch { print(error)}
            }
        }
        completion?("done editing")
    }
    
    
}
