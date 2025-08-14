//
//  FileManager-Decodable.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/12.
//

import Foundation


extension FileManager {
    
    func decode<T: Codable>(_ file: String) -> T {
        
        // Check if the Documents directory exists
        guard let documentsURL = self.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Couldn't find documents directory.")
        }
        
        
        // Append the file name to the documentsURL
        let fileURL = documentsURL.appendingPathComponent(file)
        
        // Initialize our Decoder
        let decoder = JSONDecoder()
        
        // Read the contents of our file
        guard let data = try? Data(contentsOf: fileURL) else {
            fatalError("Could not read file at \(fileURL).")
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON.")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
        
        
        
    }
    
    func saveCSVFile(csvString: String, file: String = "data.csv") -> URL? {
        
        guard let documentsURL = self.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Couldn't find documents directory.")
        }
        
        // Append the file name to the documentsURL
        let fileURL = documentsURL.appendingPathComponent(file)
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV filed saved to: \(fileURL)")
            return fileURL
        }
        catch {
            fatalError("Couldn't write CSV file to disk.")
        }
        
    }
    
}
    

