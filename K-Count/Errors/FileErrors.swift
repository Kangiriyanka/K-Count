//
//  FileErrors.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/27.
//

import Foundation


enum FileSaveError: Error {
    case noDocumentsDirectory
    case encodingFailed(Error)
    case writingFailed(Error)
}


enum FileDecodeError: Error {
    case noDocumentsDirectory
    case fileNotFound(URL)
    case keyNotFound(String, String)
    case typeMismatch(String)
    case valueNotFound(String)
    case dataCorrupted
    case unknown(String)
}
