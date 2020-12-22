//
//  KeywordRow.swift
//  SlipboxApp
//
//  Created by Karin Prater on 11.12.20.
//

import SwiftUI

struct KeywordRow: View {
    
    @EnvironmentObject var nav: NavigationStateManager
    
    @ObservedObject var keyword: Keyword
    
    let selectedColor: Color = Color("selectedColor")
    let unSelectedColor: Color = Color("unselectedColor")
    
    @State private var deleteKey: Bool = false
    
    var body: some View {
        HStack(spacing: 20) {
         Text(keyword.name)
         
            Text("\(keyword.notes.count)").padding(5)
                .background(Circle().fill(Color.white))
        }
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 5).fill(nav.selectedKewords.contains(keyword) ? selectedColor : unSelectedColor))
            .onTapGesture {
                if nav.selectedKewords.contains(keyword) {
                    nav.selectedKewords.remove(keyword)
                }else {
                    nav.selectedKewords.insert(keyword)
                }
            }
            
            .onDrag({ NSItemProvider(object: DataTypeDragItem(id: keyword.uuid.uuidString, type: DataType.keyword.rawValue)) })
            
            .contextMenu(ContextMenu(menuItems: {
                Button {
                    deleteKey.toggle()
                } label: {
                    Text("Delete")
                }
            }))
        
        .alert(isPresented: $deleteKey, content: {
            Alert(title: Text("Are you sure to delete keyword '\(keyword.name)'? "), message: nil, primaryButton: Alert.Button.cancel(), secondaryButton: .destructive(Text("Delete"), action: {
                if nav.selectedKewords.contains(keyword) {
                    nav.selectedKewords.remove(keyword)
                }
                Keyword.delete(keyword: keyword)
            }))
        })
   
    }
}

struct KeywordRow_Previews: PreviewProvider {
    static var previews: some View {
        
        let nav = NavigationStateManager()
        let selecedKeyword = Keyword(name: "selected", context: PersistenceController.preview.container.viewContext)
        nav.selectedKewords.insert(selecedKeyword)
        
        return VStack {
            KeywordRow(keyword: Keyword(name: "new", context: PersistenceController.preview.container.viewContext))
            
            KeywordRow(keyword: selecedKeyword)
            
        }
            .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .previewLayout(.fixed(width: 300, height: 300))
        
            .environmentObject(nav)
    }
}
