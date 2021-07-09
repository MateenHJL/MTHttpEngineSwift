//
//  HttpSessionRequestConfig.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/9.
//

import Foundation
    
//http request protocol
protocol HttpSessionDataTaskDataSource {
    var httpRequestHeaderParams : Dictionary<String, String> { get set };
    var httpRequestPostParams : Dictionary<String, String> { get set };
    var httpRequestCacheType : HTTPCacheType { get set };
    var httpRequestCacheMark : String {get};
    var httpRequestAcceptableContentTypes : Array<String>{ get set};
    var httpResponseIsMockStatus : Bool{ get set};
    var httpReuqestShouldAddSelfToLog : Bool{ get set};

    func httpRequestDownloadProgressValueWithItem(item : BaseHttpItem) -> Void;
    func mocksJsonData() -> String;
}
