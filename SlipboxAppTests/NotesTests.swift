//
//  NotesTests.swift
//  SlipboxAppTests
//
//  Created by Karin Prater on 03.12.20.
//

import XCTest
@testable import SlipboxApp


class NotesTests: XCTestCase {

    var controller: PersistenceController!
    
    override func setUp() {
        super.setUp()
        controller = PersistenceController.empty
    }
    
    override func tearDown() {
        super.tearDown()
        UnitTestHelpers.deletesAllNotes(context: controller.container.viewContext)
//        UnitTestHelpers.deletesAll(container:  controller.container)
        controller = nil
    }
    
    func testNoteBasicInit() {
        //testing the code that I added in Note awakeFromInsert()
        let context = controller.container.viewContext
        let note = Note(context: context)
        XCTAssertNotNil(note.creationDate, "note should have a date")
        XCTAssertNotNil(note.uuid, "note needs to have unique identifier")
    }
    
    func testAddNote() {
        let context = controller.container.viewContext
        let title = "new"
        let note = Note(title: title, context: context)
        
        XCTAssertTrue(note.title == title)
        
        XCTAssertNotNil(note.creationDate, "note should have a date")
        XCTAssertNotNil(note.uuid, "note needs to have unique identifier")
    }
    
    
    func testUpdateNote() {
        let context = controller.container.viewContext
        let note = Note(title: "old", context: context)
        note.title = "new"
        
        XCTAssertTrue(note.title == "new")
        XCTAssertFalse(note.title == "old", "note's title not correctly updated")
        
    }
    
    func testFetchNotes() {
        let context = controller.container.viewContext
        
        let note = Note(title: "fetch me", context: context)
        
        let request = Note.fetch(NSPredicate.all)
        
        let fechtedNotes = try? context.fetch(request)
        
        XCTAssertTrue(fechtedNotes!.count == 1, "need to have at least one note")
        
        XCTAssertTrue(fechtedNotes?.first == note, "new note should be fetched")
    }
    
    func testSave() {
        //asynchronous testing
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: controller.container.viewContext) { _ in
            return true
        }
        
        controller.container.viewContext.perform {
            let note = Note(title: "title", context: self.controller.container.viewContext)
            XCTAssertNotNil(note, "note should be there")
        }
        
        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error, "saving not complete")
        }
    }
    
    func testDeleteNote() {
        let context = controller.container.viewContext
        let note = Note(title: "note to delete", context: context)
        
        Note.delete(note: note)
        
        let request = Note.fetch(NSPredicate.all)
        let fechtedNotes = try? context.fetch(request)
        
        XCTAssertTrue(fechtedNotes!.count == 0, "core data fetch should be empty")
        
        XCTAssertFalse(fechtedNotes!.contains(note), "fetched notes should not contain my deleted note")
        
    }
    

    func testFetchId() {
        let context = controller.container.viewContext
        let note = Note(title: "title", context: context)
        
        let fetchedNote = Note.fetch(id: note.uuid.uuidString, in: context)
        
        XCTAssertNotNil(fetchedNote, "should be able to fetch this note")
        
        XCTAssertTrue(fetchedNote == note)
        
    }
}
