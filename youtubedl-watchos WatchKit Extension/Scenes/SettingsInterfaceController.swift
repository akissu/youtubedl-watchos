//
//  SettingsInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by Hugo on 05/12/2021.
//

import WatchKit
import Foundation


class SettingsInterfaceController: WKInterfaceController {
    
    
    @IBOutlet weak var cacheToggle: WKInterfaceSwitch!
    @IBOutlet weak var cacheDeleteButton: WKInterfaceButton!
    @IBOutlet weak var thumbnailsToggle: WKInterfaceSwitch!
    @IBOutlet weak var audioOnlyToggle: WKInterfaceSwitch!
    @IBOutlet weak var resultsLabel: WKInterfaceLabel!
    
    let userDefaults = UserDefaults.standard

    @IBAction func cacheToggle(_ value: Bool) {
        if value == true {
            userDefaults.set(value, forKey: settingsKeys.cacheToggle)
            cacheDeleteButton.setHidden(false)
            
            willActivate()

        }
        else {
            do {
                var totalSize = 0 as Int64
                let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache/")
                for file in files {
                    if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: NSHomeDirectory()+"/Documents/cache/\(file)") {
                        if let bytes = fileAttributes[.size] as? Int64 {
                            totalSize = totalSize+bytes
                        }
                    }
                }
                let bcf = ByteCountFormatter()
                if ((totalSize >= 1024000000) == true) {bcf.allowedUnits = [.useGB]} else {bcf.allowedUnits = [.useMB]}
                bcf.countStyle = .file
                let string = bcf.string(fromByteCount: totalSize)
                
                if totalSize != 0 {
                    let action1 = WKAlertAction(title: "Delete And Turn Off", style: .destructive) { [weak self] in
                        self!.userDefaults.set(value, forKey: settingsKeys.cacheToggle)
                        
                        do {
                            let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache")
                            for file in files {
                                try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Documents/cache/\(file)")
                            }
                        } catch {
                            //what happened lol
                        }
                        do {
                            let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/miscCache")
                            for file in files {
                                try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Documents/miscCache/\(file)")
                            }
                        } catch {
                            //what happened lol
                        }
                        self!.cacheDeleteButton.setHidden(true)
                    }
                    let action2 = WKAlertAction(title: "Cancel", style: .cancel) { [weak self] in
                        self!.cacheToggle.setOn(true)
                    }
                    presentAlert(withTitle: "Warning", message: "You currently have \(string) of cache, are you sure you want to turn off caching?", preferredStyle: .alert, actions: [action1, action2])
                } else {
                    userDefaults.set(value, forKey: settingsKeys.cacheToggle)
                    cacheDeleteButton.setHidden(true)
                }
            } catch {
                //thonk
            }
        }
    }
    
    @IBAction func deleteCacheButton() {
        
        let action1 = WKAlertAction(title: "Delete Cache", style: .destructive) { [weak self] in
            
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache")
                for file in files {
                    try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Documents/cache/\(file)")
                }
                self!.cacheDeleteButton.setTitle("Cleared")
                self!.cacheDeleteButton.setEnabled(false)
            } catch {
                //what happened lol
            }
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/miscCache")
                for file in files {
                    try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Documents/miscCache/\(file)")
                }
            } catch {
                //what happened lol
            }
        }
        
        let action2 = WKAlertAction(title: "Cancel", style: .cancel) {}
        
        presentAlert(withTitle: "Delete Cache?", message: "Are you sure you want to delete the cache?", preferredStyle: .alert, actions: [action1, action2])
    }
    
    @IBAction func thumbnailsToggle(_ value: Bool) {
        userDefaults.set(value, forKey: settingsKeys.thumbnailsToggle)
    }
    
    @IBAction func audioOnlyToggle(_ value: Bool) {
        userDefaults.set(value, forKey: settingsKeys.audioOnlyToggle)
    }
    
    @IBAction func resultLower() {
        if userDefaults.integer(forKey: settingsKeys.resultsCount) > 3 {
            userDefaults.set(userDefaults.value(forKey: settingsKeys.resultsCount) as! Int-1, forKey: settingsKeys.resultsCount)
            updateLabel()
        }
    }
    
    @IBAction func resultHigher() {
        if userDefaults.integer(forKey: settingsKeys.resultsCount) < 30 {
            userDefaults.set(userDefaults.value(forKey: settingsKeys.resultsCount) as! Int+1, forKey: settingsKeys.resultsCount)
            updateLabel()
        }
    }
    
    func updateLabel() {
        resultsLabel.setText("\(String(describing: userDefaults.value(forKey: settingsKeys.resultsCount) as! Int)) Results")
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }

    override func willActivate() {
        
        if userDefaults.value(forKey: settingsKeys.cacheToggle) == nil {
            userDefaults.set(true, forKey: settingsKeys.cacheToggle)
        }
        if userDefaults.value(forKey: settingsKeys.thumbnailsToggle) == nil {
            userDefaults.set(true, forKey: settingsKeys.thumbnailsToggle)
        }
        if userDefaults.value(forKey: settingsKeys.audioOnlyToggle) == nil {
            userDefaults.set(false, forKey: settingsKeys.audioOnlyToggle)
        }
        if userDefaults.value(forKey: settingsKeys.resultsCount) == nil {
            userDefaults.set(15, forKey: settingsKeys.resultsCount)
        }

        cacheToggle.setOn(userDefaults.bool(forKey: settingsKeys.cacheToggle))
        thumbnailsToggle.setOn(userDefaults.bool(forKey: settingsKeys.thumbnailsToggle))
        audioOnlyToggle.setOn(userDefaults.bool(forKey: settingsKeys.audioOnlyToggle))

        cacheDeleteButton.setHidden(!userDefaults.bool(forKey: settingsKeys.cacheToggle))
        
        // set cache button to enabled, if its empty just keep it as cleared and disable it
        cacheDeleteButton.setEnabled(true)
        do {
            var totalSize = 0 as Int64
            let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache/")
            for file in files {
                if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: NSHomeDirectory()+"/Documents/cache/\(file)") {
                    if let bytes = fileAttributes[.size] as? Int64 {
                        totalSize = totalSize+bytes
                    }
                }
            }
            let bcf = ByteCountFormatter()
            if ((totalSize >= 1024000000) == true) {bcf.allowedUnits = [.useGB]} else {bcf.allowedUnits = [.useMB]}
            bcf.countStyle = .file
            let string = bcf.string(fromByteCount: totalSize)
            if totalSize == 0 {
                cacheDeleteButton.setEnabled(false)
                cacheDeleteButton.setTitle("Cleared")
            } else {
                cacheDeleteButton.setTitle("Clear Cache (\(string))")
            }
        } catch {
            cacheDeleteButton.setEnabled(false)
            cacheDeleteButton.setTitle("Cleared")
        }
        
        updateLabel()
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
