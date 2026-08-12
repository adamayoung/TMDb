//
//  ResumeOnceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Pins ``ResumeOnce``'s state machine directly.
///
/// It is a hand-rolled one-shot continuation box, and its failure mode on a
/// future edit is a `SWIFT TASK CONTINUATION MISUSE` crash — or a silent hang —
/// rather than a red assertion. Driving it through `APIConfigurationStore`
/// cannot distinguish first-wins from last-wins, so the machine is exercised
/// here instead.
///
@Suite(.tags(.services, .images), .timeLimit(.minutes(1)))
struct ResumeOnceTests {

    @Test("resume before attach delivers the value once the continuation arrives")
    func resumeBeforeAttachDeliversValue() async {
        let box = ResumeOnce<Int>()
        box.resume(1)

        let value = await withCheckedContinuation { continuation in
            box.attach(continuation)
        }

        #expect(value == 1)
    }

    @Test("the FIRST pre-attach value wins, not the last")
    func firstPreAttachValueWins() async {
        // Guards the latch. Without it a second producer overwrites the first,
        // turning the documented "every call after the first is a no-op" into
        // "last call wins" — in exactly the window that is hardest to observe.
        let box = ResumeOnce<Int>()
        box.resume(1)
        box.resume(2)

        let value = await withCheckedContinuation { continuation in
            box.attach(continuation)
        }

        #expect(value == 1)
    }

    @Test("resume after attach delivers, and later resumes are ignored")
    func resumeAfterAttachDeliversOnce() async {
        let box = ResumeOnce<Int>()

        let value = await withCheckedContinuation { continuation in
            box.attach(continuation)
            box.resume(1)
            // A second resume must not touch the already-consumed continuation.
            // Resuming twice is undefined behaviour, so this test failing to
            // crash is itself the assertion.
            box.resume(2)
        }

        #expect(value == 1)
    }

    @Test("a pre-attach resume is not re-delivered to a later attach")
    func valueIsDeliveredExactlyOnce() async {
        let box = ResumeOnce<Int>()
        box.resume(1)

        let value = await withCheckedContinuation { continuation in
            box.attach(continuation)
        }

        #expect(value == 1)

        // The box is spent: a further resume must be inert rather than trapping.
        box.resume(3)
    }

}
