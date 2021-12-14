//
//  InterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet var TrendingTableRow: WKInterfaceTable!
    
    var videos: [Video]!
    override func awake(withContext context: Any?) {
        Video.getTrending() { videos in
            self.videos = videos
            self.setupTable()
            self.TrendingTableRow.setHidden(false)
        }
    }
    
    override func willActivate() {
        do {
            let cacheURL = URL(string: NSHomeDirectory()+"/Documents/cache")!
            if !FileManager.default.fileExists(atPath: cacheURL.path) {
                try FileManager.default.createDirectory(atPath: cacheURL.path, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {}
        
        // This method is called when watch view controller is about to be visible to user
        if UserDefaults.standard.value(forKey: settingsKeys.cacheToggle) == nil {
            UserDefaults.standard.set(true, forKey: settingsKeys.cacheToggle)
        }
        cacheScreenButton.setEnabled(UserDefaults.standard.bool(forKey: settingsKeys.cacheToggle))
        if UserDefaults.standard.bool(forKey: settingsKeys.cacheToggle) == true {
            cacheScreenButton.setAlpha(1)
        } else {
            cacheScreenButton.setAlpha(0.9745)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBOutlet weak var cacheScreenButton: WKInterfaceButton!
    
    @IBAction func CacheScreen() {
        if UserDefaults.standard.bool(forKey: settingsKeys.cacheToggle) == true {
            cacheScreenButton.setEnabled(true)
            cacheScreenButton.setAlpha(1)
            pushController(withName: "CacheContentsInterfaceController", context: "Any")
        }
        else {
            cacheScreenButton.setEnabled(false)
            cacheScreenButton.setAlpha(0.9745)
        }
    }
    @IBAction func searchVideoButtonTapped() {
        
        var keywordsHistory = UserDefaults.standard.stringArray(forKey: preferencesKeys.keywordsHistory) ?? [String]()
        let lastTwentyKeywordsHistory = Array(keywordsHistory.suffix(20))
        self.presentTextInputController(withSuggestions: lastTwentyKeywordsHistory.reversed(), allowedInputMode: .plain) { (keywords) in
            if let keyword = keywords as? [String] {
                if keyword.count > 0 {
                    if let index = keywordsHistory.firstIndex(of: keyword[0]) {
                        keywordsHistory.remove(at: index)
                    }
                    keywordsHistory.append(keyword[0])
                    UserDefaults.standard.set(keywordsHistory, forKey: preferencesKeys.keywordsHistory)
                    let context = ["action": "search",
                                   "query": keyword[0]]
                    self.pushController(withName: "VideoListInterfaceController", context: context)
                }
            }
        }
    }
    
    func setupTable() {
        TrendingTableRow.setNumberOfRows(videos.count, withRowType: "TrendingRow")
        
        for i in 0 ..< videos.count {
            guard let row = TrendingTableRow.rowController(at: i) as? TrendingTableRow else {
                continue
            }
            row.trendingTitleLabel.setText(videos[i].title)
            row.videoId = videos[i].id
            row.trendingChannelLabel.setText(videos[i].channel)
            
            if UserDefaults.standard.bool(forKey: settingsKeys.thumbnailsToggle) == false {
                row.trendingThumbImg.setHidden(true)
            } else {
                row.trendingThumbImg.sd_setImage(with: URL(string: videos[i].img)!)
            }
            
            let file = "\(videos[i].id)" //this is the file. we will write to and read from it
            let text = "\(videos[i].title)\n\(videos[i].img)" //just a text
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent("miscCache/"+file)
                //writing
                do {
                    try FileManager.default.createDirectory(at: dir.appendingPathComponent("miscCache/"), withIntermediateDirectories: true)
                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
                }
                catch {}
            }
        }
    }
}
