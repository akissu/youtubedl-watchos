//
//  InterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func searchVideoButtonTapped() {
        
        var keywordsHistory = UserDefaults.standard.stringArray(forKey: preferencesKeys.keywordsHistory) ?? [String]()
        var lastTwentyKeywordsHistory = Array(keywordsHistory.suffix(20))
        if lastTwentyKeywordsHistory.count == 0 {
            lastTwentyKeywordsHistory.append("SomeOrdinaryGamers") // to get the option to scribbl on first launch
        }
        
        self.presentTextInputController(withSuggestions: lastTwentyKeywordsHistory.reversed(), allowedInputMode: .plain) { (keywords) in
            if let keyword = keywords as? [String] {
                if keyword.count > 0 {
                    if let index = keywordsHistory.index(of: keyword[0]) {
                        keywordsHistory.remove(at: index)
                    }
                    keywordsHistory.append(keyword[0])
                    UserDefaults.standard.set(keywordsHistory, forKey: preferencesKeys.keywordsHistory)
                    let context = ["action": "search",
                                   "query": keyword[0]]
                    self.pushController(withName: "VideoListInterfaceController", context: context)
                }
            }
        }
    }

}
