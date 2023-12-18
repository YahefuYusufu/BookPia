//
//  BookPiaApp.swift
//  BookPia
//
//  Created by yusufyakuf on 2023-12-15.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
   func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
      return true
   }
}

@main
struct BookPiaApp: App {
   // register app delegate for Firebase setup
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
    var body: some Scene {
        WindowGroup {
           NavigationView {
              ContentView()
              Text("Would you dare share your fav book here ?")
                 .fontWeight(.heavy)
                 .foregroundStyle(Color.green)
           }
        }
    }
}
