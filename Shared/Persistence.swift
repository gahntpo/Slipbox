//
//  Persistence.swift
//  SlipboxPad
//
//  Created by Karin Prater on 02.12.20.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()



    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        
        container = NSPersistentCloudKitContainer(name: "SlipboxApp")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        //TODO: - mention
        if !inMemory {
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
    
    
    
    //MARK: - Preview helper
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        
       //UnitTestHelpers.deletesAllNotes(container: result.container)
    
        for i in 0..<2 {
            let newItem = Note(title: "\(i) note", context: viewContext)
            newItem.bodyText = Note.defaultText
            let newFolder = Folder(name: "\(i) folder", context: viewContext)
            let newkeyword = Keyword(name: "\(i) keyword", context: viewContext)
        }
        Folder.nestedFolder(context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()
    
    //MARK: - unit tests
    static var empty: PersistenceController = {
        return PersistenceController(inMemory: true)
    }()
    

}
