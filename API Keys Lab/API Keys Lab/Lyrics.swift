//
//  Lyrics.swift
//  API Keys Lab
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Anthony. All rights reserved.
//

import Foundation

// MARK: - Lyrics
struct LyricsModel: Codable {
    let message: MessageWrapper
    
    static func getLyricsData(newURL: String, completionHandler: @escaping (Result<Lyrics,AppError>) -> () ) {
        NetworkManager.shared.fetchData(urlString: newURL) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let lyricsData = try JSONDecoder().decode(LyricsModel.self, from: data)
                  
                    completionHandler(.success(lyricsData.message.body.lyrics))
                } catch {
                    completionHandler(.failure(.badJSONError))                }
            }
        }
    }
}


struct MessageWrapper: Codable {
    let body: BodyWrapper
}


struct BodyWrapper: Codable {
    let lyrics: Lyrics
}

struct Lyrics: Codable {
    //    let lyricsID: Int
    let lyrics_body: String?
}
