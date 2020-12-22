//
//  NoteSearchView.swift
//  SlipboxApp
//
//  Created by Karin Prater on 13.12.20.
//

import SwiftUI
import CoreData

struct NoteSearchView: View {
    
    @EnvironmentObject var nav: NavigationStateManager
    
    init(pred: NSPredicate) {
        let request = Note.fetch(pred)
        self._notes = FetchRequest(fetchRequest: request)
    }
    
    @FetchRequest(fetchRequest: Note.fetch(NSPredicate.all)) private var notes: FetchedResults<Note>
    
    var body: some View {
        VStack(spacing: 0) {
        Text("Your search results")
            .font(.title)
            .foregroundColor(.white)
            .padding([.top, .horizontal])
            .frame(maxWidth: .infinity)
            .background(Color.black)
            
            List {
                
                ForEach(notes) { note in
                    NoteRow(note: note)
                        .onTapGesture {
                            nav.selectedNote = note
                        }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 1, trailing: 0))
                
            }
        }.onAppear {
            nav.selectedNote = notes.first
        }
    }
}

struct NoteSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NoteSearchView(pred: .all)
            .environmentObject(NavigationStateManager())
    }
}
