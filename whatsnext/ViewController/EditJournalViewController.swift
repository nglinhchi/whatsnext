//
//  EditJournalViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 5/5/2022.
//

import UIKit

class EditJournalViewController: UIViewController {

    
    // VARIABLES -------------------------------------------------------------------------------------
    var currentJournal: Journal?
    var currentDate: Date?
    
    // UTILS -----------------------------------------------------------------------------------------
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    public var completion: ((String) -> Void)?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var databaseController: FirebaseProtocol?
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var journalTextView: UITextView!
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTextView.text = currentJournal?.diary ?? ""
        dateFormatter.dateFormat = "dd/MM/yyyy"
        journalTextView.layer.cornerRadius = 10
        journalTextView.layer.borderWidth = 1
        journalTextView.layer.borderColor = .init(genericCMYKCyan: 0, magenta: 255, yellow: 0, black: 255, alpha: 1)
        databaseController = appDelegate?.databaseFirebase
    }
    
    // JOURNAL - CRUD -------------------------------------------------------------------------------
    
    // CANCEL CREATE/EDIT JOURNAL
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // CREATE/EDIT JOURNAL
    @IBAction func saveBTN(_ sender: Any) {
        if let journal = journalTextView.text, !journal.isEmpty { // contain text
            if currentJournal == nil { // the day doesn't have journal yet --> create journal
                currentJournal = Journal(context: context) // coredata add
                currentJournal!.day = currentDate!
                currentJournal!.diary = journal
                currentJournal!.id = databaseController?.addJournal(date: dateFormatter.string(from: currentDate!), diary: journal).id // firebase add
            } else { // edit journal's diary
                databaseController?.editJournal(id: currentJournal!.id!, diary: journal) // firebase edit
                currentJournal!.diary = journal // coredata edit
            }
            do { try context.save()}
            catch { print(error)}
        } else { // delete journal
            if currentJournal != nil {
                databaseController?.deleteJournal(id: currentJournal!.id!) // firebase delete
                context.delete(currentJournal!) // coredata delete
                do { try context.save()}
                catch { print(error)}
            }
        }
        completion?("done editing")
    }
    
}
