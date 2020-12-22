//
//  UnitTestHelpers.swift
//  SlipboxApp
//
//  Created by Karin Prater on 03.12.20.
//

import Foundation
import CoreData

struct UnitTestHelpers {
    
    static func deletesAllNotes(context: NSManagedObjectContext) {
        let request = Note.fetch(.all)
        if let result = try? context.fetch(request) {
        for r in result {
            context.delete(r)
        }}
    }
    
    static func deletesAllFolders(context: NSManagedObjectContext) {
        let request = Folder.fetch(.all)
        if let result = try? context.fetch(request) {
        for r in result {
            context.delete(r)
        }}
    }
    
    static func deleteAllkeywords(context: NSManagedObjectContext) {
        let rquest = Keyword.fetch(.all)
        if let result = try? context.fetch(rquest) {
            for r in result {
                context.delete(r)
            }
        }
        
    }
    
    static func deletesAll(container: NSPersistentCloudKitContainer) {
        
        //UnitTestHelpers.deletesAllNotes(context: container.viewContext)
        UnitTestHelpers.deletesAllFolders(context: container.viewContext)
        UnitTestHelpers.deleteAllkeywords(context: container.viewContext)
        
    }
    
    
    static func deleteBatchRequest(entity: String, container: NSPersistentCloudKitContainer) {
            
            let context = container.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
        do { try container.persistentStoreCoordinator.execute(deleteRequest, with: context)
        }catch {
            print("error \(error.localizedDescription)")
        }
        
    }
    
}
