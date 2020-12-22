//
//  Keyword+helper.swift
//  SlipboxApp
//
//  Created by Karin Prater on 11.12.20.
//

import Foundation
import CoreData

extension Keyword {
    
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
    }
    
    override public func awakeFromInsert() {
        setPrimitiveValue(UUID(), forKey: NoteProperties.uuid)
    }
    
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
   
    var uuid: UUID {
        get { uuid_ ?? UUID() }
        set { uuid_ = newValue }
    }
    
    var notes: Set<Note> {
        get { notes_ as? Set<Note> ?? [] }
        set { notes_ = newValue as NSSet }
    }
    
    //MARK: - fetch request
    
    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Keyword> {
        let request = NSFetchRequest<Keyword>(entityName: "Keyword")
        request.sortDescriptors = [NSSortDescriptor(key: KeywordProperties.name, ascending: true), NSSortDescriptor(key: KeywordProperties.uuid, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func fetch(id: UUID, context: NSManagedObjectContext) -> Keyword? {
        let request = Keyword.fetch(NSPredicate(format: "%K == %@", KeywordProperties.uuid, id as CVarArg))
        if let keys = try? context.fetch(request),
           let keyword = keys.first {
            return keyword
        }else {
            return nil
        }
    }
    
    //TODO: delete
    
    static func delete(keyword: Keyword) {
        if let context = keyword.managedObjectContext {
            try? context.delete(keyword)
        }
    }
}

//MARK: - sort notes for showing in list
extension Keyword: Comparable {
    public static func < (lhs: Keyword, rhs: Keyword) -> Bool {
        lhs.name < rhs.name
    }
}

//MARK: - string properties

struct KeywordProperties {
    static let name = "name_"
    static let uuid = "uuid_"
    
    static let notes = "notes_"
}
