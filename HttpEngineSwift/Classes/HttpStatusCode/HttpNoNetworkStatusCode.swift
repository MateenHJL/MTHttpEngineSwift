//
//  HttpNoNetworkStatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class HttpNoNetworkStatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = HTTPStatusCode.NoNetwork.rawValue;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "当前没网络";
        self.httpRequestStatusCodeErrorMessage = "网络异常";
        super.updatedItemWithHttpItem(item: item);
    }
}
