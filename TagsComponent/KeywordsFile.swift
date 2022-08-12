//
//  KeywordsFile.swift
//  TagsComponent
//
//  Created by Carlos Cabral on 29/07/22.
//

import Foundation

struct KeywordsFile: KeywordsSource {

    let location: URL

    init(location: URL) {
        self.location = location
    }

    /// Looks up for `keywords` file in the main bundle
    init?() {
        guard let location = Bundle.main.url(forResource: "keywords", withExtension: nil) else {
            assertionFailure("keywords file is not in the main bundle")
            return nil
        }

        self.init(location: location)
    }

    func loadKeywords() -> [String] {
        do {
            let data = try Data(contentsOf: location)
            let string = String(data: data, encoding: .utf8)
            return string?.components(separatedBy: .newlines) ?? []
        }
        catch {
            return []
        }
    }
}
