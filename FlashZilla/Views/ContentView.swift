//
//  ContentView.swift
//  FlashZilla
//
//  Created by Sharan Thakur on 11/01/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showEditScreen = false
    
    var body: some View {
        NavigationStack {
            if showEditScreen {
                EditView {
                    showEditScreen = false
                }
            } else {
                FlashCardsView()
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Button {
                                withAnimation {
                                    showEditScreen = true
                                }
                            } label: {
                                Label("Add Cards", systemImage: "plus.circle")
                                    .font(.largeTitle)
                            }
                            .buttonStyle(.borderless)
                            .background(.black.opacity(0.75))
                            .clipShape(.circle)
                            .foregroundStyle(.white)
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
