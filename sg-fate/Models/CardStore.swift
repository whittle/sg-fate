//
//  CardStore.swift
//  sg-fate
//
//  Created by Jason Whittle on 3/15/23.
//

import Foundation

class CardStore: ObservableObject {
    @Published var cardState: CardState = CardState.fresh()
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("sg-fate.data")
    }
    
    static func load() async throws -> CardState {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let cardState):
                    continuation.resume(returning: cardState)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<CardState, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(CardState.fresh()))
                    }
                    return
                }
                let cardState = try JSONDecoder().decode(CardState.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(cardState))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(cardState: CardState) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(cardState: cardState) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success:
                    continuation.resume(returning: 0)
                }
            }
        }
    }
    
    static func save(cardState: CardState, completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(cardState)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(0))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
