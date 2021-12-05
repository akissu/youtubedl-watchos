//
//  VideoListInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import Foundation
import WatchKit

class VideoListInterfaceController: WKInterfaceController {
    
    @IBOutlet var videoTableRow: WKInterfaceTable!
        
    @IBOutlet weak var img: WKInterfaceImage!
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
            // image url available at videos[i].img
            
        }
    }
        
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        self.pushController(withName: "NowPlayingInterfaceController", context: self.videos[rowIndex])
    }
}
