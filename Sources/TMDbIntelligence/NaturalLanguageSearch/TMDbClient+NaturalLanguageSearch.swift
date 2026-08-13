//
//  TMDbClient+NaturalLanguageSearch.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

#if canImport(NaturalLanguage)
    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
    public extension TMDbClient {

        ///
        /// Provides on-device, natural-language search across movies, TV series, and
        /// people.
        ///
        /// A prompt such as `"movies with Tom Hanks"` or `"cast of The Matrix"` is
        /// interpreted on device and executed against TMDb. Interpretation is
        /// deterministic (Apple's Natural Language framework); on supported devices
        /// with Apple Intelligence, Foundation Models additionally handles fuzzier,
        /// compositional prompts. On platforms without either, the prompt runs as a
        /// plain multi-search.
        ///
        /// - Note: Each access constructs a new service instance. When checking
        ///   ``NaturalLanguageSearchService/availability`` and then searching, store
        ///   it in a local first — `let search = client.naturalLanguageSearch` — rather
        ///   than accessing the property twice.
        ///
        var naturalLanguageSearch: any NaturalLanguageSearchService {
            let dataSource = LiveNaturalLanguageSearchDataSource(
                discover: discover,
                search: search,
                genres: genres,
                movies: movies,
                tvSeries: tvSeries,
                people: people,
                trending: trending
            )

            let deterministic = NaturalLanguageSearchPlanGenerator(
                classifier: RuleBasedIntentClassifier(),
                personExtractor: NLTaggerPersonNameExtractor(),
                languageDetector: NLLanguageRecognizerPromptDetector()
            )

            // Foundation Models is an optional fallback for the fuzzy tail, only on
            // capable OS versions. The NaturalLanguage planner is always the default.
            var fallback: (any SearchPlanGenerating)?
            #if canImport(FoundationModels) && !os(tvOS) && !os(watchOS)
                if #available(iOS 26, macOS 26, visionOS 26, watchOS 27, *) {
                    fallback = FoundationModelsSearchPlanGenerator()
                }
            #endif

            let planner = GatedSearchPlanGenerator(deterministic: deterministic, fallback: fallback)

            return TMDbNaturalLanguageSearchService(
                planner: planner,
                executor: SearchPlanExecutor(dataSource: dataSource),
                dataSource: dataSource
            )
        }

    }
#endif
