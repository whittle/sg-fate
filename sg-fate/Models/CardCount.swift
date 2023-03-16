//
//  CardCount.swift
//  sg-fate
//
//  Created by Jason Whittle on 3/15/23.
//

import Foundation

struct CardCount: Codable, Identifiable {
    let id: UUID
    let faceValue: Int
    var count: Int
    
    init(id: UUID = UUID(), faceValue: Int, count: Int = 0) {
        self.id = id
        self.faceValue = faceValue
        self.count = count
    }
}
