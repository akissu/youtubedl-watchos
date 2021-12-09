//
//  CacheContentsInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by llsc12 on 07/12/2021.
//

import WatchKit
import Foundation


class CacheContentsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var videoTableRow: WKInterfaceTable!
    @IBOutlet weak var cacheTitle: WKInterfaceLabel!
    @IBOutlet weak var cacheImg: WKInterfaceImage!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        /*
        //load videos with accompanying metadata.
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache")
            for file in files {
                videoTableRow.setNumberOfRows(files.count, withRowType: "VideoRow")
                
                for i in 0 ..< files.count {
                    guard let row = videoTableRow.rowController(at: i) as? VideoRow else {
                        continue
                        }
                    cacheTitle.titleLabel.setText(videos[i].title)
                    row.videoId = videos[i].id
                    
                    if UserDefaults.standard.bool(forKey: settingsKeys.thumbnailsToggle) == false {
                        row.thumbImg.setHidden(true)
                    } else {
                        row.thumbImg.sd_setImage(with: videos[i].img)
                    }
                }
            }
            
        } catch {
            //no errors should occur i hope
            print(error)
        }
         */
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
