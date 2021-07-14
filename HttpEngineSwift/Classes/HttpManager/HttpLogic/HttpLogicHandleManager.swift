//
//  CacheLogicHandleManager.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation
import Reachability

class HttpLogicHandleManager {
    //check your network can reachability.
    static func networkCanBeReached() -> Bool {
        let reach : Reachability = try! Reachability.init();
        let status = (reach.connection != .unavailable || reach.connection != .none)
        return status;
    }
    
    //check your HttpUrl
    static func isHttpUrlCorrectWithItem(item : BaseHttpItem) -> Bool {
        var result : Bool = true;
        if (item.httpRequestAbsoluteUrlString.count == 0)
        {
            result = false;
        }
        return result;
    }
    
    //current response is mocking status
    static func isMockResponseStatusWithItem(item : BaseHttpItem) -> Bool {
        var result : Bool = true;
        if (!item.httpResponseIsMockStatus)
        {
            result = false;
        }
        return result;
    }
}
