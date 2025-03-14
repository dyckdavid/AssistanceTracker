import Foundation
import SwiftData

@Model
class Entry {
    var checkIn: Date
    var checkOut: Date?

    init(checkIn: Date, checkOut: Date? = nil) {
        self.checkIn = checkIn
        self.checkOut = checkOut
    }
}
