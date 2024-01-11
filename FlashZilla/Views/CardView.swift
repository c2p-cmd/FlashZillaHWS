//
//  CardView.swift
//  FlashZilla
//
//  Created by Sharan Thakur on 11/01/24.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var removeCard: (() -> Void)? = nil
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor: Bool
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled: Bool
    @State private var isShowingAnswer = false
    @State private var offset: CGSize = .zero
    
    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation
                feedback.prepare()
            }
            .onEnded { _ in
                if abs(offset.width) > 100 {
                    if offset.width < 0 {
                        feedback.notificationOccurred(.error)
                    }
                    removeCard?()
                } else {
                    offset = .zero
                }
            }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(gesture)
        .accessibilityAddTraits(.isButton)
        .onTapGesture {
            withAnimation {
                self.isShowingAnswer.toggle()
            }
        }
        .animation(.spring(), value: offset)
    }
}

#Preview {
    CardView(card: .example)
        .preferredColorScheme(.dark)
}
