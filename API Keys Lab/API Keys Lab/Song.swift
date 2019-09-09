//
//  Song.swift
//  API Keys Lab
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Anthony. All rights reserved.
//

import Foundation

// MARK: - Song
struct Song: Codable {
    let message: Message
    
    static func getTrackData(newURL: String, completionHandler: @escaping (Result<[Track],AppError>) -> () ) {
        
        NetworkManager.shared.fetchData(urlString: newURL) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let songData = try JSONDecoder().decode(Song.self, from: data)
                    let trackArr = songData.message.body.track_list
                    let tracks = trackArr.map({$0.track})
                    completionHandler(.success(tracks))
                } catch {
                    completionHandler(.failure(.badJSONError))                }
            }
        }
    }
}

// MARK: - Message
struct Message: Codable {
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let track_list: [TrackList]
}

// MARK: - TrackList
struct TrackList: Codable {
    let track: Track
}

// MARK: - Track
struct Track: Codable {
//    let trackID: Int
    let track_name: String
//    let hasLyrics, hasSubtitles, hasRichsync, numFavourite: Int
    let artist_name: String

}
