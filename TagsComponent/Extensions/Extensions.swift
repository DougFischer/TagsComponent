//
//  Extensions.swift
//  TagsComponent
//
//  Created by Carlos Cabral on 29/07/22.
//

import SwiftUI

extension View {
    
    func addPrimaryButtonStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .tint(.white)
            .background(Color("MainColor"), in: RoundedRectangle(cornerRadius: 6))
    }
}

extension String {

    func hasCaseAndDiacriticInsensitivePrefix(_ prefix: String) -> Bool {
        guard let range = self.range(of: prefix, options: [.caseInsensitive, .diacriticInsensitive]) else {
            return false
        }

        return range.lowerBound == startIndex
    }
}
