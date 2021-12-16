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

class NowPlayingInterfaceController: WKInterfaceController {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var movie: WKInterfaceMovie!
    @IBOutlet var statusLabel: WKInterfaceLabel!

    var video: Video!
    
    @IBAction func infoScreenButton() {
        self.pushController(withName: "InfoInterfaceController", context: self.video.id)
    }
    override func awake(withContext context: Any?) {
        var dlType: String
        var fileType: String
        if UserDefaults.standard.bool(forKey: settingsKeys.audioOnlyToggle) == false {
            dlType = "download"
            fileType = "mp4"
        } else {
            dlType = "audio"
            fileType = "mp3"
        }

        let youtubedlServerURLDL = youtubedlServerURLBase + "/api/v2/\(dlType)?url=https://youtu.be"
        
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
        let cachingSetting = UserDefaults.standard.bool(forKey: settingsKeys.cacheToggle)

        let destinationCached: DownloadRequest.Destination = { _, _ in
            let cachingFileURL = URL(fileURLWithPath: NSHomeDirectory()+"/Documents/cache").appendingPathComponent("\(self.video.id).\(fileType)")
            return (cachingFileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let destination: DownloadRequest.Destination = { _, _ in
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.\(fileType)")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
                
        if cachingSetting == true {
            if FileManager.default.fileExists(atPath: NSHomeDirectory()+"/Documents/cache/\(self.video.id).\(fileType)") == true {
                self.movie.setMovieURL(URL(fileURLWithPath: NSHomeDirectory()+"/Documents/cache").appendingPathComponent("\(self.video.id).\(fileType)"))
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
