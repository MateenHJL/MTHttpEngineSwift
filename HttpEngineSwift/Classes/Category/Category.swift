//
//  Category.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation
import ISRemoveNull

extension String
{
    func MTRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
        let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
        let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
        let from = String.Index(from16, within: self),
        let to = String.Index(to16, within: self)
        else
        {
            return nil
        }
        return from ..< to
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.strings(byAppendingPaths: [path]).first!;
    }
}
 
extension NSObject
{
    func classFromString(className : String) -> AnyClass {
        let appName : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String;
             // YourProject.className
        let classStringName = appName + "." + className
        return NSClassFromString(classStringName)!
    }
}

extension Optional {
    func isNil(_ object: Wrapped) -> Bool {
        switch object as Any {
        case Optional<Any>.none:
            return true
        default:
            return false
        }
    }
}

extension Dictionary{
    func MTdictionaryByRemovingNull() -> Dictionary {
        let tmp : NSDictionary = self as NSDictionary;
        return tmp.dictionaryByRemovingNull() as! Dictionary<Key, Value>;
    }
}

