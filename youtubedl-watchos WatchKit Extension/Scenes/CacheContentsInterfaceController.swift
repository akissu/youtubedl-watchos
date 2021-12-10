//
//  CacheContentsInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by llsc12 on 07/12/2021.
//

import WatchKit
import Foundation
import SDWebImage

class CacheContentsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var cacheTableRow: WKInterfaceTable!
    var files = ["e"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        //load videos with accompanying metadata.
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache")
            cacheTableRow.setNumberOfRows(files.count, withRowType: "cachedVideoRow")
            cacheTableRow.setHidden(false)
            var ids = ["gamingmoment"]
            
            for i in 0 ..< files.count {
                let file = files[i]
                let videoID = file.components(separatedBy: ".")[0]
                guard let row = cacheTableRow.rowController(at: i) as? CacheTableRow else {
                    continue
                }
                
                if ids.contains(videoID) {continue}
                
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = dir.appendingPathComponent("miscCache/"+file)
                    
                    let data = try String(contentsOf: fileURL, encoding: .utf8).components(separatedBy: "\n")
                    // ok so data[0] is the video title and data[1] is image url
                    row.cacheTitleLabel.setText(data[0])
                    row.cacheThumbImage.sd_setImage(with: URL(string: data[1]))
                    row.videoId = videoID
                    ids.append(videoID)
                    print(i)
                }
            }
            
        } catch {
            //no errors should occur i hope
            print(error)
        }
         
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        self.pushController(withName: "CacheNowPlayingInterfaceController", context: files[rowIndex])
    }

}
