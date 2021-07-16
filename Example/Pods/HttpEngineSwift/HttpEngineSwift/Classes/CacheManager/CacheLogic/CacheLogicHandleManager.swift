//
//  CacheLogicHandleManager.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation

class CacheLogicHandleManager {
    
    //check need loaded localCache from CacheEngine
    static func needLoadCacheFromCacheEngineWithItem(item : BaseHttpItem) -> Bool {
        var result = false;
        if (item.httpRequestCacheType == HTTPCacheType.CacheOnly || item.httpRequestCacheType == HTTPCacheType.DataThenServerData)
        {
            result = true;
        }
        return result;
    }
    
    //check wether your data is exist in your sandbox.
    static func localCacheIsExistsWithItem(item : BaseHttpItem) -> Bool{
        var result = false;
        if (CacheEngine.localCacheIsExistsWithMarkKeyFileName(fileName: item.httpRequestCacheMark))
        {
            result = true;
        }
        return result;
    }
    
    //check it should be loaded data from sandbox first.
    static func shouldSaveLocalCacheWithItem(item : BaseHttpItem) -> Bool{
        var result = false;
        if (item.httpRequestCacheType == HTTPCacheType.CacheOnly || item.httpRequestCacheType == HTTPCacheType.DataThenServerData)
        {
            result = true;
        }
        return result;
    }
    
    //check your request need be continued,it's depends on what httpRequestCacheType is.
    static func needBeContinueRequestWithHttpItem(item : BaseHttpItem) -> Bool{
        var result = false;
        if (item.httpRequestCacheType == HTTPCacheType.CacheOnly || item.httpRequestCacheType == HTTPCacheType.DataThenServerData)
        {
            result = true;
        }
        return result;
    }
    
    //check your response data is nil and correctable format
    static func canBeSavedToLocalFiledWithHttpItem(item : BaseHttpItem) -> Bool{
        var result = false;
        if (item.httpRequestResponseData is Dictionary<String, Any> && item.httpRequestConnectedStatus == HTTPConnectionCompletedStatus.ConnectedSuccessed)
        {
            result = true;
        }
        return result;
    }
    
    //should show in log
    static func shouldSaveHttpNetworkLogWithItem(item : BaseHttpItem) -> Bool{
        var result = false;
        if (item.httpRequestConnectedStatus != HTTPConnectionCompletedStatus.ConnectedSuccessed)
        {
            result = true;
        }
        return result;
    }
}
