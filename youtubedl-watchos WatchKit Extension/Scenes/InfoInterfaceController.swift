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
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var authorLabel: WKInterfaceLabel!
    @IBOutlet weak var showDescriptionButton: WKInterfaceButton!
    
    var videoDetails: Dictionary<String, Any> = [:]
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.showDescriptionButton.setEnabled(false)
        self.likesLabel.setText("Loading Likes")
        self.viewsLabel.setText("Loading Views")
        self.dateLabel.setText("Loading Date")
        self.authorLabel.setText("Loading Channel")

        AF.request("https://"+Constants.downloadSrvInstance+"/api/v1/getInfo?url=\(context!)").responseJSON { response in
            
            switch response.result {
            case .success(let json):
                    let response = json as! Dictionary<String, Any>
                    let keyExists = response["videoDetails"]
                    if keyExists != nil{
                        self.videoDetails = response["videoDetails"] as! Dictionary<String, Any>
                    }
                    
            case .failure(let error):
                print(error)
            }
            let author = self.videoDetails["author"] as! Dictionary<String, Any>
            self.likesLabel.setText("\(String(describing: self.videoDetails["likes"]!)) Likes")
            self.viewsLabel.setText("\(String(describing: self.videoDetails["viewCount"]!)) Views")
            self.dateLabel.setText("Uploaded \(String(describing: self.videoDetails["publishDate"]!).components(separatedBy: "-").reversed().joined(separator: "/"))")
            self.authorLabel.setText("\(String(describing: author["name"]!))")
            self.showDescriptionButton.setEnabled(true)
        }

        
        // Configure interface objects here.
    }
    @IBAction func showDescription() {
        self.pushController(withName: "SubInfoInterfaceController", context: self.videoDetails["description"]!)
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
