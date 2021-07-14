//
//  HttpRequestUrlIsNilStatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class HttpRequestUrlIsNilStatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = HTTPStatusCode.RequestUrlIsNilOrNotCorrect.rawValue;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "请求的url为空或者格式不正确";
        self.httpRequestStatusCodeErrorMessage = "请求数据错误";
        super.updatedItemWithHttpItem(item: item);
    }
}
