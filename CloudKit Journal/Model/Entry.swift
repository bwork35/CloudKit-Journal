//
//  Entry.swift
//  CloudKit Journal
//
//  Created by Bryan Workman on 6/29/20.
//  Copyright © 2020 Bryan Workman. All rights reserved.
//

import Foundation
import CloudKit

struct EntryConstants{
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
    static let recordType = "Entry"
}

class Entry {
    var body: String
    var title: String
    var timestamp: Date
    
    init(body: String, title: String, timestamp: Date = Date()){
        self.body = body
        self.title = title
        self.timestamp = timestamp
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.recordType)
        
        self.setValuesForKeys([
            EntryConstants.titleKey : entry.title,
            EntryConstants.bodyKey : entry.body,
            EntryConstants.timestampKey : entry.timestamp
        ])
    }
}

extension Entry {
    
    convenience init?(ckRecord: CKRecord){
        guard let body = ckRecord[EntryConstants.bodyKey] as? String,
            let title = ckRecord[EntryConstants.titleKey] as? String,
            let timestamp = ckRecord[EntryConstants.timestampKey] as? Date else {return nil}
        
        self.init(body: body, title: title, timestamp: timestamp)
    }
    
}
