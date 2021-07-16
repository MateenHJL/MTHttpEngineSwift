//
//  CheckVersionDataModel.swift
//  HttpEngineSwift_Example
//
//  Created by Sumansoul on 2021/7/15.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import HttpEngineSwift

class CheckVersionEntity : BaseDataModel{
    @objc var info : String?;
    @objc var data : CheckVersionDataModel?;
}

class CheckVersionDataModel: BaseDataModel {
    @objc var content : String?;
    @objc var version : String?;
    @objc var link : String?;
}
