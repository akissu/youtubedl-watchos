//
//  VideoTableRow.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by developer on 12/6/20.
//

import Foundation
import WatchKit

class VideoRow: NSObject {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var thumbImg: WKInterfaceImage!
    var videoId: String!
}
