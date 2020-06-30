//
//  EntryError.swift
//  CloudKit Journal
//
//  Created by Bryan Workman on 6/29/20.
//  Copyright © 2020 Bryan Workman. All rights reserved.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get this Entry..."
        }
    }
}
