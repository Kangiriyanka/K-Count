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
