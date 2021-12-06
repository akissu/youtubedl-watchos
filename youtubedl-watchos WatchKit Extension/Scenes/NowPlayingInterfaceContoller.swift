//
//  NowPlayingInterfaceContoller.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import Foundation
import WatchKit
import Alamofire
import SDWebImage

var youtubedlServerURLBase = "https://" + Constants.downloadSrvInstance
var youtubedlServerURLDL = youtubedlServerURLBase + "/api/v2/download?url=https://youtu.be"

class NowPlayingInterfaceController: WKInterfaceController {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var movie: WKInterfaceMovie!
    @IBOutlet var statusLabel: WKInterfaceLabel!

    var video: Video!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if context != nil {
            self.video = context as? Video
        }
        
        if self.video != nil {
            self.titleLabel.setText(self.video.title)
        } else {
            self.titleLabel.setText("Nothing is playing")
        }
        
    

        let vidpath = youtubedlServerURLDL+"/"+self.video.id
        self.statusLabel.setText("Waiting for server...")

        let destination: DownloadRequest.Destination = { _, _ in
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.mp4")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(vidpath, to: destination).response { response in
            if response.value != nil {
                
                self.movie.setMovieURL(response.value!!)
                self.statusLabel.setText("Ready.")
            }
        }
        .downloadProgress(closure: { (progress) in
            let percent = Int((round(100 * progress.fractionCompleted) / 100) * 100)
            self.statusLabel.setText("Downloading... \(percent)%")
        })
    }
}
