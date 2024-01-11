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
}
