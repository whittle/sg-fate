//
//  CardPile.swift
//  sg-fate
//
//  Created by Jason Whittle on 3/15/23.
//

import Foundation

struct CardPile: Codable, Sequence {
    var pile: CardState.Pile
    var cardCounts: [CardCount]
    var totalCount: Int
    
    init(pile: CardState.Pile, dict: [Int: Int]) {
        var cardCounts: [CardCount] = []
        for i in CardState.faceValues {
            if let count = dict[i] {
                cardCounts.append(CardCount(faceValue: i, count: count))
            } else {
                cardCounts.append(CardCount(faceValue: i))
            }
        }
        self = CardPile(pile: pile, cardCounts: cardCounts)
    }

    init(pile: CardState.Pile, cardCounts: [CardCount]) {
        self.pile = pile
        self.cardCounts = cardCounts
        self.totalCount = cardCounts.reduce(into: 0) { count, cardCount in
            count += cardCount.count
        }
    }
    
    func chanceOfAtLeast(cardCount: CardCount) -> NSNumber {
        let atLeast = cardCounts.reduce(into: 0) { count, i in
            if i.faceValue >= cardCount.faceValue {
                count += i.count
            }
        }
        let chance = Decimal(atLeast) / Decimal(self.totalCount)
        return NSDecimalNumber(decimal: chance)
    }
    
    mutating func addCard(of: Int) {
        self.cardCounts[of - 1].count += 1
        self.totalCount += 1
    }
    
    mutating func removeCard(of: Int) -> Bool {
        let i = of - 1
        if cardCounts[i].count > 0 {
            self.cardCounts[i].count -= 1
            self.totalCount -= 1
            return true
        } else {
            return false
        }
    }
    
    mutating func countAndEmpty() -> [Int: Int] {
        let dict = cardCounts.reduce(into: [:]) { (result, cardCount) in
            result[cardCount.faceValue] = cardCount.count
        }
        self = CardPile.empty(pile: pile)
        return dict
    }
    
    mutating func augmentBy(_ dict: [Int: Int]) {
        for i in CardState.faceValues {
            if let x = dict[i] {
                cardCounts[i - 1].count += x
                totalCount += x
            }
        }
    }

    func makeIterator() -> some IteratorProtocol {
        self.cardCounts.makeIterator()
    }
    
    static func empty(pile: CardState.Pile) -> CardPile {
        var counts: [Int: Int] = [:]
        for i in CardState.faceValues {
            counts[i] = 0
        }
        return CardPile(pile: pile, dict: counts)
    }
    
    static func arbitrary() -> CardPile {
        let arbPile = CardState.Pile.arbitrary()
        var arbCounts: [Int: Int] = [:]
        for i in CardState.faceValues {
            arbCounts[i] = Int.random(in: 0...12)
        }
        return CardPile(pile: arbPile, dict: arbCounts)
    }
    
//    static func randomString(length: Int) -> String {
//      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//      return String((0..<length).map{ _ in letters.randomElement()! })
//    }
}

