//
//  CheckVersionHttpItem.swift
//  HttpEngineSwift_Example
//
//  Created by Sumansoul on 2021/7/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import HttpEngineSwift

open class CheckVersionHttpItem: BaseHttpItem {
    
    override init() {
    
    }
    
    var _completedBlock : httpSuccessfulBlock<CheckVersionEntity>?;
    var _faliedBlock : httpFailedBlock?;
     
    func initWith(completedBlock : httpSuccessfulBlock<CheckVersionEntity> , faliedBlock: httpFailedBlock) -> CheckVersionHttpItem {
        _completedBlock = completedBlock;
        _faliedBlock = faliedBlock;
        self.httpRequestMethod = HTTPMethod.GET;
        self.httpRequestUrl = "service/public/upgrade";
        return self;
    }
    
    public override func httpRequestCompletedWithItem(item : BaseHttpItem) -> Void {
        let dataModel : CheckVersionEntity = CheckVersionEntity.model(withJSON: item.httpRequestResponseData!) ?? CheckVersionEntity.init();
        if ((_completedBlock) != nil)
        {
            _completedBlock!!(dataModel);
        }
    }
    
    public override func httpRequestCompletedExceptionWithItem(item: BaseHttpItem) -> Void {
        let dataModel : CommonLogicDataModel = CommonLogicDataModel.model(withJSON: item.httpRequestResponseData!)!;
        if ((_faliedBlock) != nil)
        {
            _faliedBlock!!(dataModel);
        }
    }
    
    public override func httpRequestFailedWitItem(item : BaseHttpItem) -> Void {
        let dataModel : CommonLogicDataModel = CommonLogicDataModel.init();
        dataModel.state = "\(item.httpRequestStatusCode)";
        dataModel.msg = item.httpRequestErrorMessage;
        if (_faliedBlock != nil)
        {
            _faliedBlock!!(dataModel);
        }
    }
    
    public override func descriptionItem() -> String {
        return "版本检测";
    }
     
}
