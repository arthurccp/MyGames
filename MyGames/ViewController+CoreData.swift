//
//  ViewCOntroller+CoreData.swift
//  MyGames
//
//  Created by Arthur Silva on 13/12/22.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
  }
