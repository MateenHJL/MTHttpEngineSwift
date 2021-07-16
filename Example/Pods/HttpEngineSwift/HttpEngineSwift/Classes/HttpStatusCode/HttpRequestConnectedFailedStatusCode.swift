//
//  HttpRequestConnectedFailedStatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class HttpRequestConnectedFailedStatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = HTTPStatusCode.ConnectedFailed.rawValue;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "与服务器通信错误";
        self.httpRequestStatusCodeErrorMessage = "当前网络不给力，请检查网络";
        super.updatedItemWithHttpItem(item: item);
    }
}
