//
//  SettingsInterfaceController.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by Hugo on 05/12/2021.
//

import WatchKit
import Foundation


class SettingsInterfaceController: WKInterfaceController {
    
    
    @IBOutlet weak var cacheEnabler: WKInterfaceSwitch!
    @IBOutlet weak var thumbnailEnabler: WKInterfaceSwitch!
    @IBOutlet weak var audioOnly: WKInterfaceSwitch!
    @IBOutlet weak var cacheEnableToggle: WKInterfaceSwitch!
    
    @IBAction func cacheEnableToggle(_ value: Bool) {
        print(value)
    }
    
    @IBAction func deleteCacheButton() {
        print("Button press")
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
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
