//
//  ContentView.swift
//  SlipboxApp
//
//  Created by Karin Prater on 02.12.20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var nav: NavigationStateManager
    
    var body: some View {
        
        HSplitView {
            
            if nav.showKeyColumn {
                KeywordListView()
                    .frame(minWidth: 150, idealWidth: 150, maxWidth: 200)
            }
            if nav.showFolderColumn {
                FolderListView()
                    .frame(minWidth: 150, idealWidth: 150, maxWidth: 300)
            }
            
            
            if nav.predicate() == nil {
                if nav.showNotesColumn {
                    NoteListView(folder: nav.selectedFolder, selectedNote: $nav.selectedNote)
                        .frame(minWidth: 150, idealWidth: 150, maxWidth: 300)
                }
            } else {
                NoteSearchView(pred: nav.predicate()!)
                    .frame(minWidth: 150, idealWidth: 150, maxWidth: 300)
            }

            
            if nav.selectedNote != nil {
                NoteView(note: nav.selectedNote!)
            }else {
                Text("please select a note")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
  
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(NavigationStateManager())
    }
}

