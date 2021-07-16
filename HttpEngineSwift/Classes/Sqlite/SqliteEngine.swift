//
//  SqliteEngine.swift
//  HttpEngineSwift
//
//  Created by Sumansoul on 2021/7/15.
//

import Foundation
import FMDB

public typealias sqliteEngineExecuteCompletedBlock = ((Bool, String) -> Void)?;
public typealias sqliteEngineSelectedCompletedBlock<T> = ((Bool, Array<T>) -> Void)?;

class SqliteEngine{
    
    var database : FMDatabase? = nil;
    var sqliteQueue : FMDatabaseQueue? = nil;
    
    let kSqlietePathName : String = "httpCollectionSqlite.sqlite";
    
    static let engine : SqliteEngine = SqliteEngine.init();
    
    //init SqliteEngine;
    static func shareEngine () -> SqliteEngine{
        return engine;
    }
    
    private init(){
        createDataBase();
        print("SqliteEngine init");
    }
    
    //create DB
    func createDataBase() -> Void {
        let paths : Array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
        let path : String = paths[0];
        let databasePath = path.stringByAppendingPathComponent(path: kSqlietePathName);
        let manager = FileManager.default;
        let isExist : Bool = manager.fileExists(atPath: databasePath);
        self.database = FMDatabase.init(path: databasePath);
        self.sqliteQueue = FMDatabaseQueue.init(path: databasePath);
        if (!isExist)
        {
            try! manager.createDirectory(atPath: databasePath, withIntermediateDirectories: true, attributes: nil);
        }
    }
    
    //open collectied log Info
    func configTableInformationWithSqliteItem(item : BaseSqliteItem<AnyClass>, block : sqliteEngineExecuteCompletedBlock) -> Void {
        if (self.database!.open())
        {
            self.sqliteQueue?.inDatabase({ (db : FMDatabase) in
                let flag = db.executeUpdate(item.configTableStatement!, withParameterDictionary: [:]);
                var sqliteError = "";
                if (!flag)
                {
                    sqliteError = "创建表失败";
                }
                
                if (block != nil)
                {
                    block! (flag, sqliteError);
                }
            })
        }
    }
    
    //excuted Statement from item <for sqliteItem>
    func excutedWithSqiteItem(item : BaseSqliteItem<BaseDataModel.Type> , block : sqliteEngineExecuteCompletedBlock) -> Void {
        if (!self.database!.open())
        {
            if (block != nil)
            {
                block! (false, "数据库打开失败");
            }
            return;
        }
        
        self.database!.open();
        self.sqliteQueue!.inDatabase({ (db : FMDatabase) in
            let flag = db.executeUpdate(item.operateStatement!, withParameterDictionary: [:]);
            var sqliteError = "";
            if (!flag)
            {
                sqliteError = "数据库操作失败";
            }
            if (block != nil)
            {
                block! (flag, sqliteError);
            }
        });
    }
    
    //select data from Sqlite <for Controller>
    func selectDataWithStatement(item : BaseSqliteItem<BaseDataModel.Type>, block : sqliteEngineSelectedCompletedBlock<Any>) -> Void {
        if (!self.database!.open())
        {
            if (block != nil)
            {
                block! (false, []);
            }
            return;
        }
        
        self.database?.open();
        self.sqliteQueue?.inDatabase({ (db : FMDatabase) in
            var resultArray : Array<Any> = [];
            let result : FMResultSet = db.executeQuery(item.operateStatement!, withParameterDictionary: [:])!;
            while(result.next())
            {
                let resultDic : Dictionary = result.resultDictionary!;
                let model = item.selectedDataModelClass?.model(with: resultDic);
                resultArray.append(model!);
            }
            if (block != nil)
            {
                block! (true, resultArray);
            }
        });
    }
    
    func closeSqliteEngine() -> Void {
        self.database!.close();
    }
}
