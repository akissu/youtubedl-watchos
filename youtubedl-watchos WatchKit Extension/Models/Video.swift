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
        AF.request("https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&maxResults=20&order=viewCount&key=" + Constants.youtubeAPIKey).responseJSON { response in
            
            var videos = [Video]()
            
            switch response.result {
            case .success(let json):
                    let response = json as! Dictionary<String, Any>
                    let keyExists = response["items"]
                    let errorExists = response["error"]
                    if keyExists != nil{
                        let items = response["items"] as! [[String: Any]]
                        for (_, item) in items.enumerated() {
                            let videoDetails = item
                            let snippet = videoDetails["snippet"] as! Dictionary<String, Any>
                            let title = snippet["title"] as! String
                            
                            let id = videoDetails["id"] as! Dictionary<String, Any>
                            
                            guard let videoId = id["videoId"] as? String else {
                                continue
                            }
                            
                            let video = Video(id: videoId, title: title)
                            videos.append(video)
                        }
                    }
            case .failure(let error):
                print(error)
            }
            completion(videos)
        }
    }
}
