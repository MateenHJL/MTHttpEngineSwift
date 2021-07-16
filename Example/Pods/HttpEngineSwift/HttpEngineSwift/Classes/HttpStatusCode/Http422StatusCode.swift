//
//  Http422StatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class Http422StatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = 422;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "客户端请求数据组织错误";
        self.httpRequestStatusCodeErrorMessage = "通信错误";
        super.updatedItemWithHttpItem(item: item);
    }
}
