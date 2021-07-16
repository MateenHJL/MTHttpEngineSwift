//
//  Http401StatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class Http401StatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = 401;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "请求要求身份验证。 对于需要登录的网页，服务器可能返回此响应。";
        self.httpRequestStatusCodeErrorMessage = "通信错误";
        super.updatedItemWithHttpItem(item: item);
    }
}
