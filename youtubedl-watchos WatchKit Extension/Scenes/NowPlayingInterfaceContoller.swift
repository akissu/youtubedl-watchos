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
        
        // dont forget about caching system
        let cachingSetting = UserDefaults.standard.bool(forKey: "isToggleEnabled")

        let destinationCached: DownloadRequest.Destination = { _, _ in
            let cachingFileURL = URL(fileURLWithPath: NSHomeDirectory()+"/Documents/cache").appendingPathComponent("\(self.video.id).mp4")
            return (cachingFileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let destination: DownloadRequest.Destination = { _, _ in
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.mp4")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
                
        if cachingSetting == true {
            if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/cache/\(self.video.id).mp4") == true {
                self.movie.setMovieURL(URL(fileURLWithPath: NSHomeDirectory()+"/Documents/cache").appendingPathComponent("\(self.video.id).mp4"))
                self.statusLabel.setText("Loaded from cache.")
            } else {
                AF.download(vidpath, to: destinationCached).response { response in
                    if response.value != nil {
                        self.movie.setMovieURL(response.value!!)
                        self.statusLabel.setText("Ready.")
                    }
                }.downloadProgress(closure: { (progress) in
                    let percent = Int((round(100 * progress.fractionCompleted) / 100) * 100)
                    self.statusLabel.setText("Downloading... \(percent)%")
                })
            }
        } else {
            AF.download(vidpath, to: destination).response { response in
                if response.value != nil {
                    self.movie.setMovieURL(response.value!!)
                    self.statusLabel.setText("Ready.")
                }
            }.downloadProgress(closure: { (progress) in
                let percent = Int((round(100 * progress.fractionCompleted) / 100) * 100)
                self.statusLabel.setText("Downloading... \(percent)%")
            })
        }
    }
}
