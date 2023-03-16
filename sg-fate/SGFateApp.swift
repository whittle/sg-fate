//
//  SGFateApp.swift
//  sg-fate
//
//  Created by Jason Whittle on 3/8/23.
//

import SwiftUI

@main
struct SGFateApp: App {
    @StateObject private var cardStore = CardStore()

    var body: some Scene {
        WindowGroup {
            CardStateView(cardState: $cardStore.cardState) {
                Task {
                    do {
                        try await CardStore.save(cardState: cardStore.cardState)
                    } catch {
                        fatalError("Error saving card state: \(error)")
                    }
                }
            }
            .task {
                do {
                    cardStore.cardState = try await CardStore.load()
                } catch {
                    fatalError("Error loading card state: \(error)")
                }
            }
        }
    }
}
