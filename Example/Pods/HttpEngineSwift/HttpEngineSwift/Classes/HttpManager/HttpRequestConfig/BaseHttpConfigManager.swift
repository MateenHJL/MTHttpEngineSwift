//
//  BaseHttpConfigManager.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation
import Reachability

class BaseHttpConfigManager : NSObject {
    
    static let manager = BaseHttpConfigManager();
        
    weak open private(set) var config : HttpConfigDataSource?;
    
    static func shareHttpConfigManager () -> BaseHttpConfigManager{
        return manager;
    }
    
    private override init(){
        print("BaseHttpConfigManager init");
    }
    
    override func copy() -> Any {
        return self;
    }
    
    override func mutableCopy() -> Any {
        return self;
    }
    
    func setupHttpEngineWithConfig(config : HttpConfigDataSource) -> Void{
        self.config = config;
        try! Reachability().startNotifier();
    }
}
