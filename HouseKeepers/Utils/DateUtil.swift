//
//  DateUtil.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/1.
//

import Foundation

class DateUtil: NSObject {
    
    static let shared = DateUtil()
    
    //"yyyy/MM/dddd HH:mm:ss"
    
    /// 依指定的日期格式取得當前的系統日期字串
    ///
    /// - Parameter strFormat: 日期格式
    /// - Returns: String
    func getStrSysDate(withFormat strFormat: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        return dateFormatter.string(from: Date())
    }
    
    /// 依傳入的日期格式、日期轉換成日期
    /// - Parameters:
    ///   - strFormat: 日期格式
    ///   - strDate: 日期
    /// - Returns: Date
    func getDateFromString(withFormat strFormat: String, strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
//        print("-----------------\(dateFormatter.date(from: strDate)!)")
        return dateFormatter.date(from: strDate)!
    }
    
    /// 取得當前的民國日期字串
    ///
    /// - Returns: String
    func getLastRepublicOfChinaDateStr() -> String {
        let date: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "民國 yyy 年 MM 月 dd 日 HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        return dateFormatter.string(from: date)
    }
    
    
    /// 依傳入的日期格式、日期轉換成民國日期
    ///
    /// - Returns: Date
    func getRepublicOfChinaDate(withFormat strFormat: String ,strDate: String) -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
//        dateFormatter.dateFormat = "民國 yyy 年 MM 月 dd 日 HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        return dateFormatter.date(from: strDate)!
    }
    

//
//    /// 依傳入的日期格式、日期轉換成民國日期字串
//    ///
//    /// - Parameter strFormat: 日期格式
//    /// - Returns: String
    func getStrFormatDateStr(withFormat strFormat: String , strDate: String) -> String {
        let date = getRepublicOfChinaDate(withFormat : strFormat , strDate: strDate)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy年m月 "
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        return dateFormatter.string(from: date)

    }
    
    
    func getMonthDateStr(withFormat strFormat: String , strDate: String) -> String {
        let date = getRepublicOfChinaDate(withFormat : strFormat , strDate: strDate)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-mm "
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        return dateFormatter.string(from: date)

    }
    
    
    func dateToString(_ date:Date, dateFormat:String) -> String {
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        return dateFormatter.string(from: date)
       
    }
    
    func date2String(_ date:Date, dateFormat:String ) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.ReferenceType.system
        formatter.timeZone = TimeZone.ReferenceType.system
        formatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    func stringToDate(withFormat strFormat: String ,strDate: String) -> Date {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        return dateFormatter.date(from: strDate)!
    }
    
}
