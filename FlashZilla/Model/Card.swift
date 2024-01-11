//
//  Card.swift
//  FlashZilla
//
//  Created by Sharan Thakur on 11/01/24.
//

import Foundation

struct Card: Identifiable, Codable {
    let id: UUID
    let prompt: String
    let answer: String
    
    init(prompt: String, answer: String) {
        self.id = UUID()
        self.prompt = prompt
        self.answer = answer
    }
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    
    static func loadCards() -> [Card] {
        let url = URL.documentsDirectory.appendingPathComponent("CARDS")
        guard let data = FileManager.default.contents(atPath: url.absoluteString) else {
            return [.example]
        }
        
        return (try? JSONDecoder().decode([Card].self, from: data)) ?? [.example]
    }
    
    static func saveCards(_ cards: [Card]) {
        guard let data = try? JSONEncoder().encode(cards) else { return }
        let url = URL.documentsDirectory.appendingPathComponent("CARDS")
        try? data.write(to: url, options: [.atomic, .completeFileProtection])
    }
}
