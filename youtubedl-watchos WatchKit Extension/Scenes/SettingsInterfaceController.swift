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
    
    
    @IBAction func cacheEnableToggle(_ value: Bool) {
        print(value)
    }
    
    @IBAction func deleteCacheButton() {
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
        
        DeleteCacheButton.setEnabled(true)
        DeleteCacheButton.setTitle("Clear Cache")
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
