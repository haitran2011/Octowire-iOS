//
//  AppReducer.swift
//  Octowire
//
//  Created by Mart Roosmaa on 24/02/2017.
//  Copyright © 2017 Mart Roosmaa. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: Reducer {
    let toastReducer = ToastReducer()
    let navigationReducer = NavigationReducer()
    let eventsBrowserReducer = EventsBrowserReducer()
    let userProfileReducer = UserProfileReducer()
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        return AppState(
            toastState: toastReducer.handleAction(action: action, state: state?.toastState),
            navigationState: navigationReducer.handleAction(action: action, state: state?.navigationState),
            eventsBrowserState: eventsBrowserReducer.handleAction(action: action, state: state?.eventsBrowserState),
            userProfileState: userProfileReducer.handleAction(action: action, state: state?.userProfileState))
    }
}
