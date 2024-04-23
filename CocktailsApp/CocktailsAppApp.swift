//
//  CocktailsAppApp.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 30/1/24.
//

import SwiftUI
import Firebase

@main
struct CocktailsAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var goToAnotherView: Bool = false
    @State private var allStepsCompleted: Bool = false
    
    var body: some Scene {
        
        WindowGroup {
            RootView(firestoreManager: FirestoreManager(),
                     coreDataManager: CoreDataManager(),
                     combineManager: CombineManager())
//            TestView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()

    return true
  }
}
