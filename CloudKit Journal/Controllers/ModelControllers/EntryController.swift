//
//  EntryController.swift
//  CloudKit Journal
//
//  Created by Bryan Workman on 6/29/20.
//  Copyright © 2020 Bryan Workman. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    //MARK: - Shared Instance
    static let shared = EntryController()
    
    //MARK: - SOT
    var entries: [Entry] = []
    
    //MARK: - Private Cloud Database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //MARK: - CRUD Methods
    
    func createEntryWithTitle(title: String, body: String, completion: @escaping (Result<Entry, EntryError>) -> Void ){
        
        let newEntry = Entry(body: body, title: title)
        
        let entryRecord = CKRecord(entry: newEntry)
        
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                print("There was an error saving an Entry - \(error) -\(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                let savedEntry = Entry(ckRecord: record) else {return completion(.failure(.couldNotUnwrap))}
            
            print("Saved Entry Successfully")
            completion(.success(savedEntry))
        }
    }
    
    func fetchEntriesWith(completion: @escaping (Result<[Entry]?, EntryError>) -> Void){
     
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: EntryConstants.recordType, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("There was an error fetching all Entries - \(error) - \(error.localizedDescription)")
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else {return completion(.failure(.couldNotUnwrap))}
            
            print("Fetched Entry Records Successfully")
            
            let fetchedEntries = records.compactMap { Entry(ckRecord: $0) }
            
            
            completion(.success(fetchedEntries))
        }
    }
    
}
