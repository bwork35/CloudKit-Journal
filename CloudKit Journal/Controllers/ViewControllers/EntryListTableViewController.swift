//
//  EntryListTableViewController.swift
//  CloudKit Journal
//
//  Created by Bryan Workman on 6/29/20.
//  Copyright © 2020 Bryan Workman. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func loadData() {
        EntryController.shared.fetchEntriesWith { (result) in
            switch result {
            case .success(let entries):
                guard let entries = entries else {return}
                EntryController.shared.entries = entries
                self.updateViews()
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.shared.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)

        let entry = EntryController.shared.entries[indexPath.row]
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timestamp.dateAsString()

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            guard let destinationVC = segue.destination as? EntryDetailViewController else {return}
            let entryToSend = EntryController.shared.entries[indexPath.row]
            destinationVC.entry = entryToSend
        }
    }
    

}
