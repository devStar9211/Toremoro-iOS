//
//  BenchmarkPlugin.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/16.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya
import Result

final class BenchmarkPlugin: PluginType {

    // MARK: - Property

    private var start: Date?

    // MARK: - Public

    func willSend(_ request: RequestType, target: TargetType) {
        start = Date()
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let start = start else { return }
        let elapsed = Date().timeIntervalSince(start)
        let text = String(format: "%.3f", elapsed)
        let path = target.path
        Logger.info("⏱ Networking Benchmark: \(path), Elasped time: \(text)(s)")
    }
}
