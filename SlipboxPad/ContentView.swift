//
//  ContentView.swift
//  SlipboxPad
//
//  Created by Karin Prater on 02.12.20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var nav: NavigationStateManager

    var body: some View {
        
        NavigationView {
            FolderListView()
            
            NoteListView(folder: nav.selectedFolder, selectedNote: $nav.selectedNote)
            
            if nav.selectedNote != nil {
            NoteView(note: nav.selectedNote!)
            }
            
        }
        
        
        
    }


}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
         ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(NavigationStateManager())
    }
}
