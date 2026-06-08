//
//  ImageProviding+Conformances.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

// MARK: - PosterImageProviding & BackdropImageProviding

extension Movie: PosterImageProviding, BackdropImageProviding {}
extension MovieListItem: PosterImageProviding, BackdropImageProviding {}
extension TVSeries: PosterImageProviding, BackdropImageProviding {}
extension TVSeriesListItem: PosterImageProviding, BackdropImageProviding {}
extension Collection: PosterImageProviding, BackdropImageProviding {}
extension CollectionListItem: PosterImageProviding, BackdropImageProviding {}
extension BelongsToCollection: PosterImageProviding, BackdropImageProviding {}
extension MediaListItem: PosterImageProviding, BackdropImageProviding {}
extension CreditMovie: PosterImageProviding, BackdropImageProviding {}
extension CreditTVSeries: PosterImageProviding, BackdropImageProviding {}
extension MovieCastCredit: PosterImageProviding, BackdropImageProviding {}
extension MovieCrewCredit: PosterImageProviding, BackdropImageProviding {}
extension TVSeriesCastCredit: PosterImageProviding, BackdropImageProviding {}
extension TVSeriesCrewCredit: PosterImageProviding, BackdropImageProviding {}

// MARK: - PosterImageProviding only

extension TVSeason: PosterImageProviding {}
extension MediaListSummary: PosterImageProviding {}
extension MediaList: PosterImageProviding {}

// MARK: - ProfileImageProviding

extension Person: ProfileImageProviding {}
extension PersonListItem: ProfileImageProviding {}
extension CastMember: ProfileImageProviding {}
extension CrewMember: ProfileImageProviding {}
extension AggregateCastMember: ProfileImageProviding {}
extension AggregateCrewMember: ProfileImageProviding {}
extension Creator: ProfileImageProviding {}
extension CreditPerson: ProfileImageProviding {}

// MARK: - LogoImageProviding

extension ProductionCompany: LogoImageProviding {}
extension Network: LogoImageProviding {}
extension WatchProvider: LogoImageProviding {}

// MARK: - StillImageProviding

extension TVEpisode: StillImageProviding {}
extension TVEpisodeAirDate: StillImageProviding {}
