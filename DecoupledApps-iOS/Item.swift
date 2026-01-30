// Author: George Michelon
//
//  Item.swift
//  DecoupledApps-iOS
//
//  Created by George Michelon on 30/01/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
