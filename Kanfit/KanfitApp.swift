//
//  KanfitApp.swift
//  Kanfit
//
//  Created by Kangiriyanka The Single Leaf on 2024/11/10.
//

import SwiftUI
import SwiftData

@main
struct KanfitApp: App {
    init() {
      
        setupFiles(filename: "foods.json")
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Day.self)
    }
    
    func setupFiles(filename: String) {
        let fileManager = FileManager.default
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Could not locate the Documents directory.")
            return
        }
        
        let fileURL = documentsURL.appendingPathComponent(filename)
        
        // Check if the file already exists
        if !fileManager.fileExists(atPath: fileURL.path) {
            
            if let bundleURL = Bundle.main.url(forResource: "foods", withExtension: "json") {
                do {
                    // Copy the file from the bundle to the Documents directory
                    try fileManager.copyItem(at: bundleURL, to: fileURL)
                    print("foods.json copied to Documents directory.")
                } catch {
                    print("Error copying foods.json: \(error)")
                }
            } else {
                print("Could not locate foods.json in the bundle.")
                
                do {
                    // Create an empty JSON array (or dictionary) as the initial data
                    let emptyData = Data("[]".utf8) // Or use "{}" for an empty dictionary
                    try emptyData.write(to: fileURL)
                    print("\(filename) created with empty JSON array at \(fileURL.path)")
                } catch {
                    print("Failed to create empty JSON file: \(error)")
                }
            }
        }  else {
                    print("\(filename) already exists at \(fileURL.path)")
                }
            }
        
}
