//
//  SwiftUIView.swift
//  RunningOrder
//
//  Created by Lucas Barbero on 20/07/2020.
//  Copyright © 2020 Worldline. All rights reserved.
//

import SwiftUI

struct SprintNumber: View {
    let number: Int
    let color: Color
    var body: some View {
            Text("\(number)")
                .foregroundColor(Color.white)
                .frame(width: 25, height: 12)
                .background(color)
                .clipShape(Rectangle())
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SprintNumber(number: 454, color: Color.yellow)
    }
}
