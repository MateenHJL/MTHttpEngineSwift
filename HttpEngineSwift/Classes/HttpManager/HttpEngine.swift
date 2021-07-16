//
//  HttpEngine.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation
import ISRemoveNull

open class HttpEngine : NSObject {
    
    lazy var operationQueue : OperationQueue = OperationQueue.init();
    
    static let engine = HttpEngine();
    
    //init with SingleTon
    public static func shareHttpEngine () -> HttpEngine{
        return engine;
    }
    
    private override init(){
        super.init();
        self.operationQueue.maxConcurrentOperationCount = 10;
        print("HttpEngine init");
    }
    
    open override func copy() -> Any {
        return self;
    }
    
    open override func mutableCopy() -> Any {
        return self;
    }
    
    //execute http request with asynchronous
    open func startConnectionWithRequestItem(item: BaseHttpItem) -> Void {
        if (BaseHttpConfigManager.shareHttpConfigManager().config == nil)
        {
            print("there's no httpConfig in BaseHttpConfigManager,please called [[BaseHttpConfigManager shareHttpConfigManager] setupHttpEngineWithConfig:] when your application launched first");
            return;
        } 
        
        var queue : Operation? = nil;
        
        if (item.httpRequestType == HTTPRequestType.RequestJsonDataType)
        {
            //need be loaded localCache from CacheEngine?
            if (CacheLogicHandleManager.needLoadCacheFromCacheEngineWithItem(item: item))
            {
                //check your localData is existed from your sandbox
                if (CacheLogicHandleManager.localCacheIsExistsWithItem(item: item))
                {
                    item.httpRequestResponseData = CacheEngine.loadDataWithMarkKeyFileName(fileName: item.httpRequestCacheMark);
                    item.httpResponseDataType = HTTPResponseDataType.LoadedFromLocalCache;
                    item.httpRequestStatus = HTTPRequestStatus.HasFinished;
                    item.httpRequestStatusCode = HTTPStatusCode.NoneError.rawValue;
                    item.httpRequestCompletedWithItem(item: item);
                }
            }
            
            //check the status of network.
            if (!HttpLogicHandleManager.networkCanBeReached())
            {
                item.httpRequestStatus = HTTPRequestStatus.HasFinished;
                item.httpRequestStatusCode = HTTPStatusCode.NoNetwork.rawValue;
                item.httpRequestResponseData = nil;
                item.httpResponseDataType = HTTPResponseDataType.UnknownType;
                let statusCodeBase : BaseHttpStatusCode = HttpNoNetworkStatusCode.init();
                statusCodeBase.matchingWithStatusCode(statusCode: HTTPStatusCode.NoNetwork.rawValue, item: item);
                item.httpRequestFailedWitItem(item: item);
                print(item.displayItemInformation());
                return;
            }
            
            //wether you should request responseData from your server.
            if (CacheLogicHandleManager.needBeContinueRequestWithHttpItem(item: item))
            {
                //check your httpUrlString
                if (HttpLogicHandleManager.isHttpUrlCorrectWithItem(item: item))
                {
                    item.httpRequestStatus = HTTPRequestStatus.HasFinished;
                    item.httpRequestStatusCode = HTTPStatusCode.RequestUrlIsNilOrNotCorrect.rawValue;
                    item.httpRequestResponseData = nil;
                    let statusCodeBase : BaseHttpStatusCode = HttpRequestUrlIsNilStatusCode.init();
                    statusCodeBase.matchingWithStatusCode(statusCode: HTTPStatusCode.RequestUrlIsNilOrNotCorrect.rawValue, item: item);
                    item.httpRequestFailedWitItem(item: item);
                    print(item.displayItemInformation());
                    return;
                }
            }
            
            //current response status is loaded from local data which is mocked.?
            if (HttpLogicHandleManager.isMockResponseStatusWithItem(item: item))
            {
                item.httpRequestStatusCode = HTTPStatusCode.NoneError.rawValue;
                item.httpRequestStatus = HTTPRequestStatus.HasFinished;
                let stautsCodeBase : BaseHttpStatusCode = Http200StatusCode.init();
                stautsCodeBase.matchingWithStatusCode(statusCode: 200, item: item);
                let jsonData : Data = item.mocksJsonData().data(using: String.Encoding.utf8)!;
                item.httpRequestResponseData = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers);
                item.httpResponseDataType = HTTPResponseDataType.LoadedFromMockingResponse;
                item.execSelector();
                print(item.displayItemInformation());
                return;
            }
            
            queue = HttpRequestOperation.init(item: item) { (responsedItem : BaseHttpItem) in
                responsedItem.httpRequestStatus = HTTPRequestStatus.HasFinished;
                responsedItem.httpResponseDataType = HTTPResponseDataType.LoadedFromServer;
                
                //wether your data from server should be saved to sandbox
                if (CacheLogicHandleManager.shouldSaveLocalCacheWithItem(item: responsedItem))
                {
                    if (CacheLogicHandleManager.canBeSavedToLocalFiledWithHttpItem(item: responsedItem))
                    {
                        let tmpHttpRequestResponseData : Dictionary<String,Any> = responsedItem.httpRequestResponseData as! Dictionary<String,Any>;
                        let filterResponseData = tmpHttpRequestResponseData.MTdictionaryByRemovingNull();
                        CacheEngine.saveData(data: filterResponseData, fileName: responsedItem.httpRequestCacheMark);
                    }
                }
                
                if (CacheLogicHandleManager.shouldSaveHttpNetworkLogWithItem(item: responsedItem))
                {
                    let sqliteItem : BaseSqliteItem<BaseDataModel.Type> = HttpLogCollectionItem.convertHttpItemWithSqliteItemWithHttpItem(item: responsedItem);
                    SqliteEngine.shareEngine().excutedWithSqiteItem(item: sqliteItem) { (isSuccessed : Bool, operatedError : String) in
                        if (isSuccessed)
                        {
                            print("HttpLog信息保存成功");
                        }
                        else
                        {
                            print("HttpLog信息保存失败,失败信息：\(operatedError)");
                        }
                    }
                }
                
                
                responsedItem.execSelector();
                print(responsedItem.displayItemInformation());
            }
        }
        else if (item.httpRequestType == HTTPRequestType.FilesType)
        {
            
        }
        else
        {
            
        }
        
        self.operationQueue.addOperation(queue!);
    }
    
    //cancel http request
    func cancelHttpRequestWithItem(item : BaseHttpItem) -> Void {
        if (self.operationQueue.operationCount == 0)
        {
            return;
        }
        
        for operation in self.operationQueue.operations
        {
            let tmp = operation as! HttpRequestOperation;
            if (!tmp.isFinished && tmp.item!.httpRequestStatus == HTTPRequestStatus.Prepared && item === tmp.item!)
            {
                operation.cancel();
            }
        }
    }
    
    //cancel entire http request
    func cancelEntireHttpRequest() -> Void {
        self.operationQueue.cancelAllOperations();
    }
    
    //cancel the part of http request
    func cancelPartHttpRequestWithCalledName(calledName : String) -> Void {
        if (calledName.count > 0)
        {
            for operation in self.operationQueue.operations
            {
                let tmp = operation as! HttpRequestOperation;
                if (tmp.isReady)
                {
                    if (tmp.item?.httpRequestCalledClassName == calledName)
                    {
                        operation.cancel();
                    }
                }
            }
        }
    }
}


