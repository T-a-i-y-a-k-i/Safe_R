//
//  Item.swift
//  Safe_R
//
//  Created by Avery McComas on 2026-03-14.
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
