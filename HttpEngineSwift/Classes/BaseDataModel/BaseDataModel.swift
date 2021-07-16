//
//  BaseDataModel.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation
import YYKit

open class BaseDataModel : NSObject, YYModel , NSCoding{
    public func encode(with coder: NSCoder) {
        self.modelEncode(with: coder);
    }
    
    public required convenience init?(coder: NSCoder) {
        self.init();
        self.modelInit(with: coder);
    }

    public override var description: String{
        return modelDescription();
    }
    
    func displayAllAttributed() -> Void {
        print("displayAllAttributed called");
    }
}
