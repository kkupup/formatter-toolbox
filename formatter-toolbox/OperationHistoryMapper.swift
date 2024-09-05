//
//  OperationHistory.swift
//  formatter-toolbox
//
//  Created by wzh on 2024/9/2.
//

import CoreData

class OperationHistoryMapper{
    
    var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func getOperationHistory() -> String{
        let fetchRequest: NSFetchRequest<OperationHistory> = OperationHistory.fetchRequest()
        do {
            fetchRequest.propertiesToFetch = ["date", "id"]
            let operationHistories = try self.viewContext.fetch(fetchRequest)
            return operationHistoriesToString(data: operationHistories)
        } catch {
            print("Failed to get Operation History: \(error)")
            return "[]"
        }
    }
    
    func deleteAllOperationHistories() -> Bool{
        let fetchRequest: NSFetchRequest<OperationHistory> = OperationHistory.fetchRequest()
        do {
            let results = try viewContext.fetch(fetchRequest)
            for record in results {
                viewContext.delete(record)
            }
            try viewContext.save()
            print("Successfully deleted all OperationHistory records.")
            return true
        } catch {
            print("Failed to delete all OperationHistory records: \(error)")
            return false
        }
    }
    
    func saveOperationHistory(data: String){
        let dict = stringToDic(data)
        do {
            let operationHistory = OperationHistory(context: self.viewContext)
            operationHistory.type = dict!["type"]
            operationHistory.operate = dict!["operate"]
            operationHistory.before = dict!["before"]
            operationHistory.after = dict!["after"]
            operationHistory.date = Date()
            operationHistory.id = UUID()
            print("Save user setting indent: \(operationHistory)")
            try self.viewContext.save()
        } catch {
            print("Failed to save Operation History: \(error)")
        }
    }
    
    func stringToDic(_ str: String) -> [String : String]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : String] { return dict }
        return nil
    }
    
    func operationHistoryToString(data: OperationHistory) -> String {
        let id = data.id != nil ? "\"id\":\"\(data.id!.uuidString)\"," : ""
        let type = data.type != nil ? "\"type\":\"\(data.type!)\"," : ""
        let operate = data.operate != nil ? "\"operate\":\"\(data.operate!)\"" : ""
        let date: String
        if let operationDate = data.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = "\"date\":\"\(dateFormatter.string(from: operationDate))\","
        } else {
            date = ""
        }
        let before = data.before != nil ? "\"before\":\"\(data.before!)\"," : ""
        let after = data.after != nil ? "\"after\":\"\(data.after!)\"," : ""
        let operationString = "{" + id + type  + date + before + after + operate + "}"
        return operationString
    }
    
    func operationHistoriesToString(data: [OperationHistory]) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        var result = "[ "
        for history in data {
            result = result + operationHistoryToString(data: history) + ","
        }
        return result.dropLast() + "]"
    }
}
