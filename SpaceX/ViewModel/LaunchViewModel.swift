//
//  LaunchViewModel.swift
//  SpaceXApp
//
//  Created by Unsal Oner on 18.11.2023.
//

import Foundation

class LaunchViewModel {
    private(set) var upcomingLaunches: [Launch] = []
    private(set) var pastLaunches: [Launch] = []

    let networkManager = NetworkManager.shared
    
    func fetchUpcomingLaunches(completion: @escaping (Result<[Launch], Error>) -> Void) {
        networkManager.fetchUpcomingLaunches { result in
            switch result {
            case .success(let launches):
                self.upcomingLaunches = launches
                completion(.success(launches))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchPastLaunches(completion: @escaping (Result<[Launch], Error>) -> Void) {
        networkManager.fetchPastLaunches { result in
            switch result {
            case .success(let launches):
                self.pastLaunches = launches
                completion(.success(launches))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func timeRemainingForLaunch(at index: Int, isUpcoming: Bool) -> TimeInterval {
            let launch = isUpcoming ? upcomingLaunches[index] : pastLaunches[index]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            if let launchDate = dateFormatter.date(from: launch.dateUTC) {
                let remainingTime = launchDate.timeIntervalSinceNow
                return max(remainingTime, 0) 
            }

            return 0
        }
    func numberOfUpcomingLaunches() -> Int {
           return upcomingLaunches.count
       }

       func numberOfPastLaunches() -> Int {
           return pastLaunches.count
       }

    func getLaunch(at index: Int, isUpcoming: Bool) -> Launch {
        return isUpcoming ? upcomingLaunches[index] : pastLaunches[index]
    }
}

