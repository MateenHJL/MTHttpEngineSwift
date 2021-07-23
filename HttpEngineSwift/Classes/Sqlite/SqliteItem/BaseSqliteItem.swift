//
//  BaseSqliteItem.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/15.
//

import Foundation

open class BaseSqliteItem : NSObject {
    public var operateStatement : String?;
    public var configTableStatement : String?;
    public var dataType : HttpLogInfomationDataModeType?;
}
