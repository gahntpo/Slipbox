//
//  AppDelegate.swift
//  SlipboxApp
//
//  Created by Karin Prater on 02.12.20.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var windowContents = [WindowContentView]()
    var prefWindow: PreferenceWindow?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
      //  UnitTestHelpers.deletesAllNotes(context: PersistenceController.shared.container.viewContext)
       makeEmptWindow()
       
    }
    
    func makeEmptWindow()  {
        let newWindow = WindowContentView(nav: NavigationStateManager())
         windowContents.append(newWindow)
    }
    
    func makeWindow(for note: Note) {
        
        if let openWindow = windowContents.first(where: { $0.nav.selectedNote == note }), openWindow.windowDelegate.windowIsOpen {
            openWindow.window.makeKeyAndOrderFront(nil)
        }else {
            
            let nav = NavigationStateManager()
            nav.selectedNote = note
            nav.selectedFolder = note.folder
            nav.showNotesColumn = false
            nav.showFolderColumn = false
            nav.showKeyColumn = false
            
            let window = WindowContentView(nav: nav)
            windowContents.append(window)
        }
            
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //MARK: - menu
    @IBAction func newWindw(_ sender: NSMenuItem) {
        makeEmptWindow()
    }
    
    @IBAction func newNote(_ sender: NSMenuItem) {
        NotificationCenter.default.post(name: NSNotification.Name.newNote, object: nil)
    }
    
    @IBAction func newFolder(_ sender: NSMenuItem) {
        NotificationCenter.default.post(name: NSNotification.Name.newFolder, object: nil)
    }
    
    @IBAction func preference(_ sender: NSMenuItem) {
        if let old = prefWindow, old.windowDelegate.windowIsOpen {
            old.window.makeKeyAndOrderFront(nil)
        }else {
            prefWindow = PreferenceWindow()
        }
             
    }
    

    // MARK: - Core Data stack
    let persistenceController = PersistenceController.shared

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistenceController.container.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistenceController.container.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistenceController.container.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}

