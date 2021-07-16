//
//  HttpResponseCanNotBeParsedStatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class HttpResponseCanNotBeParsedStatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = HTTPStatusCode.ParseError.rawValue;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "服务端返回的数据非json数据，无法解析";
        self.httpRequestStatusCodeErrorMessage = "服务器出错，请联系客服";
        super.updatedItemWithHttpItem(item: item);
    }
}
