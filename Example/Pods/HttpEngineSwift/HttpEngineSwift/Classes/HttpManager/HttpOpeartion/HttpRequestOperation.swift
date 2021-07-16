//
//  HttpRequestOperation.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class HttpRequestOperation : Operation {
    
    let kLockedKey : Int = 1;
    
    private(set) var item : BaseHttpItem?;
    
    private(set) var operationIndentity : String?;
    
    var statusCodesArray : Array<AnyClass>{
        get{
            let classNameArray : Array<AnyClass> = [classFromString(className: "BaseHttpStatusCode"),classFromString(className: "Http200StatusCode"),classFromString(className: "Http400StatusCode"),classFromString(className: "Http401StatusCode"),classFromString(className: "Http404StatusCode"),classFromString(className: "Http422StatusCode"),classFromString(className: "Http500StatusCode"),classFromString(className: "HttpNoNetworkStatusCode"),classFromString(className: "HttpRequestConnectedFailedStatusCode"),classFromString(className: "HttpRequestNoneConfigFileStatusCode"),classFromString(className: "HttpRequestUrlIsNilStatusCode"),classFromString(className: "HttpResponseCanNotBeParsedStatusCode"),classFromString(className: "HttpResponseIsNilStatusCode")];
            return classNameArray;
        }
    }
    
    var httpRequestOperationFinishedBlock : ((BaseHttpItem) -> Void)?;
     
    var requestLockerManager : NSConditionLock? = nil;
    
    lazy var httpUrlRequest : URLRequest = URLRequest.init(url: URL.init(string: "")!);
    
    init(item : BaseHttpItem , block : @escaping (BaseHttpItem) -> Void) {
        self.item = item;
        self.operationIndentity = "itemIndentity_\(object_getClassName(self.item))"
        self.requestLockerManager = NSConditionLock.init(condition: kLockedKey);
        
        self.httpRequestOperationFinishedBlock = block; 
    }
    
    func initWith(item : BaseHttpItem , block : @escaping (BaseHttpItem) -> Void) -> HttpRequestOperation {
        self.item = item;
        self.operationIndentity = "itemIndentity_\(object_getClassName(self.item))"
        self.requestLockerManager = NSConditionLock.init(condition: kLockedKey);
        self.httpRequestOperationFinishedBlock = block;
        block (self.item!);
        return self;
    }
    
    //start http request
    override func main() {
        startHttpRequest();
    }
    
    //http request start lunch
    func startHttpRequest() -> Void {
        self.item!.httpRequestStatus = HTTPRequestStatus.Connecting;
        self.httpUrlRequest.timeoutInterval = TimeInterval(self.item!.httpRequestTimeoutCount);
        self.httpUrlRequest.url = httpRequestAppendsUrl();
        switch item!.httpRequestMethod
        {
            case HTTPMethod.POST:
                self.httpUrlRequest.httpBody = httpPostBodyAppendsData();
            default:
                break
        }
        
        self.httpUrlRequest.httpMethod = self.item?.httpRequestMethodString;
         
        addHttpRequestHeaderValue();
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        }
         
        let dataTask : URLSessionDataTask = URLSession.shared.dataTask(with: self.httpUrlRequest) {[unowned self](data : Data?, response : URLResponse?, error : Error?) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            }
            
            DispatchQueue.main.async {
                self.requestLockerManager?.unlock(withCondition: self.kLockedKey);
            }
            
            if (response != nil)
            {
                let httpResponse : HTTPURLResponse = response as! HTTPURLResponse;
                updateErrorMessageWithStatusCode(statusCode: httpResponse.statusCode);
                self.item?.httpRequestResponseData = nil;
                
                if (data == nil && (error != nil))
                {
                    operationFinishedThenSendingBlockToSuper();
                }
                else
                {
                    if (data != nil)
                    {
                        //parse data to dictionary
                        self.item?.httpRequestResponseDataJson = String.init(data: data!, encoding: String.Encoding.utf8)!;
                        let requestResponse : Any? = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers);
                        if (requestResponse == nil)
                        {
                            operationFinishedThenSendingBlockToSuper();
                            return;
                        }
                        
                        if (requestResponse is String)
                        {
                            let tmpRequestResponse : String = requestResponse as! String;
                            let jsonData : Data = tmpRequestResponse.data(using: String.Encoding.utf8)!;
                            self.item!.httpRequestResponseData = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers);
                            if (self.item!.httpRequestResponseData == nil)
                            {
                                updateErrorMessageWithStatusCode(statusCode: HTTPStatusCode.ParseError.rawValue);
                                operationFinishedThenSendingBlockToSuper();
                                return;
                            }
                        }
                        else if (requestResponse is Dictionary<String, Any> || requestResponse is Array<Any>)
                        {
                            self.item?.httpRequestResponseData = requestResponse;
                        }
                        
                        operationFinishedThenSendingBlockToSuper();
                    }
                    else
                    {
                        updateErrorMessageWithStatusCode(statusCode: HTTPStatusCode.ResponseDataIsNil.rawValue);
                        operationFinishedThenSendingBlockToSuper();
                    }
                }
            }
            else
            {
                updateErrorMessageWithStatusCode(statusCode: HTTPStatusCode.NoNetwork.rawValue);
                operationFinishedThenSendingBlockToSuper();
            }
        };
        
        dataTask.resume();
        DispatchQueue.main.async {
            self.requestLockerManager!.lock(whenCondition: self.kLockedKey);
        }
    }
    
    
    func httpRequestAppendsUrl() -> URL {
        return URL.init(string: self.item!.httpRequestAbsoluteUrlString)!;
    }
    
    
    func httpPostBodyAppendsData() -> Data {
        if (self.item!.httpRequestPostParams.count > 0)
        {
            let httpPostDataString : String = self.item!.httpRequestPostParasString;
            let postBodyData : Data = httpPostDataString.data(using: String.Encoding.utf8)!;
            return postBodyData;
        }
        return Data.init();
    }
    
    
    func addHttpRequestHeaderValue() -> Void {
        let header : Dictionary<String, Any> = requestHeaderParams();
        for key in header.keys {
            let headerValue : String = header[key] as! String;
            self.httpUrlRequest.addValue(headerValue, forHTTPHeaderField: key);
        }
        self.httpUrlRequest.addValue(acceptTypeAppendsString(), forHTTPHeaderField: "Accept");
    }
    
    
    func requestHeaderParams() -> Dictionary<String, Any> {
        return self.item!.httpRequestHeaderParams;
    }
    
    func acceptTypeAppendsString() -> String {
        //add response content-type
        var acceptType : String = "*/*";
        if (self.item!.httpRequestAcceptableContentTypes.count > 0)
        {
            acceptType = "";
            for (index ,acceptString) in self.item!.httpRequestAcceptableContentTypes.enumerated() {
                if (index == self.item!.httpRequestAcceptableContentTypes.count - 1)
                {
                    acceptType.append(acceptString);
                }
                else
                {
                    acceptType.append("\(acceptString),");
                }
            }
        }
        return acceptType;
    }
     
    func updateErrorMessageWithStatusCode(statusCode : Int) -> Void {
        for _ in 0...self.statusCodesArray.count
        {
            let statusCodeBaseClass : BaseHttpStatusCode = BaseHttpStatusCode.init();
            statusCodeBaseClass.matchingWithStatusCode(statusCode: statusCode, item: self.item!);
        }
    }
    
    func operationFinishedThenSendingBlockToSuper() -> Void {
        self.httpRequestOperationFinishedBlock?(self.item!);
    }
    
    deinit {
        self.httpRequestOperationFinishedBlock = nil;
    }

}
