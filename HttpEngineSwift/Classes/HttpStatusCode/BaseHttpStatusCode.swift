//
//  BaseHttpStatusCode.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation

class BaseHttpStatusCode {
    var httpRequestStatusCodeErrorMessage : String = "";
    var httpRequestStatusCodeDebugErrorMessage : String = "";
    var httpRequestStatusCode : Int = HTTPStatusCode.NoneError.rawValue;
    
    func matchingWithStatusCode(statusCode : Int , item: BaseHttpItem) -> Void {
        if (statusCode != self.httpRequestStatusCode)
        {
            item.httpRequestStatusCode = statusCode;
            return;
        }
        
        self.updatedItemWithHttpItem(item: item)
    }
    
    func updatedItemWithHttpItem(item : BaseHttpItem) -> Void {
        item.httpRequestStatusCode = self.httpRequestStatusCode;
        item.httpRequestErrorMessage = self.httpRequestStatusCodeErrorMessage;
        item.httpRequestDebugErrorMessage = self.httpRequestStatusCodeDebugErrorMessage;
    }
}
