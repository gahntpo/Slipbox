//
//  AppToolbar.swift
//  SlipboxApp


import Cocoa

class AppToolbar: NSToolbar, NSToolbarDelegate, NSSearchFieldDelegate {

    var searchTextField: NSView!
    
    var keywordColumnToggle: NSView!
    var folderColumnToggle: NSView!
    var noteColumnToggle: NSView!
    
    var statusPicker: NSView!
    
    var keyImage: NSImage {
      let image = nav.showKeyColumn ? #imageLiteral(resourceName: "hashtagFull") : #imageLiteral(resourceName: "hashtag")
        image.size = CGSize(width: 20, height: 20)
        return image
    }
    var folderImage: NSImage {
        let image = nav.showFolderColumn ?  #imageLiteral(resourceName: "folderFull") : #imageLiteral(resourceName: "folder")
        image.size = CGSize(width: 20, height: 18)
        return image
    }
    var noteImage: NSImage {
        let image = nav.showNotesColumn ?  #imageLiteral(resourceName: "noteFull") : #imageLiteral(resourceName: "note")
        image.size = CGSize(width: 16, height: 20)
        return image
    }
    
    
    var nav: NavigationStateManager = NavigationStateManager() {
        didSet {
            (keywordColumnToggle as? NSButton)?.image = keyImage
            (folderColumnToggle as? NSButton)?.image = folderImage
            ( noteColumnToggle as? NSButton)?.image = noteImage
        }
    }
    
    
    
    
    override init(identifier: NSToolbar.Identifier) {
        super.init(identifier: identifier)
        //make AppToolbar the NSToolbarDelegate
        delegate = self
        
        //setup all the views you use in the toolbaritems
        let field = NSSearchField(string: "")
        field.delegate = self
        searchTextField = field
        
        keywordColumnToggle = NSButton(image: keyImage, target: self, action: #selector(keyToggleChange(_:)))
        folderColumnToggle = NSButton(image: folderImage, target: self, action: #selector(folderToggleChange(_:)))
        noteColumnToggle = NSButton(image: noteImage, target: self, action: #selector(noteToggleChange(_:)))
        
        let picker = NSPopUpButton(frame: NSRect.init(x: 0, y: 0, width: 100, height: 100), pullsDown: false)
        picker.removeAllItems()
        
        let allItem = NSMenuItem(title: "all", action: #selector(selectAll), keyEquivalent: "l")
        allItem.target = self
        picker.menu?.insertItem(allItem, at: 0)
        let draftItem = NSMenuItem(title: Status.draft.rawValue, action: #selector(selectDraft), keyEquivalent: "d")
        draftItem.target = self
        picker.menu?.insertItem(draftItem, at: 1)
        let reviewItem = NSMenuItem(title: Status.review.rawValue, action: #selector(selectRev), keyEquivalent: "r")
        reviewItem.target = self
        picker.menu?.insertItem(reviewItem, at: 2)
        let archItem = NSMenuItem(title: Status.archived.rawValue, action: #selector(selectArch), keyEquivalent: "a")
        archItem.target = self
        picker.menu?.insertItem(archItem, at: 3)
        
        self.statusPicker = picker

        
        self.allowsUserCustomization = true
        self.autosavesConfiguration = true
        self.displayMode = .iconOnly
    }
    
    //MARK: - construct toolbar
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        // allowed default elements
        return [.search, .keys, .folder, .notes, .status, .print, .showColors, .space, .flexibleSpace]
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        // set toolbar elements
        return   [.keys, .folder, .notes,  .flexibleSpace, .search, .space, .status ,.space]
    }
    
    //MARK: - get toolbaritem for each identifier
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem = NSToolbarItem()
        
        if itemIdentifier == NSToolbarItem.Identifier.search {
            toolbarItem = NSToolbarItem(itemIdentifier: .search)
            toolbarItem.view = searchTextField
            toolbarItem.label = "search notes"
            toolbarItem.paletteLabel = "Search"
            toolbarItem.toolTip = "search term for your notes"
            toolbarItem.target = self
        } else if itemIdentifier == NSToolbarItem.Identifier.keys {
            toolbarItem = NSToolbarItem(itemIdentifier: .keys)
            toolbarItem.view = keywordColumnToggle
            toolbarItem.label = "keywords"
            toolbarItem.toolTip = "show/hide keyword column"
            toolbarItem.target = self
            
        } else if itemIdentifier == NSToolbarItem.Identifier.folder {
            toolbarItem = NSToolbarItem(itemIdentifier: .folder)
            toolbarItem.view = folderColumnToggle
            toolbarItem.toolTip = "show/hide folder column"
            toolbarItem.label = "folders"
            toolbarItem.target = self
            
        } else if itemIdentifier == NSToolbarItem.Identifier.notes {
            toolbarItem = NSToolbarItem(itemIdentifier: .notes)
            toolbarItem.view = noteColumnToggle
            toolbarItem.label = "notes"
            toolbarItem.toolTip =  "show/hide notes column"
            toolbarItem.target = self
        }else if itemIdentifier == NSToolbarItem.Identifier.status {
            toolbarItem = NSToolbarItem(itemIdentifier: .status)
            toolbarItem.view = statusPicker
            toolbarItem.label = "notes status"
            toolbarItem.toolTip = "search notes for status"
            toolbarItem.target = self
        }
        
        
        return toolbarItem
    }
    
    //MARK: - control action
    func controlTextDidChange(_ obj: Notification) {
        let text = (obj.object as? NSTextField)?.stringValue
        nav.searchText = text ?? ""
    }
    
    @objc func keyToggleChange(_ sender: NSButton) {
        nav.showKeyColumn.toggle()
        sender.image = keyImage
    }
    
    @objc func folderToggleChange(_ sender: NSButton) {
        nav.showFolderColumn.toggle()
        sender.image = folderImage
    }
    
    @objc func noteToggleChange(_ sender: NSButton) {
        nav.showNotesColumn.toggle()
        sender.image = noteImage
    }
    
    //picker
    @objc func selectAll() {
        nav.searchStatus = nil
    }
    
    @objc func selectDraft() {
        nav.searchStatus = .draft
    }
    @objc func selectArch() {
        nav.searchStatus = .archived
    }
    @objc func selectRev() {
        nav.searchStatus = .review
    }
}

//MARK: - identifiers
private extension NSToolbarItem.Identifier {
    static let search: NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "Search")
    
    static let notes:  NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "Note")
    static let keys:  NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "Keyword")
    static let folder:  NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "Folder")
    
    static let status:  NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "status")
}
