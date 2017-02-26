//
//  NavigationState.swift
//  Octowire
//
//  Created by Mart Roosmaa on 24/02/2017.
//  Copyright © 2017 Mart Roosmaa. All rights reserved.
//

import Foundation
import ReSwift

struct NavigationState: StateType {
    var animationCounter: UInt64 = 0
    var stack: [Route] = []
}
