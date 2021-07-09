//
//  BaseHttpItem.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/9.
//

import Foundation
import HttpMacro

class BaseHttpItem{
    var httpReqeustDomainUrl : String;
    var httpRequestAbsoluteUrlString : String;
    var httpRequestUrl : String;
    var httpRequestResponseData : Any;
    var httpRequestErrorMessage : String;
    var httpRequestDebugErrorMessage : String;
    var httpRequestCalledClassName : String;
    var httpRequestStatusCode : HTTPStatusCode;
    var httpRequestStatus : HTTPRequestStatus;
    var httpRequestResponseDataJson : String;
    var httpRequestType : HTTPRequestType;
    var httpRequestMethod : HTTPMethod;
    var httpResponseDataType : HTTPResponseDataType;
    var httpRequestMethodString : String;
    var httpRequestTimeoutCount : Int;
    var httpRequestConnectedStatus : HTTPConnectionCompletedStatus = HTTPConnectionCompletedStatusUnknowStatus;
    var httpItemCallBackSelector : Selector;
    var httpRepeartActionType : HTTPRepeatActionType;
    var httpRequestPostParasString : String;
    var httpRequestDownloadPercent : String;
    var httpRequestCacheMark : String;
    
    func httpRequestCompletedExceptionWithItem(item: BaseHttpItem) -> Void {
        
    }
    
    func httpRequestCompletedWithItem(item : BaseHttpItem) -> Void {
        
    }
    
    func httpRequestFailedWitItem(item : BaseHttpItem) -> Void {
        
    }
    
    func cancelHttpRequest() -> Void {
        
    }
    
    func descriptionItem() -> String {
    
    }
    
    func displayItemInformation() -> String {
        
    }
}
