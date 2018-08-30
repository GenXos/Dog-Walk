

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  lazy var coreDataStack = CoreDataStack(modelName: "Dog Walk")
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    guard let navController = window?.rootViewController as? UINavigationController, let viewController = navController.topViewController as? ViewController else {
      return true
    }
    
    viewController.managedContext = coreDataStack.managedContext
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    coreDataStack.saveContext()
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    coreDataStack.saveContext()
  }
}
