//
//  SplitViewControllerProtocol.swift
//  RunningOrder
//
//  Created by Lucas Barbero on 05/08/2020.
//  Copyright © 2020 Worldline. All rights reserved.
//

import Cocoa

protocol SplitViewControllerOwner {
    var splitViewController: NSSplitViewController? { get }
}
