//
//  NetworkManager.swift
//  SpaceXApp
//
//  Created by Unsal Oner on 18.11.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    private let baseURL = "https://api.spacexdata.com/v5"

    func fetchUpcomingLaunches(completion: @escaping (Result<[Launch], Error>) -> Void) {
        let url = "\(baseURL)/launches/upcoming"
        fetchData(from: url, completion: completion)
    }

    func fetchPastLaunches(completion: @escaping (Result<[Launch], Error>) -> Void) {
        let url = "\(baseURL)/launches/past"
        fetchData(from: url, completion: completion)
    }
    private func fetchData<T: Decodable>(from endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                print(decodedData) 
                completion(.success(decodedData))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
}


