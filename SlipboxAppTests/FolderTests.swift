//
//  FolderTests.swift
//  SlipboxAppTests
//
//  Created by Karin Prater on 06.12.20.
//

import XCTest
@testable import SlipboxApp

class FolderTests: XCTestCase {

    var controller: PersistenceController!
    
    var context: NSManagedObjectContext {
        return controller.container.viewContext
    }
    
    override func setUp() {
        super.setUp()
        controller = PersistenceController.empty
    }
    
    override func tearDown() {
        super.tearDown()
        
        UnitTestHelpers.deletesAll(container: controller.container)
    }

    func testAddFolder() {
        let folder = Folder(name: "new", context: context)
        
        XCTAssertNotNil(folder.uuid)
        XCTAssertNotNil(folder.creationDate, "folder needs to have a creation date")
        XCTAssertTrue(folder.notes.count == 0, "created a folder with no notes")
        XCTAssertTrue(folder.order == 1, "folder needs order 1")

        let folder2 = Folder(name: "second", context: context)
        XCTAssertTrue(folder2.order == 2, "folder order higher than first folder")
    }
    
    func testAddSubfolder() {
        let parent = Folder(name: "parent", context: context)
        let child1 = Folder(name: "child1", context: context)
        let child2 = Folder(name: "child2", context: context)
        parent.add(subfolder: child1)
        parent.add(subfolder: child2)
        XCTAssertTrue(child1.order == 1)
        XCTAssertTrue(child2.order == 2)
        
    }
    
    //NEW: test add folder after other folder
    func testAddFolderAfterOther() {
        let parent = Folder(name: "parent", context: context)
        let child1 = Folder(name: "child1", context: context)
        let child2 = Folder(name: "child2", context: context)
        let child3 = Folder(name: "child1", context: context)
        
        parent.add(subfolder: child1)
        parent.add(subfolder: child2)
        
        parent.add(subfolder: child3, at: child1.order)
        let order1 = child1.order
        let order2 = child2.order
        let order3 = child3.order
        
        XCTAssertTrue(child1.order == 1)
        XCTAssertTrue(child3.order == 2)
        XCTAssertTrue(child2.order == 3)
        
    }
    
   
    func testAddNoteToFolder() {
        let notesTitle = "new"
        let folder = Folder(name: notesTitle, context: context)
        let note = Note(title: "add me", context: context)
        
        note.folder = folder
        
        
        XCTAssertTrue(note.folder?.name == notesTitle)
        XCTAssertNotNil(note.folder, "note should have been added to a folder")
        XCTAssertTrue(folder.notes.count == 1)

    }
    
    
    func testAddMultipleNotes() {
        let folder = Folder(name: "folder", context: context)
        let note1 = Note(title: "first", context: context)
        let note2 = Note(title: "second", context: context)
        
        folder.add(note: note1)
        folder.add(note: note2)

       XCTAssertTrue(folder.notes.count == 2)

        XCTAssertTrue(folder.notes.sorted().first == note1)
        
        XCTAssertTrue(folder.notes.sorted().last == note2)
 
    }
    
    
    func testAddNoteAtIndex() {
        let folder = Folder(name: "folder", context: context)
        let note1 = Note(title: "first", context: context)
        let note2 = Note(title: "second", context: context)
        let note3 = Note(title: "third", context: context)
        
        folder.add(note: note1)
        folder.add(note: note2)
        folder.add(note: note3, at: 0)
        
        XCTAssertTrue(folder.notes.sorted().first == note3)
        XCTAssertTrue(folder.notes.sorted().last == note2)
 
    }
    
    func testFetchFolder() {
        
        let folder = Folder(name: "folder", context: context)
        
        let request = Folder.fetch(.all)
        
        let result = try? context.fetch(request)
        
        XCTAssertTrue(result?.count == 1)
        
    }
    
    func testTopFolders() {
        let folder = Folder(name: "folder", context: context)
        let parent = Folder(name: "parent", context: context)
        folder.parent = parent
        
        let request = Folder.fetch(.all)
        let result = try? context.fetch(request)
        XCTAssertTrue(result?.count == 2)
        
        let parentFetch = Folder.topFolderFetch()
        let parents = try? context.fetch(parentFetch)
        XCTAssertTrue(parents?.count == 1)
        XCTAssertTrue(parents?.first == parent)
        
    }
    
    
    
    
    
    //TODO test fetch all folders without parent folder
    
}





