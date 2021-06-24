//
//  Log.swift
//  CoinCapDemo
//
//  Created by Amir on 6/23/21.
//

import Foundation

class Log {

    private var minLogLevelToPrint: Level

    init(logLevel: Level) {
        minLogLevelToPrint = logLevel
    }

    func debug(_ str: String) {
        if minLogLevelToPrint <= Level.debug {
            print(str)
        }
    }

    func info(_ str: String) {
        if minLogLevelToPrint <= Level.info {
            print(str)
        }
    }

    func warning(_ str: String) {
        if minLogLevelToPrint <= Level.warning {
            print(str)
        }
    }

    func error(_ str: String) {
        if minLogLevelToPrint <= Level.error {
            print(str)
        }
    }

    func debugNetwork(request: URLRequest) {

        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody {
            let bodyString = String(data: body, encoding: .utf8)
                ?? "Can't render body; not utf8 encoded"
            requestLog += "\n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n"
        self.debug(requestLog)
    }

    func debugNetwork(data: Data?, response: URLResponse?, error: Error?) {
        guard let response = response as? HTTPURLResponse else { return }

        let urlString = response.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        responseLog += "HTTP \(response.statusCode) \(path)?\(query)\n"

        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }

        for (key, value) in response.allHeaderFields {
            responseLog += "\(key): \(value)\n"
        }

        if let body = data {
            let bodyString = String(data: body, encoding: .utf8)
                ?? "Can't render body; not utf8 encoded"
            responseLog += "\n\(bodyString)\n"
        }

        if let error = error {
            responseLog += "\nError: \(error.localizedDescription)\n"
        }

        responseLog += "<------------------------\n"
        self.debug(responseLog)
    }
}

extension Log {

    enum Level: Int, Comparable {
        case debug
        case info
        case warning
        case error

        static func < (lhs: Log.Level, rhs: Log.Level) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}
