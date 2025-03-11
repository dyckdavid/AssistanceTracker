//
//  Item.swift
//  Assistance
//
//  Created by David Dyck on 10/03/25.
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
