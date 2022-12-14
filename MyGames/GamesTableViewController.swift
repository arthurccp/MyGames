//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Arthur Silva on 13/12/22.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<Game>!
    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "você não tem jogos cadastrados"
        label.textAlignment = .center
        loadGames() 
    }
    
    
    func loadGames(){
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self

        do{
            try fetchedResultController.performFetch()

        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        tableView.backgroundView = count == 0 ? label : nil

        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        
         guard let game = fetchedResultController.fetchedObjects?[indexPath.row]else{
            return cell
            
        }

        cell.prepare(with: game)
        return cell
    }
    
}

extension GamesTableViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?,  for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch type {
        case .delete:
            break
        default:
            tableView.reloadData()
        }
    }
}
