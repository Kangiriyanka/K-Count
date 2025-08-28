//
//  SwiftUIView.swift
//  K-Count
//
//  Created by Kangiriyanka The Single Leaf on 2025/08/27.
//

import SwiftUI

struct ExportView: View {
    
    @State private var url: URL
    var body: some View {
        Text("HEY BRUH")
        ShareLink(item: url ) {
            Label("Share", systemImage: "square.and.arrow.up")
        }
        
    }
    
    
    init(url: URL) {
        self.url = url
    }
    }

    
    
    
  


#Preview {
    ExportView(url: URL(filePath: "")!)
}
