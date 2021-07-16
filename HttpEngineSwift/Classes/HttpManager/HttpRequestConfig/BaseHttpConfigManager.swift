//
//  BaseHttpConfigManager.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation
import Reachability

public class BaseHttpConfigManager : NSObject {
    
    static let manager = BaseHttpConfigManager();
        
    public var config : HttpConfigDataSource! = nil;
    
    public static func shareHttpConfigManager () -> BaseHttpConfigManager{
        return manager;
    }
    
    private override init(){
        print("BaseHttpConfigManager init");
    }
    
    public override func copy() -> Any {
        return self;
    }
    
    public override func mutableCopy() -> Any {
        return self;
    }
    
    public func setupHttpEngineWithConfig(config : HttpConfigDataSource) -> Void{
        self.config = config;
        try! Reachability().startNotifier();
        
        SqliteEngine.shareEngine().configTableInformationWithSqliteItem(item: HttpLogCollectionItem.createTableItem()()) { (isSuccessed : Bool, operatedError : String) in
            if (isSuccessed)
            {
                print("Http log收集器开启");
            }
        }
    }
}
