//
//  Http500StatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class Http500StatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = 500;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "服务端的问题，去找后台。";
        self.httpRequestStatusCodeErrorMessage = "服务器内部错误";
        super.updatedItemWithHttpItem(item: item);
    }
}
