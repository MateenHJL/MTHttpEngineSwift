//
//  HttpSessionRequestConfig.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/9.
//

import Foundation
    
//http request protocol
protocol HttpSessionDataTaskDataSource : class{
    var httpRequestHeaderParams : Dictionary<String, String>{get};
    var httpRequestPostParams : Dictionary<String, String> { get};
    var httpRequestCacheType : HTTPCacheType { get set };
    var httpRequestCacheMark : String {get};
    var httpRequestAcceptableContentTypes : Array<String>{ get set};
    var httpResponseIsMockStatus : Bool{ get set};
    var httpReuqestShouldAddSelfToLog : Bool{ get };

    func httpRequestDownloadProgressValueWithItem(item : BaseHttpItem) -> Void;
    func mocksJsonData() -> String;
}

public protocol HttpConfigDataSource : class {
    func httpRequestShouldSaveToLocalDB (item : BaseHttpItem) -> Bool;
    func configBaseHttpUrlWithHttpItem(item : BaseHttpItem) -> String;
    func headerRequestDictionary() -> Dictionary<String, String>;
    func httpRequestTimeoutCount() -> Int;
    func httpRequestAcceptableContentTypes() -> Array<String>;
    func httpRequestUrlWithHttpItem(item : BaseHttpItem) -> String;
    func httpRequestPostParamsWithHttpItem(item : BaseHttpItem) -> String;
    func httpLogCollectionMark() -> String;
    func httpRequestResultWithItem(item : BaseHttpItem) -> HTTPRequestResultType;
    func httpPhotoDomainUrlWithUrl(photoUrl: String) -> String;
    func httpRequestCacheMarkWithHttpItem(item : BaseHttpItem) -> String;
    func displayItemInformationWithItem(item : BaseHttpItem) -> String;
    func isSuccessedRequestionWithItem(item : BaseHttpItem) -> Bool;
}
