//
//  MockSession.swift
//  StartIt
//
//  Created by Булат Мусин on 11.01.2024.
//

import Foundation
import Alamofire
import Mocker

final class MockSession {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        return Session(configuration: configuration)
    }()
}
