//
//  BaseDataModel.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation
import HandyJSON

open class BaseDataModel : HandyJSON{
    
    required public init() {
        
    }

    func displayAllAttributed() -> Void {
        print("displayAllAttributed called");
    }
}
