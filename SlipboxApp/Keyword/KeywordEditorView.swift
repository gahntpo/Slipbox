//
//  KeywordEditorView.swift
//  SlipboxApp
//
//  Created by Karin Prater on 11.12.20.
//

import SwiftUI

struct KeywordEditorView: View {
    @Environment(\.managedObjectContext) var context
    
    @Environment(\.presentationMode) var presentation
    
    @State private var name: String = ""
    
    var body: some View {
        
        VStack(spacing: 30) {
            Text("Create new keyword").font(.title)
            
            TextField("keyword", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 200)
            
            HStack {
                Button(action: {
                    presentation.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                })
                
                Button(action: {
                   _ = Keyword(name: name, context: context)
                    presentation.wrappedValue.dismiss()
                }, label: {
                    Text("Create")
                }).disabled(name.count == 0)
            }
            
        }.padding().padding()
        
    }
}

struct KeywordEditorView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordEditorView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
