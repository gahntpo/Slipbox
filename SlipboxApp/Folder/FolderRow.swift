//
//  FolderRow$.swift
//  SlipboxApp
//
//  Created by Karin Prater on 06.12.20.
//



import SwiftUI

struct FolderRow: View {
    
    @EnvironmentObject var nav: NavigationStateManager
    @ObservedObject var folder: Folder
    
    let selectedColor: Color = Color("selectedColor")
    let unSelectedColor: Color = Color("unselectedColor")
    let dropColor: Color = Color(.lightGray)
    
    @State private var makeNewFolderStatus: FolderEditorStatus? = nil
    @State private var showDelete: Bool = false
    @State private var edit: Bool = false
    @State private var dropStatus: DropStatus = .inActive

    var body: some View {
     
        VStack(spacing: 0) {
            
            RoundedRectangle(cornerRadius: 5)
                .fill(dropColor)
                .frame(height: dropStatus == .folderBefore ? 30 : 0)
                .padding(.bottom, 1)
                .animation(.easeInOut)
            
            ZStack {
                if edit {
                    TextField("title", text: $folder.name) { _ in
                    } onCommit: {
                        edit.toggle()
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }else {
                    Text(folder.name)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 5).fill(nav.selectedFolder == folder ? selectedColor : unSelectedColor))
            
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(showDelete ? Color.pink : Color.clear, lineWidth: 3))
            
            RoundedRectangle(cornerRadius: 5)
                .fill(dropColor)
                .frame(height: dropStatus.dropAfter ? 30 : 0)
                .animation(.easeInOut)
                .padding(.bottom, 1)
                .padding(.leading, dropStatus == .subfolder ? 20 : 0)
                .animation(nil)
                
           Rectangle()
            .frame(height: dropStatus == .note ? 1 : 0)
                .animation(.easeInOut)
            .padding(dropStatus == .note ? 5 : 0)
        }
        
        
        .gesture(TapGesture(count: 2).onEnded({ _ in
            self.edit.toggle()
        }))
        
        .onTapGesture {
            nav.selectedFolder = folder
        }
        
        
        .onDrag({ NSItemProvider(object: DataTypeDragItem(id: folder.uuid.uuidString, type: DataType.folder.rawValue)) })
        .onDrop(of: [kUTTypeData as String], delegate: FolderDropDelegate(destinationFolder: folder, dropStatus: $dropStatus))
        
        
        .contextMenu(ContextMenu(menuItems: {
            Button(action: {
                self.edit.toggle()
            }, label: {
                Text("Rename folder")
            })
            
            Divider()
            Button(action: {
                self.makeNewFolderStatus = .addFolder
            }, label: {
                Text("Add folder")
            })
            
            Button(action: {
                self.makeNewFolderStatus = .addAsSubFolder
            }, label: {
                Text("Add subfolder")
            })
            
            Divider()
            
            //TODO: delete alert
            Button(action: {
                showDelete.toggle()
            }, label: {
                Text("Delete")
            })
            
        }))

        //MARK: - presentations
            .alert(isPresented: $showDelete, content: {
                Alert(title: Text("Do you really want to delete this folder?"),
                      message: nil,
                      primaryButton: Alert.Button.cancel(),
                      secondaryButton: Alert.Button.destructive(Text("Delete"), action: {
                    if folder == nav.selectedFolder {
                        nav.selectedFolder = nil
                    }
                    Folder.delete(folder)
                    
                }))
            })
    
        .sheet(item: $makeNewFolderStatus) { status in
            FolderEditorView(editorStatus: status, contextFolder: folder)
        }
        
        .onReceive(nav.$selectedFolder, perform: { _ in
            self.edit = false
        })
        .onReceive(nav.$selectedNote, perform: { _ in
            self.edit = false
        })

    }
    
    //MARK: - DropDelegate
    struct FolderDropDelegate: DropDelegate {
        
        let destinationFolder: Folder
        @Binding var dropStatus: DropStatus
        
        func dropEntered(info: DropInfo) {
            //check folder or note
            let providers = info.itemProviders(for: [kUTTypeData as String])
            _ = providers.loadObjects(ofType: DataTypeDragItem.self) { (item) in
                
                if destinationFolder.uuid.uuidString == item.id {
                    return
                }else if item.type == DataType.note.rawValue {
                    dropStatus = .note
                }else if item.type == DataType.folder.rawValue {
                    changeFolder(location: info.location)
                }else {
                    dropStatus = .inActive
                }
            }
        }
    
        func changeFolder(location: CGPoint) {
            if location.y < 10 {
                dropStatus = .folderBefore
            }else {
                if location.x < 60 {
                    dropStatus = .folderAfter
                }else {
                    dropStatus = .subfolder
                }
            }
            
        }
        
        func dropUpdated(info: DropInfo) -> DropProposal? {
            if dropStatus.folderRelated {
                changeFolder(location: info.location)
            }
            return nil
        }
        
        func dropExited(info: DropInfo) {
            finishDrop()
        }
        
        func finishDrop() {
            dropStatus = .inActive
            NotificationCenter.default.post(name: .finishDrop, object: nil)
        }
        
        func performDrop(info: DropInfo) -> Bool {
            let providers = info.itemProviders(for: [kUTTypeData as String])
            let found = destinationFolder.handleMovedDrop(with: providers, dropStatus: dropStatus)
            
           finishDrop()
            return found
        }
    }
    
}

struct FolderRow_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        let nav = NavigationStateManager()
        let folder = Folder(name: "selected Folder", context: context)
        nav.selectedFolder = folder
        
       return List {
            FolderRow(folder: Folder.nestedFolder(context: context))
            FolderRow(folder: folder)
        
       }.frame(width: 200)
        
        .environmentObject(nav)
    }
}
