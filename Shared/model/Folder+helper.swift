//
//  Folder+helper.swift
//  SlipboxApp
//
//  Created by Karin Prater on 06.12.20.
//

import Foundation
import CoreData

extension Folder {
    
    //TODO: init
    
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        
        let requeset = Folder.topFolderFetch()
        let result = try? context.fetch(requeset)
        let maxFolder = result?.max(by: { $0.order < $1.order })
        self.order = (maxFolder?.order ?? 0) + 1
    }
    
    override public func awakeFromInsert() {
        setPrimitiveValue(Date(), forKey: NoteProperties.creationDate)
        setPrimitiveValue(UUID(), forKey: NoteProperties.uuid)
    }
    
    var uuid: UUID {
        get { uuid_ ?? UUID() }
        set { uuid_ = newValue }
    }
    
    var creationDate: Date {
        get { return creationDate_ ?? Date() }
        set { creationDate_ = newValue }
    }
    
    var name: String {
        get { return name_ ?? "" }
        set { name_ = newValue  }
    }
    
    var notes: Set<Note> {
        get { notes_ as? Set<Note> ?? [] }
       // set { notes_ = newValue as NSSet }
    }
    
    var children: Set<Folder> {
        get { children_ as? Set<Folder> ?? [] }
        set { children_ = newValue as NSSet  }
    }
    
    func add(note: Note, at index: Int32? = nil) {
        let oldNotes = self.notes.sorted()
      
        if let index = index {
            note.order = index + 1
            
            let changeNotes = oldNotes.filter { $0.order > index}
            for note in changeNotes {
                note.order += 1
            }
            
        } else {
            note.order = (oldNotes.last?.order ?? 0) + 1
        }
        note.folder = self
       // self.notes_?.adding(note)
    }
    
    //MARK: fetch request
    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Folder> {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.creationDate, ascending: false)]
        
        request.predicate = predicate
        return request
    }
    
    static func topFolderFetch() -> NSFetchRequest<Folder> {
        let request = NSFetchRequest<Folder>(entityName: "Folder")
        request.sortDescriptors = [NSSortDescriptor(key: FolderProperties.order, ascending: true)]
        
        let format = FolderProperties.parent + " = nil"
        request.predicate = NSPredicate(format: format)
        return request
    }
    
    static func fetch(id: String?, in context: NSManagedObjectContext) -> Folder? {
        guard let id = id, let uuid = UUID(uuidString: id) else {
            return nil
        }
        let request = Folder.fetch(NSPredicate(format: "%K == %@", FolderProperties.uuid, uuid as CVarArg))
        if let folders = try? context.fetch(request),
           let folder = folders.first {
            return folder
        }else {
            return nil
        }
    }
    
    //MARK: - delete
    static func delete(_ folder: Folder)  {
        if let context =  folder.managedObjectContext {
            context.delete(folder)
        }
    }
    
    //MARK: - preview helpers
    static func nestedFolder(context: NSManagedObjectContext) -> Folder {
        let parent = Folder(name: "parent", context: context)
        let child1 = Folder(name: "child1", context: context)
        let child2 = Folder(name: "child2", context: context)
        let child3 = Folder(name: "child3", context: context)
        
        //child1.parent = parent
        //TODO: add children
        parent.add(subfolder: child1)
        parent.add(subfolder: child2)
        child2.add(subfolder: child3)
        return parent
    }
}

//MARK: - comparable
extension Folder: Comparable {
    public static func < (lhs: Folder, rhs: Folder) -> Bool {
        lhs.order < rhs.order
    }

}


//MARK:- define my string properties

struct FolderProperties {
    static let uuid = "uuid_"
    static let creationDate = "creationDate_"
    static let name = "name_"
    static let order = "order"
    
    static let notes = "notes_"
    static let parent = "parent"
    static let children = "children_"
}
