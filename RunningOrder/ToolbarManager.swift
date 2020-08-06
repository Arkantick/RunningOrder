//
//  ToolbarManager.swift
//  RunningOrder
//
//  Created by Lucas Barbero on 27/07/2020.
//  Copyright © 2020 Worldline. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI

class ToolbarManager: NSObject, ObservableObject {

    var isASprintSelected = false
    @Published var showStoryModal = false

    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        switch item.itemIdentifier {
        case .addStory:
            return isASprintSelected // Implement addStory button validation
        default:
            return true
        }
    }

    func addStory() {
        self.showStoryModal = true
    }
}
