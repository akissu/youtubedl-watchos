//
//  CacheContentsInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by llsc12 on 07/12/2021.
//

import WatchKit
import Foundation


class CacheContentsInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        //load videos with accompanying metadata.
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache")
            
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
