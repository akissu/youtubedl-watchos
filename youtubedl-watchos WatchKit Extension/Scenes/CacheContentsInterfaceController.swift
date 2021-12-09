//
//  CacheContentsInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by llsc12 on 07/12/2021.
//

import WatchKit
import Foundation
import AVFoundation

class CacheContentsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var videoTableRow: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        //load videos with accompanying metadata.
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache")
            videoTableRow.setNumberOfRows(files.count, withRowType: "VideoRow")
            for file in files {
                let videoID = file.components(separatedBy: ".")[0]
                let filetype = file.components(separatedBy: ".")[1]
                
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

}
