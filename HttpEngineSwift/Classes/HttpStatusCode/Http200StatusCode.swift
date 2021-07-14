//
//  Http200StatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class Http200StatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = HTTPStatusCode.NoneError.rawValue;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCode = HTTPStatusCode.NoneError.rawValue;
        self.httpRequestStatusCodeDebugErrorMessage = "通信成功";
        self.httpRequestStatusCodeErrorMessage = "";
        super.updatedItemWithHttpItem(item: item);
    }
}
