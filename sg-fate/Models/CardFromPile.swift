//
//  CardFromPile.swift
//  sg-fate
//
//  Created by Jason Whittle on 3/15/23.
//

import SwiftUI

struct CardFromPile: Codable, Transferable {
    let faceValue: Int
    var pile: CardState.Pile
    var description: String { "a \(faceValue) card from the \(pile) pile" }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .json)
        ProxyRepresentation(exporting: \.description)
    }
}
