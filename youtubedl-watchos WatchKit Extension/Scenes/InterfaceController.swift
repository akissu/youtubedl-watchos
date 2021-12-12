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
        do {
            let cacheURL = URL(string: NSHomeDirectory()+"/Documents/cache")!
            if !FileManager.default.fileExists(atPath: cacheURL.path) {
                try FileManager.default.createDirectory(atPath: cacheURL.path, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {}
        
        // This method is called when watch view controller is about to be visible to user
        if UserDefaults.standard.value(forKey: settingsKeys.cacheToggle) == nil {
            UserDefaults.standard.set(true, forKey: settingsKeys.cacheToggle)
        }
        cacheScreenButton.setEnabled(UserDefaults.standard.bool(forKey: settingsKeys.cacheToggle))
        if UserDefaults.standard.bool(forKey: settingsKeys.cacheToggle) == true {
            cacheScreenButton.setAlpha(1)
        } else {
            cacheScreenButton.setAlpha(0.6)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBOutlet weak var cacheScreenButton: WKInterfaceButton!
    
    @IBAction func CacheScreen() {
        if UserDefaults.standard.bool(forKey: settingsKeys.cacheToggle) == true {
            cacheScreenButton.setEnabled(true)
            cacheScreenButton.setAlpha(1)
            pushController(withName: "CacheContentsInterfaceController", context: "Any")
        }
        else {
            cacheScreenButton.setEnabled(false)
            cacheScreenButton.setAlpha(0.6)
        }
    }
    @IBAction func searchVideoButtonTapped() {
        
        var keywordsHistory = UserDefaults.standard.stringArray(forKey: preferencesKeys.keywordsHistory) ?? [String]()
        var lastTwentyKeywordsHistory = Array(keywordsHistory.suffix(20))
        if lastTwentyKeywordsHistory.count == 0 {
            lastTwentyKeywordsHistory.append("Ki Jor Gariban Da") // to get the option to scribbl on first launch
        }
        
        self.presentTextInputController(withSuggestions: lastTwentyKeywordsHistory.reversed(), allowedInputMode: .plain) { (keywords) in
            if let keyword = keywords as? [String] {
                if keyword.count > 0 {
                    if let index = keywordsHistory.firstIndex(of: keyword[0]) {
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
