//
//  WindowContentView.swift
//  SlipboxApp
//
//  Created by Karin Prater on 12.12.20.
//

import SwiftUI

struct WindowContentView: View {
    
    var window: NSWindow!
    @ObservedObject var nav: NavigationStateManager
    
    @State var windowDelegate: CustomWindowDelegate
    
    init(nav: NavigationStateManager) {
        self.nav = nav
        
        self._windowDelegate = State(initialValue: CustomWindowDelegate(nav: nav))
        windowDelegate.windowIsOpen = true
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        window.delegate = windowDelegate
        
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: self)
        window.makeKeyAndOrderFront(nil)
        
        let toolbar =  AppToolbar(identifier: .init("Default"))
        toolbar.nav = nav
        window.toolbar = toolbar
        window.title = "Slipbox app"
    }
    
    var body: some View {
        
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .environmentObject(nav)
//            .brightness(nav.isKey ? 0 : -0.5)
        
    }
    
    class CustomWindowDelegate: NSObject, NSWindowDelegate {
        
        let nav: NavigationStateManager
        
        var windowIsOpen = false
        
        init(nav: NavigationStateManager) {
            self.nav = nav
        }
        
        func windowDidBecomeKey(_ notification: Notification) {
            nav.isKey = true
        }
        
        func windowDidResignKey(_ notification: Notification) {
            nav.isKey = false
        }
        
        func windowWillClose(_ notification: Notification) {
            windowIsOpen = false
        }
    }
    
    
}

struct WindowContentView_Previews: PreviewProvider {
    static var previews: some View {
        WindowContentView(nav: NavigationStateManager())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
    }
}
