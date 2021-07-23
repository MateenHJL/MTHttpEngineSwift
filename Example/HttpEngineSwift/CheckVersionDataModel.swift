//
//  CheckVersionDataModel.swift
//  HttpEngineSwift_Example
//
//  Created by Sumansoul on 2021/7/15.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import HttpEngineSwift
import HandyJSON

open class CheckVersionEntity : BaseDataModel {
    var info : String?;
    var data : CheckVersionDataModel?;
}

open class CheckVersionDataModel: BaseDataModel {
    var content : String?;
    var version : String?;
    var link : String?;
}
