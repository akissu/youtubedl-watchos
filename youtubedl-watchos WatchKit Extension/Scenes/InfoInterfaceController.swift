//
//  CacheInfoInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by llsc12 on 12/12/2021.
//

import WatchKit
import Foundation
import Alamofire

class CacheInfoInterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        AF.request("https://"+Constants.downloadSrvInstance+"/api/v1/getInfo?url=\(context!)").responseJSON { response in
            
        }

        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
