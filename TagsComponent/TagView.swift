//
//  TagView.swift
//  TagsComponent
//
//  Created by Carlos Cabral on 27/07/22.
//

import SwiftUI

struct TagView: View {
    
    var maxLimit: Int
    @Binding var tags: [Tag]
    var fontSize: CGFloat = 16
    @State var isShowingConfirmation: Bool = false
    
    @Namespace var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    ForEach(getRows(), id: \.self) { rows in
                        HStack(spacing: 10) {
                            ForEach(rows) { row in
                                RowView(tag: row)
                            }
                        }
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width - 70, alignment: .leading)
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity)
            .background(Color("TagContainerColor"), in: RoundedRectangle(cornerRadius: 8))
            .animation(.easeInOut, value: tags)
        }
    }
    
    // MARK: - Individual tag component.
    
    @ViewBuilder
    func RowView(tag: Tag)->some View {
        HStack(spacing: 4) {
            Text(tag.text)
                .font(.system(size: fontSize))
                .fontWeight(.medium)
                .lineLimit(1)
                .padding(.leading, 8)
                .foregroundColor(.black)
            
            Button {
                isShowingConfirmation = true
            } label: {
                Image(systemName: "multiply.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color("BtnTagColor"))
            }
            // MARK: Not working! Removing the wrong index.
            .alert(isPresented: $isShowingConfirmation, content: {
                Alert(
                    title: Text("Remover termo"),
                    message: Text("Tem certeza de que deseja excluir '\(tag.text)'?"),
                    primaryButton: .destructive(Text("Sim"), action: {
                        tags.remove(at: getIndex(tag: tag))
                    }),
                    secondaryButton: .cancel(Text("Cancelar")))
            })
            .padding(2)
            .offset(x: 4, y: 0)
            .matchedGeometryEffect(id: tag.id, in: animation)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(.white)
        .clipShape(Capsule())
        
        // MARK: This works! It removes the right index:
//        .contextMenu {
//            Button("Delete") {
//                tags.remove(at: getIndex(tag: tag))
//            }
//        }
    }
    
    // MARK: - Return the index of a given tag.
    
    func getIndex(tag: Tag)->Int {
        
        let index = tags.firstIndex { currentTag in
            return tag.id == currentTag.id
        } ?? 0
        
        return index
    }

    // MARK: - Split the array when it exceeds the screen size.
    
    func getRows()->[[Tag]] {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        // Calculating width
        var totalWidth: CGFloat = 0
        
        // Extra 10 size for safety
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 90
        
        tags.forEach { tag in
            // Add the capsule size into total width + spacing
            totalWidth += (tag.size + 60)
            
            if totalWidth > screenWidth {
                
                // a check for long string values
                totalWidth = (!currentRow.isEmpty || rows.isEmpty ? (tag.size + 50) : 0)
                
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
                
            } else {
                currentRow.append(tag)
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        return rows
    }
}

// MARK: - Function that returns the tag with its width.

func addTag(text: String, fontSize: CGFloat) ->Tag {
    
    let font = UIFont.systemFont(ofSize: fontSize)
    let attributes = [NSAttributedString.Key.font: font]
    let size = (text as NSString).size(withAttributes: attributes)
    
    return Tag(text: text, size: size.width)
}


// MARK: - Preview.

struct TagView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        TagView(maxLimit: 15, tags: .constant([Tag(text: "apple"), Tag(text: "orange")]))
            .previewLayout(.sizeThatFits)
        
        TagView(maxLimit: 15, tags: .constant([Tag(text: "apple"), Tag(text: "orange")]))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
