//
//  Video.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import Foundation
import Alamofire

class Video {
    
    var id: String
    var title: String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
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

                            // cool also btw this is the search results thingy
                            if title == nil || vidId == nil {
                                //where data moment
                                print("idk")
                            } else {
                                let video = Video(id: vidId as! String, title: title as! String)
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
