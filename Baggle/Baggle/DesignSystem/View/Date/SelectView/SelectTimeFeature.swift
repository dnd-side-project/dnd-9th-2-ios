//
//  HourMinuteFeature.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import ComposableArchitecture

import SwiftUI

struct SelectTimeFeature: ReducerProtocol {

    struct State: Equatable {
        var date: Date
    }

    enum Action: Equatable {

        // State
        case dateChanged(Date)

        // Tap
        case completeButtonTapped
        case cancelButtonTapped
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

            case let .dateChanged(newDate):
                state.date = newDate
                return .none

            case .completeButtonTapped:
                return .run { _ in await self.dismiss() }

            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
