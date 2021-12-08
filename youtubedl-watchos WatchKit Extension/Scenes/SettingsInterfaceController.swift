//
//  SettingsInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by Hugo on 05/12/2021.
//

import WatchKit
import Foundation


class SettingsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var thumbnailEnabler: WKInterfaceSwitch!
    @IBOutlet weak var audioOnly: WKInterfaceSwitch!
    @IBOutlet weak var cacheEnableToggle: WKInterfaceSwitch!
    @IBOutlet weak var DeleteCacheButton: WKInterfaceButton!
    
    let key: String = "isToggleEnabled"
    let userDefaults = UserDefaults.standard
    
    
    @IBAction func cacheEnablerToggle(_ value: Bool) {
        //print(value)
        //UserDefaults.standard.set(value, forKey: key)
        if value == true {
            UserDefaults.standard.set(value, forKey: key)
            DeleteCacheButton.setHidden(false)
            
        }
        else {
            DeleteCacheButton.setHidden(true)
            UserDefaults.standard.set(value, forKey: key)
        }
    }
    
    @IBAction func deleteCacheButton() {
        
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
        DeleteCacheButton.setTitle("Cleared")
        DeleteCacheButton.setEnabled(false)
    }
    
    @IBAction func thumbnailsToggle(_ value: Bool) {
        print(value)
    }
    
    @IBAction func audioOnlyToggle(_ value: Bool) {
        print(value)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        cacheEnableToggle.setOn(userDefaults.bool(forKey: key))
        //cacheEnableToggle.setEnabled(userDefaults.bool(forKey: key))
        
        DeleteCacheButton.setEnabled(true)
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
            DeleteCacheButton.setTitle("Clear Cache (\(string))")
        } catch {
            DeleteCacheButton.setEnabled(false)
            DeleteCacheButton.setTitle("Cleared")
        }
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension FileManager {
    func sizeOfFile(atPath path: String) -> Int64? {
        guard let attrs = try? attributesOfItem(atPath: path) else {
            return nil
        }
        return attrs[.size] as? Int64
    }
}
