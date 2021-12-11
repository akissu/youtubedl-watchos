//
//  VideoListInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import Foundation
import WatchKit
import SDWebImage

class VideoListInterfaceController: WKInterfaceController {
    
    @IBOutlet var videoTableRow: WKInterfaceTable!
    
    var videos: [Video]!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let dictionary = context as? Dictionary<String, Any> {
            if let action = dictionary["action"] as? String {
                if action == "search" {
                    let keyword = dictionary["query"] as! String
                    Video.getVideos(keyword: keyword) { videos in
                        self.videos = videos
                        self.setupTable()
                        self.videoTableRow.setHidden(false)
                    }
                }
            }
        }
    }
    
    func setupTable() {
        videoTableRow.setNumberOfRows(videos.count, withRowType: "VideoRow")
        
        for i in 0 ..< videos.count {
            guard let row = videoTableRow.rowController(at: i) as? VideoRow else {
                continue
                }
            row.titleLabel.setText(videos[i].title)
            row.videoId = videos[i].id
            
            if UserDefaults.standard.bool(forKey: settingsKeys.thumbnailsToggle) == false {
                row.thumbImg.setHidden(true)
            } else {
                row.thumbImg.sd_setImage(with: URL(string: videos[i].img))
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
        
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        self.pushController(withName: "NowPlayingInterfaceController", context: self.videos[rowIndex])
    }
}
