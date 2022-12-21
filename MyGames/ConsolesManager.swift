//
//  ConslesManager.swift
//  MyGames
//
//  Created by Arthur Silva on 14/12/22.
//

import Foundation
import CoreData
class ConsolesManager {
    static let shared = ConsolesManager()
    var consoles: [Console] = []
    
    func loadConsoles(wth context: NSManagedObjectContext){
        let fetchrequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchrequest.sortDescriptors = [sortDescriptor]
        
        do{
            consoles = try context.fetch(fetchrequest)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext){
        let console = consoles[index]
        context.delete(console)
        do {
            try context.save()
            consoles.remove(at: index)
    
        } catch{
            print(error.localizedDescription)
        }
    }
    
    private init(){
        
    }
}
