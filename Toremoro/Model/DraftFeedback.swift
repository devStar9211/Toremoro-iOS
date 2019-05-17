//
//  DraftFeedback.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/11/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import Foundation
import Validator

struct DraftFeedback {

    enum ValidationError: ValidationErrorType {
        case invalidLength
        case invalidEmail

        var message: String {
            switch self {
            case .invalidLength:
                return "本文は1文字以上入力してください"
            case .invalidEmail:
                return "正しいメールアドレスを入力してください"
            }
        }
    }

    // MARK: - Propety

    let body: String
    let email: String?
}

// MARK: - MultipleValidatable

extension DraftFeedback: MultipleValidatable {
    func validate() -> ValidationResult {
        let minLengthRule = ValidationRuleLength(min: 1, error: ValidationError.invalidLength)
        let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError.invalidEmail)
        if let email = email, !email.isEmpty {
            return body.validate(rule: minLengthRule).merge(with: email.validate(rule: emailRule))
        } else {
            return body.validate(rule: minLengthRule)
        }
    }
}
