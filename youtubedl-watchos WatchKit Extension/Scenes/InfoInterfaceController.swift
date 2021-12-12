//
//  CacheInfoInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by llsc12 on 12/12/2021.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON

class InfoInterfaceController: WKInterfaceController {
    @IBOutlet weak var viewsLabel: WKInterfaceLabel!
    @IBOutlet weak var likesLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //AF.request("https://"+Constants.downloadSrvInstance+"/api/v1/getInfo?url=\(context!)").responseJSON { response in
            
            //self.viewsLabel.setText("\(views!) Views")
            //self.likesLabel.setText("\(likes!) Likes")
        //}

        
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
