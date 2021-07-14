//
//  Http404StatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class Http404StatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = 404;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "API接口没找到，请找对应文档";
        self.httpRequestStatusCodeErrorMessage = "通信错误";
        super.updatedItemWithHttpItem(item: item);
    }
}
