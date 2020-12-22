//
//  PreferenceWindow.swift
//  SlipboxApp
//
//  Created by Karin Prater on 13.12.20.
//

import SwiftUI

struct PreferenceWindow: View {
    
    var window: NSWindow!
    @State var windowDelegate: CustomWindowDelegate
    
    init() {
        self._windowDelegate = State(initialValue: CustomWindowDelegate())
        windowDelegate.windowIsOpen = true
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        
        window.delegate = windowDelegate
        window.delegate = windowDelegate
        
        window.center()
        window.setFrameAutosaveName("Preference Window")
        window.contentView = NSHostingView(rootView: self)
        window.makeKeyAndOrderFront(nil)
        window.title = "Preferences"
        
    }
    
   
    
    var body: some View {
        PreferenceContentView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    class CustomWindowDelegate: NSObject, NSWindowDelegate {
        
        var windowIsOpen = false
        
        func windowWillClose(_ notification: Notification) {
            windowIsOpen = false
        }
    }
}

struct PreferenceWindow_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceWindow()
    }
}
