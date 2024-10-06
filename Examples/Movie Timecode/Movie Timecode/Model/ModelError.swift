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
            return "Error creating mutable movie copy in memory."
        case let .fileImportError(error):
            return "File import error: \(error.localizedDescription)."
        case .noMovieLoaded:
            return "No movie loaded."
        case let .exportError(details):
            if let details {
                return "Export error: \(details.localizedDescription)."
            } else {
                return "Export error."
            }
        case .pathDoesNotExist:
            return "Path does not exist."
        case .pathIsNotFolder:
            return "Path is not a folder."
        }
    }
}
