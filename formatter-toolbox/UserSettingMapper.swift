//
//  UserSetting.swift
//  formatter-toolbox
//
//  Created by wzh on 2024/8/30.
//

import CoreData

class UserSettingMapper {
    
    var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func getUserSettingIndent() -> Int16{
        let fetchRequest: NSFetchRequest<UserSetting> = UserSetting.fetchRequest()
        do {
            let userSettings = try viewContext.fetch(fetchRequest)
            if let userSetting = userSettings.first {
                print("Get user setting indent: \(userSetting.indent)")
                return userSetting.indent
            } else {
                return initUserSettingIndent()
            }
        } catch {
            print("Failed to get user setting: \(error)")
            return 4
        }
    }
    
    func initUserSettingIndent() -> Int16{
        do {
            let userSetting = UserSetting(context: self.viewContext)
            userSetting.indent = 4
            print("Init user setting indent: \(userSetting.indent)")
            try self.viewContext.save()
            return 4
        } catch {
            print("Failed to init user settings: \(error)")
            return 4
        }
    }
    
    func saveUserSetting(data: String) -> Bool{
        print("Save original data: \(data)")
        var indent:Int16 = 4
        let tmp = verifyIndent(dic: stringToDic(data))
        if tmp != -1 { indent = tmp }
        let fetchRequest: NSFetchRequest<UserSetting> = UserSetting.fetchRequest()
        do {
            let results = try self.viewContext.fetch(fetchRequest)
            if let userSetting = results.first {
                userSetting.indent = indent
                print("Save user setting indent: \(userSetting.indent)")
            } else {
                let userSetting = UserSetting(context: self.viewContext)
                userSetting.indent = indent
                print("Save user setting indent: \(userSetting.indent)")
            }
            try self.viewContext.save()
            return true
        } catch {
            print("Failed to save user settings: \(error)")
            return false
        }
    }
    
    func verifyIndent(dic: [String : Any]?) -> Int16{
        if let dic = dic {
            if let value = dic["indent"] as? Int16 { return value }
            else { return -1 }
        } else {  return -1 }
    }
    
    func dicToString(_ dic:[String : Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
    func stringToDic(_ str: String) -> [String : Any]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any] { return dict }
        return nil
    }
}
