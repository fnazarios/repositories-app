import Foundation
import UIKit

extension Date {
    public static func dateToString(_ value: Date) -> String? {
        return self.dateToString(value, format: "dd/MMM/yy, HH:mm")
    }
    
    public static func dateToString(_ date: Date, format: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public func stringFromDate(_ format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


import Argo
import Curry

extension Date: Decodable {
    static var formatter: DateFormatter {
        let df = DateFormatter()
        df.calendar = Calendar.current
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return df
    }

    public static func decode(_ json: JSON) -> Decoded<Date> {
        switch(json) {
        case .string(var dateString):
            
            dateString = dateString.replacingOccurrences(of: "T", with: " ")
            dateString = dateString.replacingOccurrences(of: "Z", with: " ")

            if let date = formatter.date(from: dateString) {
                return pure(date)
            }
            
            return Decoded<Date>.typeMismatch(expected: "date", actual: dateString)
        default:
            return Decoded<Date>.typeMismatch(expected: "date", actual: json.description)
        }
    }
}
