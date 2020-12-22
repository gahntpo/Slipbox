//
//  KeywordListView.swift
//  SlipboxApp
//
//  Created by Karin Prater on 11.12.20.
//

import SwiftUI

struct KeywordListView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(fetchRequest: Keyword.fetch(.all)) var keywords
    
    @State private var newKeyword: Bool = false
    
    var body: some View {
        
        VStack {
            
            HStack {
            Text("Keywords").font(.title)
                Spacer()
                Button(action: {
                    newKeyword.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }.padding([.top, .horizontal])
            
            List {
                ForEach(keywords) { keyword in
                    KeywordRow(keyword: keyword)
                }
            }
        }
        .sheet(isPresented: $newKeyword, content: {
            KeywordEditorView()
                .environment(\.managedObjectContext, context)
        })
      
    }
}

struct KeywordListView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
            .environmentObject(NavigationStateManager())
        
    }
}
