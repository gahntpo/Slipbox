//
//  Note+handelDrop.swift
//  SlipboxApp
//
//  Created by Karin Prater on 16.12.20.
//

import Foundation
import CoreData

extension Note {
    
    func handleMove(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadObjects(ofType: DataTypeDragItem.self) { (item) in
            if let context = self.managedObjectContext ,
                let dropedNote = Note.fetch(id: item.id, in: context),
               self != dropedNote {
                dropedNote.folder = nil
                self.folder?.add(note: dropedNote, at: self.order - 1)
            }
        }
        return found
    }
    
    
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        
        var found = providers.loadObjects(ofType: URL.self) { item in
        
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: item.absoluteURL) {
                    DispatchQueue.main.async {
                        self.img = data
                    }
                }
                if let data = try? Data(contentsOf: item.imageURL) {
                    DispatchQueue.main.async {
                        self.img = data
                    }
                }
            }
         
        }
        if !found {
            found = providers.loadObjects(ofType: DataTypeDragItem.self, using: { (item) in
               if let id = item.id,
                  let uuid = UUID(uuidString: id),
                  let type = item.type,
                  let dataType = DataType.type(string: type),
                  let context = self.managedObjectContext {
                
                switch dataType {
                case .note:
                    
                    if let dropedNote = Note.fetch(id: item.id, in: context),
                       dropedNote != self {
                        self.linkedNotes.insert(dropedNote)
                    }
                    
                case .keyword:
                    if let dropedKeyword = Keyword.fetch(id: uuid, context: context) {
                        self.keywords.insert(dropedKeyword)
                    }
                default:
                    return
                }

               }
            })
            
        }
        
        return found
    }
    
    
    
}
