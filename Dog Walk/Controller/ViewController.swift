//
// ViewController.swift
//

import UIKit
import CoreData

class ViewController: UIViewController {

  // MARK: - Variables
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
  }()
  var managedContext: NSManagedObjectContext!
  var currentDog: Dog?

  // MARK: - IBOutlets
  @IBOutlet var tableView: UITableView!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    let dogName = "Fido"
    let dogFetch: NSFetchRequest<Dog> = Dog.fetchRequest()
    dogFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Dog.name), dogName)

    do {
      let results = try managedContext.fetch(dogFetch)
      if results.count > 0 {
        // Fido found, use Fido
        currentDog = results.first
      } else {
        // Fido not found, create Fido
        currentDog = Dog(context: managedContext)
        currentDog?.name = dogName
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
  }
}

// MARK: - IBActions
extension ViewController {

  @IBAction func add(_ sender: UIBarButtonItem) {
    
    // Insert a new Walk entity into Core Data
    let walk = Walk(context: managedContext)
    walk.date = NSDate()
    
    // Insert the new Walk into the Dog's walk's set
    currentDog?.addToWalks(walk)
    
    // Save the managed object context
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Save error: \(error), description: \(error.userInfo)")
    }
    
    // Reload table view
    tableView.reloadData()
  }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let walks = currentDog?.walks else {
      return 1
    }
    
    return walks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    guard let walk = currentDog?.walks?[indexPath.row] as? Walk,
      let walkDate = walk.date as Date? else {
      return cell
    }
    
    cell.textLabel?.text = dateFormatter.string(from: walkDate)
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "List of Walks"
  }
}


















