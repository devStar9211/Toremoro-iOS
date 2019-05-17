//
//  LoggerPlugin.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/08.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya
import Result

struct LoggerPlugin: PluginType {

    // MARK: - Public

    func willSend(_ request: RequestType, target: TargetType) {
        request.request.map { curlCommand(from: $0) }.map { Logger.debug($0) }
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        Logger.debug(result.description)
    }

    // MARK: - Private

    private func curlCommand(from request: URLRequest) -> String {
        guard let url = request.url else { return "" }
        var baseCommand = "curl \"\(url.absoluteString)\""

        if request.httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = request.httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = request.httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}
