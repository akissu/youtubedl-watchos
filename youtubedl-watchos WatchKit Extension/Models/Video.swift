//
//  Video.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import Foundation
import Alamofire
import SwiftUI

class Video {
    
    var id: String
    var title: String
    var img = URL(string: "")
    
    public init(id: String, title: String, img: URL) {
        self.id = id
        self.title = title
        self.img = img
    }
    
    class func getVideos(keyword: String, completion: @escaping ([Video]) -> Void) {
        AF.request("https://"+Constants.downloadSrvInstance+"/api/v1/search?search_query=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&limit=30").responseJSON { response in
            
            var videos = [Video]()
            
            switch response.result {
            case .success(let json):
                    let response = json as! Dictionary<String, Any>
                    let keyExists = response["items"]
                    if keyExists != nil{
                        let items = response["items"] as! [[String: Any]]
                        for (_, item) in items.enumerated() {
                            
                            let title = item["title"]
                            let vidId = item["id"]
                            let imgUrlArray: Any? = item["thumbnails"]
                            // cool also btw this is the search results thingy
                            if title == nil || vidId == nil || imgUrlArray == nil {
                                //where data moment
                            } else {
                                let video = Video(id: vidId as! String, title: title as! String, img: URL(string: "https://data.mothership.tools/mothershiptools-ukprod/wp-content/uploads/2018/06/Screen-Shot-2018-06-14-at-10.26.44-AM.png")!)
                                videos.append(video)
                            }
                        }
                    }
            case .failure(let error):
                print(error)
            }
            completion(videos)
        }
    }
}

public func loadImage(url:String, forImageView: WKInterfaceImage) {
// load image
    let image_url:String = url
    DispatchQueue.main.async {
        let url: NSURL = NSURL(string:image_url)!
        let data: NSData = NSData(contentsOf: url as URL)!
        let placeholder = UIImage(data: data as Data)!

// update ui
        DispatchQueue.main.async {
            forImageView.setImage(placeholder)
        }
    }

}
