//
//  VideoBackgroundDurationTracker.swift
//  Toremoro
//
//  Created by Yasuaki Goto on 2018/12/09.
//  Copyright © 2018 toremoro, inc. All rights reserved.
//

import UIKit

final class VideoBackgroundDurationTracker {

    typealias Chunk = (start: CGFloat, end: CGFloat?)

    // MARK: - Property

    private var chunks: [Chunk] = []

    var duration: CGFloat {
        return chunks.filter { $0.end != nil }.map { $0.end! - $0.start }.reduce(0) { $0 + $1 }
    }

    // MARK: - Public

    func enterBackground(at progress: CGFloat) {
        chunks.append(Chunk(start: progress, end: nil))
    }

    func enterForeground(at progress: CGFloat) {
        if let chunk = chunks.last, chunk.end == nil {
            chunks[chunks.count - 1] = Chunk(start: chunk.start, end: progress)
        }
    }
}
