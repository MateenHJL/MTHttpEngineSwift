//
//  HttpLogCollectionItem.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/16.
//

import Foundation


class HttpLogCollectionItem {
    
    static func Kmark (markString : String) -> String{
        return "mark_\(markString)_mark";
    }
    
    static let kMark = "mark";
    static let kDisplayDescription = "displayDescription";
    static let kHttpCollectedLogCenterTable = "HttpCollectedLogCenterTable";
    static let kId = "id";
    static let kCreateTimeStamp = "createTimeStamp";
    static let kLogType = "logType";
    static let kCreateTime = "createTime";
    static let kBusinessDescription = "businessDescription";
    static let kHttpMethod = "httpMethod";
    static let kPostParams = "postParams";
    static let kHeader = "header";
    static let kResponseData = "responseData";
    static let kStatusCode = "statusCode";
    static let kResponseDataType = "responseDataType";
    static let kHttpDebugMessage = "httpDebugMessage";
    static let kCreateDay = "createDay";
    static let kHttpRequestUrl = "httpRequestUrl";

    
    static func createTableItem () -> BaseSqliteItem<BaseDataModel.Type>{
        let item : BaseSqliteItem = BaseSqliteItem<BaseDataModel.Type>.init();
        item.configTableStatement = "CREATE TABLE IF NOT EXISTS '\(kHttpCollectedLogCenterTable)' ('\(kId)' INTEGER PRIMARY KEY AUTOINCREMENT,'\(kDisplayDescription)' TEXT,'\(kLogType)' INTEGER, '\(kCreateTimeStamp)' INTEGER, '\(kCreateTime)' TEXT, '\(kMark)' TEXT, '\(kBusinessDescription)' TEXT, '\(kHttpMethod)' TEXT, '\(kPostParams)' TEXT, '\(kHeader)' TEXT, '\(kResponseData)' TEXT, '\(kStatusCode)' TEXT, '\(kResponseDataType)' TEXT, '\(kHttpDebugMessage)' TEXT, '\(kCreateDay)' TEXT, '\(kHttpRequestUrl)' TEXT)";
        return item;
    }
    
    static func configInsertStatementWithDataModel (dataModel : HttpLogInformationDataModel) -> BaseSqliteItem<BaseDataModel.Type>{
        let item : BaseSqliteItem = BaseSqliteItem<BaseDataModel.Type>.init();
        item.operateStatement = "INSERT INTO '\(kHttpCollectedLogCenterTable)' ('\(kMark)', '\(kDisplayDescription)', '\(kCreateTimeStamp)', '\(kLogType)', '\(kCreateTime)', '\(kBusinessDescription)', '\(kHttpMethod)', '\(kPostParams)', '\(kHeader)', '\(kResponseData)', '\(kStatusCode)', '\(kResponseDataType)', '\(kHttpDebugMessage)', '\(kCreateDay)', '\(kHttpRequestUrl)') VALUES ('\(dataModel.mark!)', '\(dataModel.displayDescription ?? "")', '\(dataModel.createTimeStamp!)', '\(dataModel.logType!)', '\(dataModel.createTime!)', '\(dataModel.businessDescription!)', '\(dataModel.httpMethod!)', '\(dataModel.postParams!)', '\(dataModel.header!)', '\(dataModel.responseData!)', '\(dataModel.statusCode!)', '\(dataModel.responseDataType!)', '\(dataModel.httpDebugMessage!)', '\(dataModel.createDay!)', '\(dataModel.httpRequestUrl!)')";
        return item;
    }
    
    static func convertHttpItemWithSqliteItemWithHttpItem (item : BaseHttpItem) -> BaseSqliteItem<BaseDataModel.Type>{
        var responseDataType = "";
        switch item.httpResponseDataType
        {
            case .LoadedFromServer:
                responseDataType = "服务器";
            case .LoadedFromLocalCache:
                responseDataType = "本地缓存";
            case .LoadedFromMockingResponse:
                responseDataType = "本地模拟数据";
            case .UnknownType:
                responseDataType = "本地出错信息";
        }
        
        let logDataModel : HttpLogInformationDataModel = HttpLogInformationDataModel.init();
        logDataModel.businessDescription = item.descriptionItem();
        logDataModel.httpMethod = item.httpRequestMethodString;
        logDataModel.postParams = item.httpRequestPostParams.descriptionWithLocale();
        logDataModel.header = item.httpRequestHeaderParams.descriptionWithLocale();
        logDataModel.responseData = (item.httpRequestResponseData as! Dictionary<String, Any>).descriptionWithLocale();
        logDataModel.statusCode = String(item.httpRequestStatusCode);
        logDataModel.responseDataType = responseDataType;
        logDataModel.httpDebugMessage = item.httpRequestDebugErrorMessage;
        logDataModel.httpRequestUrl = item.httpRequestAbsoluteUrlString;
        logDataModel.logType = HttpLogInfomationDataModeType.httpRequest;
        logDataModel.mark = Kmark(markString: BaseHttpConfigManager.shareHttpConfigManager().config.httpLogCollectionMark());
        return self.configInsertStatementWithDataModel(dataModel: logDataModel);
    }
    
    static func convertPushDataWithSqliteItemWithPushDataDic (pushDic : Dictionary<String, Any>) -> BaseSqliteItem<BaseDataModel.Type>{
        let logDataModel : HttpLogInformationDataModel = HttpLogInformationDataModel.init();
        logDataModel.displayDescription = pushDic.descriptionWithLocale();
        logDataModel.logType = HttpLogInfomationDataModeType.notification;
        return configInsertStatementWithDataModel(dataModel: logDataModel);
    }
    
    static func selectAllHttpLogWithMark (mark : String) -> BaseSqliteItem<HttpLogInformationDataModel>{
        let item : BaseSqliteItem = BaseSqliteItem<HttpLogInformationDataModel>.init();
        item.operateStatement = "select * from \(kHttpCollectedLogCenterTable) where \(kMark) like '\(mark)' order by \(kCreateTimeStamp) desc"
        return item;
    }
    
    static func selectOneDayLogInformationWithDay (day : String, key : String, mark : String) -> BaseSqliteItem<HttpLogInformationDataModel>{
        let item : BaseSqliteItem = BaseSqliteItem<HttpLogInformationDataModel>.init();
        item.operateStatement = "SELECT * FROM \(kHttpCollectedLogCenterTable) WHERE \(kMark) like '\(mark)' AND \(kCreateDay) like '\(day)' AND \(kDisplayDescription) like '%\(key)%' order by \(kCreateTimeStamp) desc"
        return item;
    }
    
    static func selectDebugLogWithLogid (logId : String) -> BaseSqliteItem<HttpLogInformationDataModel>{
        let item : BaseSqliteItem = BaseSqliteItem<HttpLogInformationDataModel>.init();
        item.operateStatement = "select * from \(kHttpCollectedLogCenterTable) where \(kId) like '\(logId)'"
        return item;
    }
    
    static func deleteAllLog () -> BaseSqliteItem<BaseDataModel>{
        let item : BaseSqliteItem = BaseSqliteItem<BaseDataModel>.init();
        item.operateStatement = "delete from \(kHttpCollectedLogCenterTable)";
        return item;
    }
}
