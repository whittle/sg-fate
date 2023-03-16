//
//  CardPileView.swift
//  sg-fate
//
//  Created by Jason Whittle on 3/15/23.
//

import SwiftUI

struct CardPileView: View {
    @Binding var cardState: CardState
    let pile: CardState.Pile
    let presentation: CardPilePresentation
    @State private var isDropTargeted = false
    private var borderColor: Color { isDropTargeted ? .black : .clear }

    var body: some View {
        let cardPile = cardState.selectPile(pile: pile)
        VStack {
            Text(presentation.label).font(presentation.font)
            ForEach(cardPile.cardCounts) { cardCount in
                HStack {
                    VStack {
                        Text(String(cardCount.faceValue)).font(.title)
                        Text(String(cardCount.count))
                    }
                    if presentation.includeChanceOfAtLeast {
                        Text(NumberFormatter.localizedString(from: cardPile.chanceOfAtLeast(cardCount: cardCount), number: .percent))
                            .font(.largeTitle)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 5)
                    .background(.clear)
                    .foregroundColor(presentation.color)
                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)))
                .draggable(CardFromPile(faceValue: cardCount.faceValue, pile: cardPile.pile))
            }
            Text(String(cardPile.totalCount)).font(presentation.font)
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .border(self.borderColor)
        .dropDestination(for: CardFromPile.self) { cardsFromPiles, _ in
            for cardFromPile in cardsFromPiles {
                cardState.transferCard(faceValue: cardFromPile.faceValue, from: cardFromPile.pile, to: pile)
            }
            return true
        } isTargeted: {
            self.isDropTargeted = $0
        }
    }
}

struct CardPileView_Previews: PreviewProvider {
    static var previews: some View {
        let presentation = CardPilePresentation(label: "Some Pile", color: .blue, font: .caption, includeChanceOfAtLeast: true)
        BindingProvider(CardState.arbitrary()) { cardState in
            CardPileView(cardState: cardState, pile: CardState.Pile.arbitrary(), presentation: presentation)
        }
    }
}
