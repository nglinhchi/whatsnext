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
    @IBOutlet weak var journalTV: UITextView!
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTV.text = currentJournal?.diary ?? ""
        dateFormatter.dateFormat = "dd/MM/yyyy"
        journalTV.layer.cornerRadius = 10
        journalTV.layer.borderWidth = 1
        journalTV.layer.borderColor = .init(genericCMYKCyan: 0, magenta: 255, yellow: 0, black: 255, alpha: 1)
    }
    
    
    
    
    // JOURNAL - CRUD -------------------------------------------------------------------------------
    
    // CANCEL CREATE/EDIT JOURNAL
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // CREATE/EDIT JOURNAL
    @IBAction func saveBTN(_ sender: Any) {
        if let journal = journalTV.text, !journal.isEmpty {
            if currentJournal == nil { // create journal
                currentJournal!.id = databaseController?.addJournal(date: dateFormatter.string(from: currentDate!), diary: journal).id // firebase
                currentJournal = Journal(context: context)
                currentJournal!.day = currentDate!
                currentJournal!.diary = journal
            } else { // edit journal's diary
                // TODO update in firebase --> get ref and change diary
                currentJournal!.diary = journal
            }
            do { try context.save()}
            catch { print(error)}
        } else { // delete journal
            if currentJournal != nil {
                // TODO delete in firebase --> get ref and delete record
                context.delete(currentJournal!)
                do { try context.save()}
                catch { print(error)}
            }
        }
        completion?("done editing")
    }
    
}
