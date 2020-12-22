//
//  NoteListView.swift
//  SlipboxApp
//
//  Created by Karin Prater on 03.12.20.
//

import SwiftUI
#if os(iOS)
import MobileCoreServices
#endif


struct NoteListView: View {
    
    init(folder: Folder?, selectedNote: Binding<Note?>) {
        self._selectedNote = selectedNote
        
        var predicate = NSPredicate.none
        if let folder = folder {
            //predicate = NSPredicate(format: "folder == %@ ", folder)
            predicate = NSPredicate(format: "%K == %@ ",NoteProperties.folder, folder)
        }
        self._notes = FetchRequest(fetchRequest: Note.fetch(predicate))
        self.folder = folder
    }
    
    let folder: Folder?
    
    @Binding var selectedNote: Note?
    
    @State private var shouldDeleteNote: Note? = nil
    
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject var nav: NavigationStateManager
    
    @FetchRequest(fetchRequest: Note.fetch(NSPredicate.all)) private var notes: FetchedResults<Note>

    
    var body: some View {
        VStack {
            HStack {
                Text("Notes")
                    .font(.title)
                
                Spacer()
                
                Button(action: {
                   createNewNote()
                    
                }, label: {
                    Image(systemName: "plus")
                    // Text("Add")
                }).disabled(folder == nil)
                
                .onReceive(NotificationCenter.default.publisher(for: .newNote), perform: { _ in
                    if nav.isKey {
                    createNewNote()
                    }
                })
                
                
                
            }.padding([.top, .horizontal])
            
            List {
                
                ForEach(notes) { note in
                    
                    NoteRow(note: note)
                        
                        .onTapGesture {
                            selectedNote = note
                        }
                        
                        .contextMenu(ContextMenu(menuItems: {

                            Button(action: {
                                self.shouldDeleteNote = note

                            }, label: {
                                Text("Delete")
                            })
                        }))
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 1, trailing: 0))

            }
            
            .alert(item: $shouldDeleteNote) { noteToDelete in
                deleteAlert(note: noteToDelete)
            }
        }
    }
    
    func deleteAlert(note: Note) -> Alert {
        Alert(title: Text("Are you sure to delete this note?"),
              message: nil,
              primaryButton: Alert.Button.cancel(),
              secondaryButton: Alert.Button.destructive(Text("Delete"), action: {
                if selectedNote == note {
                    selectedNote = nil
                }
                Note.delete(note: note)
              }))
    }
    
    func createNewNote() {
        let note = Note(title: "new note", context: context)
        
        folder?.add(note: note, at: selectedNote?.order)
        selectedNote = note
    }
    
}




struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        let request = Note.fetch(NSPredicate.all)
        let fechtedNotes = try? context.fetch(request)
        let folder = Folder(context: context)
        for note in fechtedNotes! {
            folder.add(note: note)
        }
        
        return NoteListView(folder: folder, selectedNote: .constant(fechtedNotes?.last))
            .environment(\.managedObjectContext, context)
    }
}


