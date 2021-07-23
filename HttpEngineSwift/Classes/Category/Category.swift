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

public extension Dictionary{
    func MTdictionaryByRemovingNull() -> Dictionary {
        let tmp : NSDictionary = self as NSDictionary;
        return tmp.dictionaryByRemovingNull() as! Dictionary<Key, Value>;
    }
    
    func descriptionWithLocale() -> String {
        var strM : String = "{\n";
        for (key , value) in self.enumerated() {
            strM.append("\t\(key) = \(value);\n");
        }
        strM.append("}\n")
        return strM;
    }
    
    func jsonString() -> String {
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return jsonStr! as String
    }
}

