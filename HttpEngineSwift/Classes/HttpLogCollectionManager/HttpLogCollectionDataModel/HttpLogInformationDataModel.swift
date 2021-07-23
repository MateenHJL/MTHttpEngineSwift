//
//  HttpLogInformationDataModel.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/16.
//

import Foundation
import DateToolsSwift

public enum HttpLogInfomationDataModeType {
    case httpRequest        //the type is HttpReuqest
    case crash              //the type is Crash
    case notification       //the type is Notification
}

public class HttpLogInformationDataModel : BaseDataModel {
    var logId : String?;
    var httpRequestUrl : String?;
    var businessDescription : String?;
    var httpMethod : String?;
    var postParams : String?;
    var header : String?;
    var responseData : String?;
    var statusCode : String?;
    var responseDataType : String?;
    var httpDebugMessage : String?;
    var mark : String?;
    var displayDescription : String?;
    var createDay : String?;
    var createTimeStamp : TimeInterval?;
    var createTime : String?;
    var logType : HttpLogInfomationDataModeType?;
    
    required init() {
        let date : Date = Date.init();
        self.createTimeStamp = TimeInterval(date.timeIntervalSince1970);
        self.createDay = "\(date.year)年\(date.month)月\(date.day)日";
        self.createTime = "\(date.hour)时\(date.minute)分\(date.second)秒";
    }
}
