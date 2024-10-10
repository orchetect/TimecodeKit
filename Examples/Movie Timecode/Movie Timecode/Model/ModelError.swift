//
//  ModelError.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

enum ModelError: LocalizedError {
    case errorCreatingMutableMovieCopy
    case fileImportError(Error)
    case noMovieLoaded
    case exportError(_ details: Error?)
    case pathDoesNotExist
    case pathIsNotFolder
}

extension ModelError {
    var errorDescription: String? {
        switch self {
        case .errorCreatingMutableMovieCopy:
            "Error creating mutable movie copy in memory."
        case let .fileImportError(error):
            "File import error: \(error.localizedDescription)."
        case .noMovieLoaded:
            "No movie loaded."
        case let .exportError(details):
            if let details {
                "Export error: \(details.localizedDescription)."
            } else {
                "Export error."
            }
        case .pathDoesNotExist:
            "Path does not exist."
        case .pathIsNotFolder:
            "Path is not a folder."
        }
    }
}
