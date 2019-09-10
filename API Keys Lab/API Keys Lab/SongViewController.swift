//
//  ViewController.swift
//  API Keys Lab
//
//  Created by Anthony Gonzalez on 9/9/19.
//  Copyright © 2019 Anthony. All rights reserved.
//

import UIKit

class SongViewController: UIViewController {
    
    //MARK: -- Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: -- Properties
    var songs = [Track]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: -- Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifer = segue.identifier else {fatalError("No identifier in segue")}
        
        switch segueIdentifer {
        case "segueToDetail":
            guard let destVC = segue.destination as? detailViewController else { fatalError("Unexpected segue VC") }
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { fatalError("No row selected") }
            let selectedTrack = songs[selectedIndexPath.row]
            let selectedTrackURL = "https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?q_track=\(selectedTrack.track_name)&apikey=de2f217c3287b542f88b9d9bc600a90f".replacingOccurrences(of: " ", with: "%20")
        
            destVC.currentTrackURL = selectedTrackURL
            print(selectedTrackURL)
        default:
            fatalError("unexpected segue identifier")
        }
    }
    
    private func configureDelegateDataSources() {
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func getSearchedTrackData(enteredURL: String){
        Song.getTrackData(newURL: enteredURL){ (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let songData):
                    self.songs = songData
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegateDataSources()
    }
}

//MARK: -- DataSource Methods
extension SongViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentTrack = songs[indexPath.row]
        let songCell = tableView.dequeueReusableCell(withIdentifier: "songCell")
        
        songCell?.textLabel?.text = currentTrack.track_name.capitalized
        songCell?.detailTextLabel?.text = currentTrack.artist_name.capitalized
        return songCell!
    }
}

//MARK: -- Delegate Methods
extension SongViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let enteredText = searchBar.text?.lowercased() {
            let artistSearchURL = "https://api.musixmatch.com/ws/1.1/track.search?q_artist=\(enteredText)&page_size=100&apikey=de2f217c3287b542f88b9d9bc600a90f".replacingOccurrences(of: " ", with: "%20")
            
            getSearchedTrackData(enteredURL: artistSearchURL)
        }
    }
}
