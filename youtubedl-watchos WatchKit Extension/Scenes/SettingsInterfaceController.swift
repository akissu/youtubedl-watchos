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
    
    let userDefaults = UserDefaults.standard

    @IBAction func cacheToggle(_ value: Bool) {

        if value == true {
            userDefaults.set(value, forKey: settingsKeys.cacheToggle)
            cacheDeleteButton.setHidden(false)
            
            willActivate()

        }
        else {
           
            userDefaults.set(value, forKey: settingsKeys.cacheToggle)
            
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            do {
                try FileManager.default.removeItem(at: documentsUrl)

            } catch let error {
                print(error)
            }
            
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache")
                for file in files {
                    try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Documents/cache/\(file)")
                }
            } catch {
                //what happened lol
            }
            cacheDeleteButton.setHidden(true)
        }
    }
    
    @IBAction func deleteCacheButton() {
        
        let action1 = WKAlertAction(title: "Delete Cache", style: .destructive) { [weak self] in
            
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache")
                for file in files {
                    try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Documents/cache/\(file)")
                }
            } catch {
                //what happened lol
            }
            self!.cacheDeleteButton.setTitle("Cleared")
            self!.cacheDeleteButton.setEnabled(false)
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

        cacheToggle.setOn(userDefaults.bool(forKey: settingsKeys.cacheToggle))
        thumbnailsToggle.setOn(userDefaults.bool(forKey: settingsKeys.thumbnailsToggle))
        audioOnlyToggle.setOn(userDefaults.bool(forKey: settingsKeys.audioOnlyToggle))

        cacheDeleteButton.setHidden(!userDefaults.bool(forKey: settingsKeys.cacheToggle))
        
        // set cache button to enabled, if its empty just keep it as cleared and disable it
        cacheDeleteButton.setEnabled(true)
        do {
            var totalSize = 0 as Int64
            let files = try FileManager.default.contentsOfDirectory(atPath: NSHomeDirectory()+"/Documents/cache")
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
            cacheDeleteButton.setTitle("Clear Cache (\(string))")
        } catch {
            cacheDeleteButton.setEnabled(false)
            cacheDeleteButton.setTitle("Cleared")
        }
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
