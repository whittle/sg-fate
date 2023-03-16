//
//  CardStateView.swift
//  sg-fate
//
//  Created by Jason Whittle on 3/8/23.
//

import SwiftUI

struct CardStateView: View {
    @Binding var cardState: CardState
    let saveAction: ()->Void
    
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    cardState.transferAllCards(from: .held, into: .draw)
                }, label: {
                    Image(systemName: "shuffle.circle.fill").font(.title)
                }).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                Spacer()
                Button(action: {
                    cardState.transferAllCards(from: .discard, into: .draw)
                }, label: {
                    Image(systemName: "shuffle.circle.fill").font(.title)
                }).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            HStack {
                let heldPresentation = CardPilePresentation(label: "Held", color: .blue, font: .caption)
                CardPileView(cardState: $cardState, pile: .held, presentation: heldPresentation)
                Spacer()
                let drawPresentation = CardPilePresentation(label: "Draw Pile", color: .green, font: .headline, includeChanceOfAtLeast: true)
                CardPileView(cardState: $cardState, pile: .draw, presentation: drawPresentation)
                Spacer()
                let discardPresentation = CardPilePresentation(label: "Discard", color: .gray, font: .caption)
                CardPileView(cardState: $cardState, pile: .discard, presentation: discardPresentation)
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BindingProvider(CardState.arbitrary()) { cardState in
            CardStateView(cardState: cardState, saveAction: {})
        }
    }
}
