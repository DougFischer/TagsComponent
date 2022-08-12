//
//  KeywordsCache.swift
//  TagsComponent
//
//  Created by Carlos Cabral on 29/07/22.
//

protocol KeywordsSource {

    func loadKeywords() -> [String]
}

/// The `KeywordsCache` object manages the list of keywords names loaded from an external source.
actor KeywordsCache {

    /// Source to load keyword names.
    let source: KeywordsSource

    init(source: KeywordsSource) {
        self.source = source
    }

    /// The list of keywords.
    var keywords: [String] {
        if let keywords = cachedKeywords {
            return keywords
        }

        let keywords = source.loadKeywords()
        cachedKeywords = keywords

        return keywords
    }

    private var cachedKeywords: [String]?
}

extension KeywordsCache {

    /// Returns a list of keywords filtered using given prefix.
    
    func lookup(prefix: String) -> [String] {
        keywords.filter { $0.hasCaseAndDiacriticInsensitivePrefix(prefix) }
    }
}
