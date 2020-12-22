//
//  RecursiveFolderView.swift
//  SlipboxApp
//
//  Created by Karin Prater on 07.12.20.
//

import SwiftUI

struct RecursiveFolderView: View {
    
    @ObservedObject var folder: Folder
    
    @EnvironmentObject var nav: NavigationStateManager
    
    @State private var showSubfolders: Bool = true
    
    var body: some View {
        Group {
            
            HStack {
                Text("\(folder.order)").bold()
                FolderRow(folder: folder)
                Spacer()
                
                if folder.children.count > 0 {
                    Button(action: {
                        withAnimation {
                            showSubfolders.toggle()
                        }
                        
                    }, label: {
                        Image(systemName: "chevron.right")
                            .rotationEffect(.init(degrees: showSubfolders ? 90 : 0))
                        
                    }).buttonStyle(PlainButtonStyle())
                }
            }
            
            if showSubfolders {
                ForEach(folder.children.sorted(), content: { child in
                    
                    RecursiveFolderView(folder: child).padding(.leading)
                })
               
            }
        }
    }
}

struct RecursiveFolderView_Previews: PreviewProvider {
    static var previews: some View {
        
        List {
        RecursiveFolderView(folder: Folder.nestedFolder(context: PersistenceController.preview.container.viewContext))
        }
        .frame(width: 200)
        .environmentObject(NavigationStateManager())
        
        
    }
}
