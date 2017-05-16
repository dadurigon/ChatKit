//
//  DateHelper.swift
//  JSQMessagesSwift
//
//
//

import Foundation

public class DateHelper {
    
    var jsq_YyyymmddFormat: DateFormatter!
    var jsq_MmddFormat: DateFormatter!
    var jsq_HHmmFormat: DateFormatter!
    var jsq_WeekDayFormat: DateFormatter!
    
    static let shared: DateHelper = {
        
        let instance = DateHelper()
        
        if instance.jsq_YyyymmddFormat == nil {
            instance.jsq_YyyymmddFormat = DateFormatter()
            instance.jsq_YyyymmddFormat.locale = Locale(identifier: "en_US_POSIX")
            instance.jsq_YyyymmddFormat.dateFormat = "yyyy/MM/dd"
        }
        
        if instance.jsq_MmddFormat == nil {
            instance.jsq_MmddFormat = DateFormatter()
            instance.jsq_MmddFormat.locale = Locale(identifier: "en_US_POSIX")
            instance.jsq_MmddFormat.dateFormat = "M/d"
        }
        
        if instance.jsq_HHmmFormat == nil {
            instance.jsq_HHmmFormat = DateFormatter()
            instance.jsq_HHmmFormat.locale = Locale(identifier: "en_US_POSIX")
            instance.jsq_HHmmFormat.dateFormat = "HH:mm"
        }
        
        if instance.jsq_WeekDayFormat == nil {
            instance.jsq_WeekDayFormat = DateFormatter()
            instance.jsq_WeekDayFormat.locale = Locale(identifier: "ja")
        }

        
        return instance
        
    }()
    
}
