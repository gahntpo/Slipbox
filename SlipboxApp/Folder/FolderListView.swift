//
//  FolderListView.swift
//  SlipboxApp
//
//  Created by Karin Prater on 06.12.20.
//

import SwiftUI
import CoreData

struct FolderListView: View {
    
    @EnvironmentObject var nav: NavigationStateManager
    
    @State private var makeNewFolderStatus: FolderEditorStatus? = nil
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var folders: FetchedResults<Folder>

    var body: some View {
        VStack {
            HStack {
                Text("Folder").font(.title)
                
                Spacer()
                
                Button(action: {
                    makeNewFolderStatus = FolderEditorStatus.addFolder
                }, label: {
                    Image(systemName: "plus")
                    
                })
            }.padding([.horizontal, .top])
            
            
            
            List {
                ForEach(folders) { folder in
                    
                    RecursiveFolderView(folder: folder)

                }.listRowInsets(.init(top: 0, leading: 0, bottom: 1, trailing: 0))
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(item: $makeNewFolderStatus) { status in
            FolderEditorView(editorStatus: status, contextFolder: nav.selectedFolder)
                .environment(\.managedObjectContext, context)
                .environmentObject(nav)
            
        }
//        .sheet(isPresented: $makeNewFolder, content: {
//FolderEditorView(
//            FolderEditorView(parentFolder: nil, referenceFolder: nil)
//                .environment(\.managedObjectContext, context)
//        })
    }
}

struct FolderListView_Previews: PreviewProvider {
    static var previews: some View {
        
    FolderListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(NavigationStateManager())
        .frame(width: 200)
    }
   
}


