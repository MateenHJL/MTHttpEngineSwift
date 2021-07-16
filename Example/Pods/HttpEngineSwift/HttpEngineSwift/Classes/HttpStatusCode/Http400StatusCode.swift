//
//  Http400StatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class Http400StatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = 400;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "服务器不理解请求的语法。";
        self.httpRequestStatusCodeErrorMessage = "通信错误";
        super.updatedItemWithHttpItem(item: item);
    }
}
