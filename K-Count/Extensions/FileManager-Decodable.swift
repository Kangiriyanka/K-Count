//
//  FileManager-Decodable.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/12.
//

import Foundation



extension FileManager {
    
    func decode<T: Codable>(_ file: String) throws -> T {
            guard let documentsURL = self.urls(for: .documentDirectory, in: .userDomainMask).first else {
                throw FileDecodeError.noDocumentsDirectory
            }
            
            let fileURL = documentsURL.appendingPathComponent(file)
            
            guard let data = try? Data(contentsOf: fileURL) else {
                throw FileDecodeError.fileNotFound(fileURL)
            }
            
            let decoder = JSONDecoder()
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch DecodingError.keyNotFound(let key, let context) {
                throw FileDecodeError.keyNotFound(key.stringValue, context.debugDescription)
            } catch DecodingError.typeMismatch(_, let context) {
                throw FileDecodeError.typeMismatch(context.debugDescription)
            } catch DecodingError.valueNotFound(_, let context) {
                throw FileDecodeError.valueNotFound(context.debugDescription)
            } catch DecodingError.dataCorrupted(_) {
                throw FileDecodeError.dataCorrupted
            } catch {
                throw FileDecodeError.unknown(error.localizedDescription)
            }
        }
    
        
        
        

    func saveCSVFile(csvString: String, filename: String) throws -> URL? {
        
        guard let documentsURL = self.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileSaveError.noDocumentsDirectory
        }
        
        // Append the file name to the documentsURL
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        }
        catch {
            throw FileSaveError.writingFailed(error)
        }
        
    }
    
    
    func saveJSONFile<T: Encodable>(object: T, file: String) throws -> URL {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileSaveError.noDocumentsDirectory
        }
        
        let fileURL = documentsURL.appendingPathComponent(file)
        
        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            encoder.dateEncodingStrategy = .formatted(formatter)
            let data = try encoder.encode(object)
            try data.write(to: fileURL, options: .atomic)
            
            return fileURL
        } catch let error as EncodingError {
            throw FileSaveError.encodingFailed(error)
        } catch {
            throw FileSaveError.writingFailed(error)
        }
    }
    
}
    

