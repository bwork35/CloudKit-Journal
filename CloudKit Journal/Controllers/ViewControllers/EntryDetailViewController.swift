//
//  EntryDetailViewController.swift
//  CloudKit Journal
//
//  Created by Bryan Workman on 6/29/20.
//  Copyright © 2020 Bryan Workman. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
    }
    
    func updateViews() {
        if let entry = entry {
            titleTextField.text = entry.title
            bodyTextView.text = entry.body
        }
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        bodyTextView.resignFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {return}
        guard let body = bodyTextView.text, !body.isEmpty else {return}
        
        EntryController.shared.createEntryWithTitle(title: title, body: body) { (result) in
            switch result {
            case .success(let entry):
                EntryController.shared.entries.insert(entry, at: 0)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        bodyTextView.text = ""
        titleTextField.text = ""
    }
}

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}
