//
//  Note+helper.swift
//  SlipboxApp
//
//  Created by Karin Prater on 02.12.20.
//

import Foundation
import CoreData

extension Note {
    
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        try? context.save()
    }
    
    override public func awakeFromInsert() {
        setPrimitiveValue(Date(), forKey: NoteProperties.creationDate)
        setPrimitiveValue(UUID(), forKey: NoteProperties.uuid)
        setPrimitiveValue(Status.draft.rawValue, forKey: NoteProperties.status)
    }
    
    var title: String {
        get { return title_ ?? "" }
        set { title_ = newValue  }
    }
    
    var creationDate: Date {
        get { return creationDate_ ?? Date() }
        set { creationDate_ = newValue }
    }
    
    var bodyText: String {
        get { return bodyText_ ?? "" }
        set { bodyText_ = newValue }
    }
    
    var formattedText: NSAttributedString {
        get {
            if let data = formattedText_ {
                return data.toAttributedString()
            }else {
                return NSAttributedString(string: "")
            }
        }
        set {
            bodyText_ = newValue.string
            formattedText_ = newValue.toData()
        }
    }
    
    var uuid: UUID {
        get { uuid_ ?? UUID() }
        set { uuid_ = newValue }
    }
    
    var status: Status {
        get { return Status(rawValue: status_ ?? "") ?? Status.draft }
        set { status_ = newValue.rawValue  }
    }
    
    var linkedNotes: Set<Note> {
        get { linkedNotes_ as? Set<Note> ?? [] }
        set { linkedNotes_ = newValue as NSSet }
    }
    
    var backlinks: Set<Note> {
        get { backlinks_ as? Set<Note> ?? [] }
    }
    
    var keywords: Set<Keyword> {
        get { keywords_ as? Set<Keyword> ?? [] }
        set { keywords_ = newValue as NSSet }
    }
    
    
    
    //MARK: - fetch helpers
    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Note> {
        let request = NSFetchRequest<Note>(entityName: "Note")
        request.sortDescriptors = [NSSortDescriptor(key: NoteProperties.order, ascending: true)]
        
        request.predicate = predicate
        return request
    }
    
    static func fetch(id: String?, in context: NSManagedObjectContext) -> Note? {
    
        guard let id = id, let uuid = UUID(uuidString: id) else {
            return nil
        }
        
        let request = Note.fetch(NSPredicate(format: "%K == %@", NoteProperties.uuid, uuid as CVarArg))
        if let notes = try? context.fetch(request),
           let note = notes.first {
            return note
        }else {
            return nil
        }
    }

    
    static func delete(note: Note) {
       //TODO
        if let context =  note.managedObjectContext {
            context.delete(note)
        }
    }
    
    //MARK: - preview helper properties
    static let defaultText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

    static func defaultNote(context: NSManagedObjectContext)-> Note {
        let note = Note(title: "lorum ipsum", context: context)
        note.formattedText = NSAttributedString(string: Note.defaultText)

        let link1 = Note(title: "linked note 1", context: context)
        let link2 = Note(title: "linked note 2", context: context)
        note.linkedNotes.insert(link1)
        note.linkedNotes.insert(link2)
        
        let keyword1 = Keyword(name: "awesome", context: context)
        let keyword2 = Keyword(name: "stuff", context: context)
        
        note.keywords.insert(keyword1)
        note.keywords.insert(keyword2)
        
        return note
    }
}

//MARK: - sort notes for showing in list
extension Note: Comparable {
    public static func < (lhs: Note, rhs: Note) -> Bool {
        lhs.order < rhs.order
    }
}

//MARK: - property names as strings

struct NoteProperties {
    static let creationDate = "creationDate_"
    static let title = "title_"
    static let bodyText = "bodyText_"
    static let formattedText = "formattedText_"
    static let status = "status_"
    static let uuid = "uuid_"
    static let img = "img"
    
    static let folder = "folder"
    static let order = "order"
    
    static let linkedNotes = "linkedNotes_"
    static let backlinks = "backlinks_"
    
    static let keywords = "keywords_"
}
