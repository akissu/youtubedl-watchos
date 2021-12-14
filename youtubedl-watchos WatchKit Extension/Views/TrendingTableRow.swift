//
//  TrendingTableRow.swift
//  youtubedl-watchos WatchKit Extension
//
//  Created by llsc12 on 14/12/2021.
//

import WatchKit
import Foundation

class TrendingTableRow: NSObject {
    @IBOutlet var trendingChannelLabel: WKInterfaceLabel!
    @IBOutlet var trendingTitleLabel: WKInterfaceLabel!
    @IBOutlet var trendingThumbImg: WKInterfaceImage!
    var videoId: String!
}
