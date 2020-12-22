//
//  NoteView.swift
//  SlipboxApp
//
//  Created by Karin Prater on 03.12.20.
//

#if os(iOS)
import MobileCoreServices
#endif

import SwiftUI
import CoreData

struct NoteView: View {
    
    @EnvironmentObject var nav:  NavigationStateManager
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @ObservedObject var note: Note
    
    @State private var isDropTargeted: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Picker(selection: $note.status, label: Text("Status"), content: {
                ForEach(Status.allCases, id: \.self) { status in
                    Text(status.rawValue)
                }
            }).pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 250)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            TextField("notes title", text: $note.title)
                //.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            #if os(macOS)
            //TextEditor(text: $note.bodyText)
            TextViewWrapper(note: note)
            #endif
            
            OptionalImage(data: note.img)
                    .contextMenu(ContextMenu(menuItems: {
                        Button(action: {
                            note.img = nil
                        }, label: {
                            Text("Remove Image")
                        })
                    }))
            
          
           
            HStack {
                Text("Keywords:")
                
                ForEach(note.keywords.sorted()) { key in
                    Text(key.name)
                }
            }
            
            HStack(alignment: .top) {
                Text("linked Notes:")
                VStack(alignment: .leading) {
                    ForEach(note.linkedNotes.sorted()) { link in
                        Button(action: {
                            nav.selectedNote = link
                            nav.selectedFolder = link.folder
                        }, label: {
                            Text(link.title).bold()
                        }).buttonStyle(PlainButtonStyle())
                        .foregroundColor(.accentColor)
                        .contextMenu {
                            #if os(macOS)
                            Button {
                               if let app = NSApplication.shared.delegate as? AppDelegate {

                                app.makeWindow(for: link)

                                }

                            } label: {
                                Text("open in new window")
                            }
                            #endif
                            
                            //TODO
                            Button {
                                
                            } label: {
                                Text("Delete link")
                            }


                        }
                        
                    }
                }
            }
            
        }.padding()
        .background(isDropTargeted ? Color.gray : Color.clear)
        .onDrop(of: ["public.url", "public.file-url", kUTTypeData as String, dragTypeID], isTargeted: $isDropTargeted, perform: { providers in
            note.handleDrop(providers: providers)
        })
    }
    
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(note: Note.defaultNote(context:  PersistenceController.preview.container.viewContext))
            .frame(width: 400, height: 400)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/))
        
            .environmentObject(NavigationStateManager())
    }
}
