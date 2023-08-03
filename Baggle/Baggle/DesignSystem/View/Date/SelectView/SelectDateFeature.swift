//
//  YearMonthDateFeature.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import ComposableArchitecture

import SwiftUI

struct SelectDateFeature: ReducerProtocol {

    struct State: Equatable {
        // Scope State
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

                //State
            case let .dateChanged(newDate):
                state.date = newDate
                return .none

                // Tap
            case .completeButtonTapped:
                return .run { _ in await self.dismiss() }

            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}
