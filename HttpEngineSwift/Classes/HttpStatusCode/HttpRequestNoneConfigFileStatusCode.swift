//
//  HttpRequestNoneConfigFileStatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/13.
//

import Foundation

class HttpRequestNoneConfigFileStatusCode: BaseHttpStatusCode {
    override init(){
        super.init();
        self.httpRequestStatusCode = HTTPStatusCode.NoConfigFile.rawValue;
    }
    
    override func updatedItemWithHttpItem(item: BaseHttpItem) {
        self.httpRequestStatusCodeDebugErrorMessage = "在app启动的时候，没有添加config文件";
        self.httpRequestStatusCodeErrorMessage = "系统出错，请联系管理员";
        super.updatedItemWithHttpItem(item: item);
    }
}
