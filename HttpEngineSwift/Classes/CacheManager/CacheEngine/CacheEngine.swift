//
//  CacheEngine.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/12.
//

import Foundation

class CacheEngine {
    
    static let kKey = Bundle.main.object(forInfoDictionaryKey: String(kCFBundleIdentifierKey));
    static let kCacheManagerMacro = "FileName_\(kKey!)";
    
    //check wether your data is exist in your sandbox.
    static func localCacheIsExistsWithMarkKeyFileName(fileName : String) -> Bool{
        if (fileName.count == 0)
        {
            return false;
        }
        
        var result = true;
        if ((CacheEngine.loadDataWithMarkKeyFileName(fileName: fileName) == nil))
        {
            result = false;
        }
        return result;
    }
    
    static func applicationDocumentsDirectory(fileName : String) -> String{
        if (fileName.count == 0)
        {
            return "";
        }
        
        let paths : Array<String> = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
        let basePath : String? = paths.count > 0 ? paths[0]: "";
        return basePath!.appending(fileName);
    }
    
    //read data from local sandbox ,filename means your document name;
    static func loadDataWithMarkKeyFileName(fileName : String) -> Any?{
        if (fileName.count == 0)
        {
            return nil;
        }
        
        let filePath : String = CacheEngine.applicationDocumentsDirectory(fileName: fileName);
        if (FileManager.default.fileExists(atPath: filePath))
        {
            let data : Data = try! Data.init(contentsOf: URL.init(fileURLWithPath: filePath));
            let unarchiver : NSKeyedUnarchiver = NSKeyedUnarchiver.init(forReadingWith: data);
            let result : Any = unarchiver.decodeObject(forKey: kCacheManagerMacro)!;
            unarchiver.finishDecoding();
            return result;
        }
        return nil;
    }
    
    //save data to local sandbox,filename means your document name;
    static func saveData(data : Any , fileName: String) -> Void{
        if (fileName.count == 0)
        {
            return;
        }
        
        let data : Data = Data.init();
        let unarchiver : NSKeyedUnarchiver = NSKeyedUnarchiver.init(forReadingWith: data);
        unarchiver.encode(data, forKey: kCacheManagerMacro);
        unarchiver.finishDecoding();
        let filePath : String = CacheEngine.applicationDocumentsDirectory(fileName: fileName);
        try! data.write(to: URL.init(fileURLWithPath: filePath));
    }
    
    //delete data from your sandbox depends on what's your filename is.
    static func deleteDataWithMarkKeyFileName(fileName: String) -> Void{
        if (fileName.count == 0)
        {
            return;
        }
        
        let data : Data = Data.init();
        let unarchiver : NSKeyedUnarchiver = NSKeyedUnarchiver.init(forReadingWith: data);
        unarchiver.encode(nil, forKey: kCacheManagerMacro);
        unarchiver.finishDecoding();
        let filePath : String = CacheEngine.applicationDocumentsDirectory(fileName: fileName);
        try! data.write(to: URL.init(fileURLWithPath: filePath));
    }
    
    //remove data to sandbox;
    static func removeAllLocalCache() -> Void{
        let systemFileName : Array = ["cfg","LeanCloud","baiduplist"];
        let paths : Array<String> = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
        let basePath : String? = paths.count > 0 ? paths[0]: "";
        let contentOfFolder : Array<String> = try! FileManager.default.contentsOfDirectory(atPath: basePath!);
        for aPath in contentOfFolder
        {
            if systemFileName.contains(aPath)
            {
                let path : String = basePath!.stringByAppendingPathComponent(path: aPath);
                try! FileManager.default.removeItem(atPath: path);
            }
        }
        
    }
}
