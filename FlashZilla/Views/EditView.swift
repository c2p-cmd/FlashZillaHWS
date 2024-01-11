//
//  EditView.swift
//  FlashZilla
//
//  Created by Sharan Thakur on 11/01/24.
//

import SwiftUI

struct EditView: View {
    var onDone: () -> Void
    @State private var cards = [Card]()
    @State private var prompt = ""
    @State private var answer = ""
    
    var body: some View {
        List {
            Section("Add new card") {
                TextField("Prompt", text: $prompt, axis: .vertical)
                TextField("Answer", text: $answer, axis: .vertical)
                Button("Add Card", action: addCard)
            }
            
            Section("Cards") {
                ForEach(0..<cards.count, id: \.self) { i in
                    VStack(alignment: .leading) {
                        Text(cards[i].prompt)
                            .font(.headline)
                        
                        Text(cards[i].answer)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: removeCards)
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Edit Cards")
        .onAppear(perform: loadData)
        .toolbar {
            Button("Done", action: onDone)
        }
    }
    
    func addCard() {
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedAnswer.isEmpty && !trimmedPrompt.isEmpty else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        saveData()
        prompt = ""
        answer = ""
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        saveData()
    }
    
    func loadData() {
        guard let data = UserDefaults.standard.data(forKey: "Cards"),
              let decoded = try? JSONDecoder().decode([Card].self, from: data) else {
            return
        }
        
        cards = decoded
    }
    
    func saveData() {
        guard let data = try? JSONEncoder().encode(cards) else { return }
        UserDefaults.standard.set(data, forKey: "Cards")
    }
}

#Preview {
    NavigationStack {
        EditView {
            
        }
    }
}
