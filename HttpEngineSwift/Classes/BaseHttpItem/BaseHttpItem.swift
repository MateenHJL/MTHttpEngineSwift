//
//  BaseHttpItem.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/9.
//

import Foundation

public typealias httpSuccessfulBlock<T> = ((T) -> Void)?;
public typealias httpFailedBlock = ((CommonLogicDataModel) -> Void)?;

open class BaseHttpItem : NSObject, HttpSessionDataTaskDataSource {
    public override init() {
        
    }
    
    deinit {
        print("\(self.className()) has been dealloc");
    }
    
    public var httpRequestPostParams: Dictionary<String, String>{
        get{
            return [:]
        }
    }
    
    public var httpReqeustDomainUrl : String{
        get {
            return BaseHttpConfigManager.shareHttpConfigManager().config!.configBaseHttpUrlWithHttpItem(item: self);
        }
    }
    
    public var httpRequestAbsoluteUrlString : String{
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
    
    public var httpRequestUrl : String = "";
    
    public var httpRequestResponseData : Any? = nil;
    
    public var httpRequestErrorMessage : String = "";
    
    public var httpRequestDebugErrorMessage : String = "";
    
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
    
    public var httpRequestStatusCode : Int = HTTPStatusCode.DetaultCode.rawValue;
   
    var httpRequestStatus : HTTPRequestStatus = HTTPRequestStatus.Prepared;
    
    public var httpRequestResponseDataJson : String = "";
    
    var httpRequestType : HTTPRequestType = HTTPRequestType.RequestJsonDataType;
    
    var _httpRequestMethod : HTTPMethod = HTTPMethod.GET;
    public var httpRequestMethod : HTTPMethod{
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
    
    public var httpResponseDataType : HTTPResponseDataType = HTTPResponseDataType.UnknownType;
    
    public var httpRequestMethodString : String = "";
    
    var httpRequestTimeoutCount : Int{
        get{
            return BaseHttpConfigManager.shareHttpConfigManager().config?.httpRequestTimeoutCount() ?? 15;
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
    
    public var httpRequestHeaderParams: Dictionary<String, String>{
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
    
    open var httpReuqestShouldAddSelfToLog: Bool{
        get {
            return BaseHttpConfigManager.shareHttpConfigManager().config.httpRequestShouldSaveToLocalDB(item: self);
        }
    }
    
    func httpRequestDownloadProgressValueWithItem(item: BaseHttpItem) {
        return;
    }
    
    func mocksJsonData() -> String {
        return "";
    }
    
    open func httpRequestCompletedExceptionWithItem(item: BaseHttpItem) -> Void {
        
    }
    
    open func httpRequestCompletedWithItem(item : BaseHttpItem) -> Void {
        
    }
    
    open func httpRequestFailedWitItem(item : BaseHttpItem) -> Void {
        
    }
    
    func cancelHttpRequest() -> Void {
        HttpEngine.shareHttpEngine().cancelHttpRequestWithItem(item: self);
    }
    
    open func descriptionItem() -> String {
        return "";
    }
    
    func displayItemInformation() -> String {
        return BaseHttpConfigManager.shareHttpConfigManager().config!.displayItemInformationWithItem(item: self);
    }
    
    func execSelector() -> Void{
        if (self.httpRequestStatus == HTTPRequestStatus.Connecting)
        {
            switch self.httpRepeatActionType
            {
            //TODO
            case HTTPRepeatActionType.Uploading: break
//                    methodName = "httpRequestUploadProgressValueWithItem:";
            case HTTPRepeatActionType.Downloading: break
//                    methodName = "httpRequestDownloadProgressValueWithItem:";
                default:
                    break;
            }
        }
        else if (self.httpRequestStatus == HTTPRequestStatus.HasFinished)
        {
            switch self.httpRequestConnectedStatus
            {
                case HTTPConnectionCompletedStatus.ConnectedException:
                    httpRequestCompletedExceptionWithItem(item: self);
                case HTTPConnectionCompletedStatus.ConnectedSuccessed:
                    httpRequestCompletedWithItem(item: self);
                case HTTPConnectionCompletedStatus.ConnectedFailed:
                    httpRequestFailedWitItem(item: self);
                default:
                    break;
            }
        }
    }
}
