//
//  CardState.swift
//  sg-fate
//
//  Created by Jason Whittle on 3/14/23.
//

import Foundation

struct CardState: Codable {
    static let faceValues = 1...6
    var drawPile: CardPile
    var discardPile: CardPile
    var heldPile: CardPile
    
    enum Pile: CaseIterable, Codable {
        case draw
        case discard
        case held
        
        static func arbitrary() -> Pile {
            return allCases.randomElement()!
        }
    }
    
    func selectPile(pile: Pile) -> CardPile {
        switch pile {
        case .draw:
            return drawPile
        case .discard:
            return discardPile
        case .held:
            return heldPile
        }
    }
    
    mutating func alterPile<T>(_ pile: Pile, change: ((inout CardPile) -> T)) -> T {
        switch pile {
        case .draw:
            return change(&drawPile)
        case .discard:
            return change(&discardPile)
        case .held:
            return change(&heldPile)
        }
    }

    mutating func transferCard(faceValue: Int, from: Pile, to: Pile) -> Bool {
        let success = alterPile(from) { cardPile in
            cardPile.removeCard(of: faceValue)
        }
        if success {
            alterPile(to) { cardPile in
                cardPile.addCard(of: faceValue)
            }
            return true
        } else {
            return false
        }
    }
    
    mutating func transferAllCards(from: Pile, into: Pile) {
        let counts = alterPile(from) { cardPile in
            cardPile.countAndEmpty()
        }
        alterPile(into) { cardPile in
            cardPile.augmentBy(counts)
        }
    }
    
    static func fresh() -> CardState {
        let drawPile = CardPile(pile: .draw, dict: [1: 6, 2: 12, 3: 12, 4: 12, 5: 12, 6: 6])
        let discardPile = CardPile.empty(pile: .discard)
        let heldPile = CardPile.empty(pile: .held)
        return CardState(drawPile: drawPile, discardPile: discardPile, heldPile: heldPile)
    }

    static func arbitrary() -> CardState {
        CardState(drawPile: CardPile.arbitrary(), discardPile: CardPile.arbitrary(), heldPile: CardPile.arbitrary())
    }
}
