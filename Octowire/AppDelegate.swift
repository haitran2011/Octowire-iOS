//
//  AppDelegate.swift
//  Octowire
//
//  Created by Mart Roosmaa on 24/02/2017.
//  Copyright © 2017 Mart Roosmaa. All rights reserved.
//

import UIKit
import ReSwift
import ReSwiftRecorder

var mainStore = RecordingMainStore<AppState>(
    reducer: AppReducer(),
    state: nil,
    typeMaps: [toastActionTypeMap, navigationActionTypeMap],
    recording: "recording.json",
    middleware: [])

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let vc = NavigationController()

        mainStore.dispatch { state, store in
            if state.navigationState.stack.isEmpty {
                return NavigationActionStackReplace(
                    routes: [.events],
                    animated: false)
            } else {
                return nil
            }
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        mainStore.rewindControlYOffset = 150
        mainStore.window = window
        
        return true
    }
}

