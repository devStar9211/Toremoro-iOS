//
//  RequestInterceptor.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/10.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Moya

protocol RequestInterceptor {
    func intercept<T: TargetType>(_ target: T.Type, endpoint: Endpoint, done: @escaping MoyaProvider<T>.RequestResultClosure)
}
