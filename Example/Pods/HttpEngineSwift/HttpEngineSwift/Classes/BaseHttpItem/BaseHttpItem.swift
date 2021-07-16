//
//  BaseHttpItem.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/9.
//

import Foundation

class BaseHttpItem : HttpSessionDataTaskDataSource {
    var httpRequestPostParams: Dictionary<String, String>{
        get{
            return [:]
        }
    }
    
    var httpReqeustDomainUrl : String{
        get {
            return BaseHttpConfigManager.shareHttpConfigManager().config!.configBaseHttpUrlWithHttpItem(item: self);
        }
    }
    
    var httpRequestAbsoluteUrlString : String{
        get{
            if (self.httpReqeustDomainUrl.count == 0 && self.httpRequestUrl.count == 0)
            {
                return "";
            }
            else
            {
                return BaseHttpConfigManager.shareHttpConfigManager().config!.httpRequestUrlWithHttpItem(item: self);
            }
        }
    }
    
    var httpRequestUrl : String = "";
    
    var httpRequestResponseData : Any? = nil;
    
    var httpRequestErrorMessage : String = "";
    
    var httpRequestDebugErrorMessage : String = "";
    
    var httpRequestCalledClassName : String{
        get{
            var mainCallStackSymbolMsg : String = "";
            let regularExpStr : String = "[-\\+]\\[.+\\]";
            
            var regularExp : NSRegularExpression?;
            do
            {
                regularExp = try NSRegularExpression.init(pattern: regularExpStr, options: NSRegularExpression.Options.caseInsensitive);
            }
            catch
            {
                return "";
            }
            
            let callStackSymbols : Array<String> = Thread.callStackSymbols;
            for index in 4..<callStackSymbols.count
            {
                let callStackSymbol = callStackSymbols[index];
                regularExp!.enumerateMatches(in: callStackSymbol, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, callStackSymbol.count), using: { (result : NSTextCheckingResult?, flags : NSRegularExpression.MatchingFlags, stop : UnsafeMutablePointer<ObjCBool>) in
                    if (result != nil)
                    {
                        let tempCallStackSymbolMsg : String = callStackSymbol.substring(with: callStackSymbol.MTRange(from: result!.range)!);
                        let className : String = tempCallStackSymbolMsg.components(separatedBy: " ").first!;
                        mainCallStackSymbolMsg = className.components(separatedBy: "[").last!;
                        
                        stop.pointee = true;
                    }
                })
            }
             
            
            return mainCallStackSymbolMsg;
        }
    }
    
    var httpRequestStatusCode : Int = HTTPStatusCode.DetaultCode.rawValue;
   
    var httpRequestStatus : HTTPRequestStatus = HTTPRequestStatus.Prepared;
    
    var httpRequestResponseDataJson : String = "";
    
    var httpRequestType : HTTPRequestType = HTTPRequestType.RequestJsonDataType;
    
    var _httpRequestMethod : HTTPMethod = HTTPMethod.GET;
    var httpRequestMethod : HTTPMethod{
        set{
            var method = "";
            _httpRequestMethod = newValue;
            switch _httpRequestMethod
            {
                case .POST:
                    method = HTTPWAYPOST;
                case .GET:
                    method = HTTPWAYGET;
                case .PUT:
                    method = HTTPWAYPUT;
                case .DELETE:
                    method = HTTPWAYDELETE;
            }
            
            self.httpRequestMethodString = method;
        }
        get{
            return _httpRequestMethod;
        }
    }
    
    var httpResponseDataType : HTTPResponseDataType = HTTPResponseDataType.UnknownType;
    
    var httpRequestMethodString : String = "";
    
    var httpRequestTimeoutCount : Int{
        get{
            return BaseHttpConfigManager.shareHttpConfigManager().config!.httpRequestTimeoutCount();
        }
    }

    var httpRequestConnectedStatus : HTTPConnectionCompletedStatus{
        get{
            var _httpRequestConnectStatus : HTTPConnectionCompletedStatus? = nil;
            var isSuccessed : Bool = false;
            if ((BaseHttpConfigManager.shareHttpConfigManager().config?.isSuccessedRequestionWithItem(item: self)) == true)
            {
                isSuccessed = BaseHttpConfigManager.shareHttpConfigManager().config!.isSuccessedRequestionWithItem(item: self);
            }
            else
            {
                isSuccessed = self.httpRequestStatusCode >= 200 && self.httpRequestStatusCode <= 299;
            }
            if (isSuccessed)
            {
                if (self.httpRequestType == HTTPRequestType.RequestJsonDataType)
                {
                    let httpRequestType : HTTPRequestResultType = BaseHttpConfigManager.shareHttpConfigManager().config!.httpRequestResultWithItem(item: self);
                    switch httpRequestType
                    {
                        case HTTPRequestResultType.Successed:
                            _httpRequestConnectStatus = HTTPConnectionCompletedStatus.ConnectedSuccessed;
                        case HTTPRequestResultType.Failed:
                            _httpRequestConnectStatus = HTTPConnectionCompletedStatus.ConnectedException;
                        case .AnotherType:
                            _httpRequestConnectStatus = HTTPConnectionCompletedStatus.ConnectedFailed;
                            fallthrough;
                        default:
                            break;
                    }
                }
                else
                {
                    _httpRequestConnectStatus = HTTPConnectionCompletedStatus.ConnectedSuccessed;
                }
            }
            else if (self.httpRequestStatusCode >= 400 && self.httpRequestStatusCode <= 599)
            {
                _httpRequestConnectStatus = HTTPConnectionCompletedStatus.ConnectedFailed;
            }
            else if (self.httpRequestStatusCode > 60000)
            {
                _httpRequestConnectStatus = HTTPConnectionCompletedStatus.ConnectedFailed;
            }
            else
            {
                _httpRequestConnectStatus = HTTPConnectionCompletedStatus.ConnectedFailed;
            }
            return _httpRequestConnectStatus!;
        }
        set{
            
        }
    }
    
    var httpItemCallBackSelector : Selector{
        get{
            var methodName = "";
            if (self.httpRequestStatus == HTTPRequestStatus.Connecting)
            {
                switch self.httpRepeatActionType
                {
                    case HTTPRepeatActionType.Uploading:
                        methodName = "httpRequestUploadProgressValueWithItem:";
                    case HTTPRepeatActionType.Downloading:
                        methodName = "httpRequestDownloadProgressValueWithItem:";
                    default:
                        break;
                }
            }
            else if (self.httpRequestStatus == HTTPRequestStatus.HasFinished)
            {
                switch self.httpRequestConnectedStatus
                {
                    case HTTPConnectionCompletedStatus.ConnectedException:
                        methodName = "httpRequestCompletedExceptionWithItem:"
                    case HTTPConnectionCompletedStatus.ConnectedSuccessed:
                        methodName = "httpRequestCompletedWithItem:";
                    case HTTPConnectionCompletedStatus.ConnectedFailed:
                        methodName = "httpRequestFailedWitItem:";
                    default:
                        break;
                }
            }
            
            let selector : Selector = Selector.init(methodName);
            return selector;
        }
    }
    
    var httpRepeatActionType : HTTPRepeatActionType = HTTPRepeatActionType.None;
    
    var httpRequestPostParasString : String{
        get{
            return BaseHttpConfigManager.shareHttpConfigManager().config!.httpRequestPostParamsWithHttpItem(item: self);
        }
    }
    
    var httpRequestDownloadPercent : String? = "";
    
    var httpRequestCacheMark : String{
        get{
            return BaseHttpConfigManager.shareHttpConfigManager().config!.httpRequestCacheMarkWithHttpItem(item: self);
        }
    }
    
    var httpRequestHeaderParams: Dictionary<String, String>{
        get{
            return BaseHttpConfigManager.shareHttpConfigManager().config!.headerRequestDictionary();
        }
    }
        
    var httpRequestCacheType: HTTPCacheType = HTTPCacheType.ServerOnly;
    
    var httpRequestAcceptableContentTypes: Array<String>{
        get{
            return BaseHttpConfigManager.shareHttpConfigManager().config!.httpRequestAcceptableContentTypes();
        }
        
        set(newValue){
            
        }
    }
    
    var httpResponseIsMockStatus: Bool = false;
    
    var httpReuqestShouldAddSelfToLog: Bool = false;
    
    func httpRequestDownloadProgressValueWithItem(item: BaseHttpItem) {
        return;
    }
    
    func mocksJsonData() -> String {
        return "";
    }
    
    func httpRequestCompletedExceptionWithItem(item: BaseHttpItem) -> Void {
        return;
    }
    
    func httpRequestCompletedWithItem(item : BaseHttpItem) -> Void {
        return;
    }
    
    func httpRequestFailedWitItem(item : BaseHttpItem) -> Void {
        return;
    }
    
    func cancelHttpRequest() -> Void {
        //TODO
    }
    
    func descriptionItem() -> String {
        return "";
    }
    
    func displayItemInformation() -> String {
        return "";
    }
     
}
