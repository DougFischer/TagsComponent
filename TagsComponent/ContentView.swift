//
//  ContentView.swift
//  TagsComponent
//
//  Created by Carlos Cabral on 27/07/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var autocomplete = AutocompleteObject()
    
    @State var text: String = ""
    @State var tags: [Tag] = []
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Insira abaixo os temas dos quais deseja receber notificações:")
                        .padding(.top, 24)
                    
                    TextField("Digite o tema aqui...", text: $text)
                        .font(.title3)
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color("TagContainerColor"), in: RoundedRectangle(cornerRadius: 8))
                        .onChange(of: text) { newValue in
                            autocomplete.autocomplete(text)
                        }

                    TagView(maxLimit: 15, tags: $tags)
                        .frame(height: 220)
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                .navigationTitle("Temas de interesse")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            
                        } label: {
                            Image(systemName: "multiply")
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                suggestionList
                
            }
        }
    }
    
    
    // MARK: - Box with a list of suggestions based on autocomplete.
    
    var suggestionList: some View {
        
        ScrollView(showsIndicators: false) {
            VStack {
                
                ForEach(autocomplete.suggestions, id: \.self) { suggestion in
                    VStack(alignment: .leading) {
                        Text(suggestion)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        
                        Divider()
                    }
                    .onTapGesture {
                        text = suggestion
                        tags.append(addTag(text: text.lowercased(), fontSize: 16))
                        text = ""
                        print(UIScreen.main.bounds.height)
                    }
                }
            }
            .background(Color(.white), in: RoundedRectangle(cornerRadius: 8))
        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.92, maxHeight: 300)
        .shadow(color: .black.opacity(0.12), radius: 20.0, x: 0.0, y: 10.0)
        .offset(x: 0, y: getScreenCalc(UIScreen.main.bounds.height))
    }
    
    
    // MARK: - Changes the autocomplete box position depending on the iPhone size.
    
    func getScreenCalc(_ sHeight: CGFloat) -> CGFloat {
        return sHeight < 800 ? UIScreen.main.bounds.height - UIScreen.main.bounds.height * 1.03 : UIScreen.main.bounds.height - UIScreen.main.bounds.height * 1.071
    }
}


// MARK: - Preview.

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone Pro 11")
        ContentView()
            .previewDevice("iPhone Pro 11")
            .preferredColorScheme(.dark)
        ContentView().previewDevice("iPhone 8")
    }
}
