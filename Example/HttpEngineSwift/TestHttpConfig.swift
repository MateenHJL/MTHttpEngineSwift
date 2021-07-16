//
//  TestHttpConfig.swift
//  HttpEngineSwift_Example
//
//  Created by Sumansoul on 2021/7/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import HttpEngineSwift

class TestHttpConfig : HttpConfigDataSource {
    func httpRequestShouldSaveToLocalDB(item: BaseHttpItem) -> Bool {
        return true;
    }
    
    func configBaseHttpUrlWithHttpItem(item: BaseHttpItem) -> String {
        return "http://api.aozhuanyun.com/index.php/";
    }
    
    func headerRequestDictionary() -> Dictionary<String, String> {
        var dic : Dictionary<String , String> = [:];
        let app_version : Dictionary = Bundle.main.infoDictionary!;
        dic.updateValue(app_version["CFBundleShortVersionString"] as! String, forKey: "version");
        dic.updateValue("0", forKey: "language");
        dic.updateValue("0", forKey: "deviceType");
        dic.updateValue("noneDeviceToken", forKey: "deviceID");
        dic.updateValue("XMLHttpRequest", forKey: "X-Requested-with");
        dic.updateValue("IOS", forKey: "platform");
        dic.updateValue("1366", forKey: "width");
        dic.updateValue("768", forKey: "height");
        dic.updateValue("0", forKey: "isLargePic");
        dic.updateValue("asdasxsxaxa", forKey: "Authorization");
        return dic;
    }
    
    func httpRequestTimeoutCount() -> Int {
        return 15;
    }
    
    func httpRequestAcceptableContentTypes() -> Array<String> {
        return ["application/json","text/plain","text/javascript","text/json","text/html"];
    }
    
    func httpRequestUrlWithHttpItem(item: BaseHttpItem) -> String {
        return (item.httpReqeustDomainUrl + item.httpRequestUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
    }
    
    func httpRequestPostParamsWithHttpItem(item: BaseHttpItem) -> String {
        let httpRequestDataString : String = parseDataWithDictionary(dic: item.httpRequestPostParams);
        return httpRequestDataString;
    }
    
    func parseDataWithDictionary(dic : Dictionary<String, String>) -> String {
        var tmpRequestDataString : String = "";
        let allKey : Array<String> = dic.keys.sorted();
        for (i , key) in allKey.enumerated()
        {
            let value : Any = dic[key]!;
            if (value is Array<String>)
            {
                let arrayValue : Array<Any> = value as! Array<Any>;
                for (j, tmp) in arrayValue.enumerated()
                {
                    let tmpDic : Dictionary<String , String> = tmp as! Dictionary<String, String>;
                    let arrayAllKeys = tmpDic.keys;
                    for tmpKey in arrayAllKeys
                    {
                        if (i == 0 && j == 0)
                        {
                            tmpRequestDataString.append("\(tmpKey)=\(tmpDic[tmpKey]!)");
                        }
                        else
                        {
                            tmpRequestDataString.append("&\(tmpKey)=\(tmpDic[tmpKey]!)");
                        }
                    }
                }
            }
            else
            {
                if (i == 0)
                {
                    tmpRequestDataString.append("\(key)=\(value)")
                }
                else
                {
                    tmpRequestDataString.append("&\(key)=\(value)")
                }
            }
        }
        return tmpRequestDataString;
    }
    
    func httpLogCollectionMark() -> String {
        return "1";
    }
    
    func httpRequestResultWithItem(item: BaseHttpItem) -> HTTPRequestResultType {
        if (item.httpRequestResponseData! is Dictionary<String, Any>)
        {
            let tmpResponseData : Dictionary<String, Any> = item.httpRequestResponseData as! Dictionary<String, Any>;
            if (item.httpRequestStatusCode == 200 && (tmpResponseData.count > 0 && tmpResponseData["status"] == nil || (tmpResponseData["status"] as! Int) == 1))
            {
                return HTTPRequestResultType.Successed;
            }
        }
        return HTTPRequestResultType.Failed;
    }
    
    func httpPhotoDomainUrlWithUrl(photoUrl: String) -> String {
        return "";
    }
    
    func httpRequestCacheMarkWithHttpItem(item: BaseHttpItem) -> String {
        let identifier = Bundle.main.object(forInfoDictionaryKey: String(kCFBundleIdentifierKey))!;
        let versionStr = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!;
        return "CACHEKEY-\(identifier)-\(versionStr)-\(item.httpRequestAbsoluteUrlString.replacingOccurrences(of: "/", with: "-"))-CACHEKEY";
    }
    
    func displayItemInformationWithItem(item: BaseHttpItem) -> String {
        var responseType : String = "";
        var result : String = "";
        switch item.httpResponseDataType
        {
            case .LoadedFromServer:
                responseType = "服务器";
            case .LoadedFromLocalCache:
                responseType = "本地缓存";
            case .UnknownType:
                responseType = "出错信息";
            case .LoadedFromMockingResponse:
                responseType = "本地模拟数据"
        }
        
        if (item.httpRequestResponseData is Dictionary<String, Any>)
        {
            let responseData : Dictionary<String, Any> = item.httpRequestResponseData as! Dictionary<String, Any>;
            result = "当前业务接口为：\(item.descriptionItem()),请求的接口为：\(item.httpRequestAbsoluteUrlString),请求方式为：\(item.httpRequestMethodString), \(item.httpRequestMethodString)的数据为：\(String(describing: item.httpRequestPostParams.descriptionWithLocale)), 头信息为：\(item.httpRequestHeaderParams) 得到的数据为：\(responseData.descriptionWithLocale()),http状态码为：\(item.httpRequestStatusCode),数据来源：\(responseType),调试信息为：\(item.httpRequestDebugErrorMessage),服务器原数据:\(item.httpRequestResponseDataJson)"
        }
        return result;
    }
    
    func isSuccessedRequestionWithItem(item: BaseHttpItem) -> Bool {
        if (item.httpRequestStatusCode == 200 || item.httpRequestStatusCode == 444 || item.httpRequestStatusCode == 445)
        {
            return true;
        }
        return false;
    }
    
    
}
