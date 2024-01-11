//
//  FlashCardsView.swift
//  FlashZilla
//
//  Created by Sharan Thakur on 11/01/24.
//

import SwiftUI

struct FlashCardsView: View {
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor: Bool
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled: Bool
    
    @State private var cards: [Card] = []
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                
                stack()
                    .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer being incorrect")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer being correct")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { _ in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background, .inactive:
                isActive = false
            case .active:
                if cards.isEmpty == false {
                    isActive = true
                }
            @unknown default:
                fatalError("invalid")
            }
        }
        .onAppear {
            guard let data = UserDefaults.standard.data(forKey: "Cards"),
                  let decoded = try? JSONDecoder().decode([Card].self, from: data) else {
                return
            }
            cards = decoded
        }
    }
    
    func stack() -> some View {
        ZStack {
            ForEach(0..<cards.count, id: \.self) { i in
                CardView(card: cards[i]) {
                    withAnimation {
                        removeCard(at: i)
                    }
                }
                .stacked(at: i, in: cards.count)
                .allowsHitTesting(i == cards.count - 1)
                .accessibilityHidden(i < cards.count - 1)
            }
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        guard let data = UserDefaults.standard.data(forKey: "Cards"),
              let decoded = try? JSONDecoder().decode([Card].self, from: data) else {
            return
        }
        cards = decoded
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

#Preview {
    FlashCardsView()
}
