import Foundation
import UIKit

extension NSDate {
    public static func dateToString(value: NSDate) -> String? {
        return self.dateToString(value, format: "dd/MMM/yy, HH:mm")
    }
    
    public static func dateToString(date: NSDate, format: String) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
    
    public func stringFromDate(format: String) -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}


import Argo
import Curry

extension NSDate: Decodable {
    static var formatter: NSDateFormatter {
        let df = NSDateFormatter()
        df.calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return df
    }
    
    public static func decode(json: JSON) -> Decoded<NSDate> {
        switch(json) {
        case .String(var dateString):
            
            dateString = dateString.stringByReplacingOccurrencesOfString("T", withString: " ", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
            dateString = dateString.stringByReplacingOccurrencesOfString("Z", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)

            guard let date = formatter.dateFromString(dateString) else {
                return Decoded<NSDate>.typeMismatch("date", actual: dateString)
            }
            return pure(date)
        default:
            return Decoded<NSDate>.typeMismatch("date", actual: json.description)
        }
    }
}