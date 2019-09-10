//
//  detailViewController.swift
//  API Keys Lab
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Anthony. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {

    var currentTrackURL = String()
    
    @IBOutlet weak var lyricsText: UITextView!
    
    var currentLyrics: Lyrics? {
        didSet {
            lyricsText.text = currentLyrics?.lyrics_body
        }
    }
    
    private func getSelectedLyricsData(trackURL: String){
        LyricsModel.getLyricsData(newURL: trackURL ) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let newLyricData):
                    self.currentLyrics = newLyricData
                }
            }
        }
    }
 

    override func viewDidLoad() {
        super.viewDidLoad()
        getSelectedLyricsData(trackURL: currentTrackURL)
    }
}
