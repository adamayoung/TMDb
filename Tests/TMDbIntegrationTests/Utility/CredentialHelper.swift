//
//  CredentialHelper.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import TMDb

final class CredentialHelper {

    static let shared = CredentialHelper()

    private let processInfo: ProcessInfo

    private init(processInto: ProcessInfo = ProcessInfo.processInfo) {
        self.processInfo = processInto
    }

    var hasCredential: Bool {
        let credential = self.tmdbCredential

        return !credential.username.isEmpty && !credential.password.isEmpty
    }

    lazy var tmdbCredential: Credential = {
        let username = processInfo.environment["TMDB_USERNAME"] ?? ""
        let password = processInfo.environment["TMDB_PASSWORD"] ?? ""
        let credential = Credential(username: username, password: password)

        return credential
    }()

    var hasAPIKey: Bool {
        !self.tmdbAPIKey.isEmpty
    }

    lazy var tmdbAPIKey: String = {
        processInfo.environment["TMDB_API_KEY"] ?? ""
    }()

}
