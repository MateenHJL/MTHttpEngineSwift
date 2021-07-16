//
//  HttpResponseIsNilStatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class HttpResponseIsNilStatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = HTTPStatusCode.ResponseDataIsNil.rawValue;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "服务端返回的数据是nil";
        self.httpRequestStatusCodeErrorMessage = "服务器出错，请联系客服";
        super.updatedItemWithHttpItem(item: item);
    }
}
