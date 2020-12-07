//
//  NowPlayingInterfaceContoller.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import Foundation
import WatchKit
import Alamofire

var youtubedlServerURLBase = "http://" + Constants.youtubedlServerIP + ":" + Constants.youtubedlServerPort
var youtubedlServerURLDL = youtubedlServerURLBase + "/dl"

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
        
        self.statusLabel.setText("Searching video...")
        
        AF.request(youtubedlServerURLBase + "/" + self.video.id).responseJSON { response in
            switch response.result {
            case .success(let json):
                    let response = json as! Dictionary<String, Any>
                    let vidpath = response["path"] as! String
                    self.statusLabel.setText("Loading video... 0%")

                    let destination: DownloadRequest.Destination = { _, _ in
                        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video.mp4")

                        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                    }
                    
                    AF.download(youtubedlServerURLDL + "/" + self.video.id, to: destination).response { response in
                        if response.value != nil {
                            self.movie.setMovieURL(response.value!!)
                            self.statusLabel.setText("Tap to play!")
                        }
                    }
                    .downloadProgress(closure: { (progress) in
                        let percent = Int((round(100 * progress.fractionCompleted) / 100) * 100)
                        self.statusLabel.setText("Loading video... \(percent)%")
                    })
            case .failure(let error):
                print(error)
            }
        }
    }
}

