//
//  CardPilePresentation.swift
//  sg-fate
//
//  Created by Jason Whittle on 3/15/23.
//

import SwiftUI

struct CardPilePresentation {
    let label: String
    let color: Color
    let font: Font
    let includeChanceOfAtLeast: Bool
    
    init(label: String, color: Color, font: Font, includeChanceOfAtLeast: Bool = false) {
        self.label = label
        self.color = color
        self.font = font
        self.includeChanceOfAtLeast = includeChanceOfAtLeast
    }
}
