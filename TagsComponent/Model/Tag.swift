//
//  Tag.swift
//  TagsComponent
//
//  Created by Carlos Cabral on 27/07/22.
//

import SwiftUI

struct Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}
