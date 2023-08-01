//
//  YearMonthDateFeature.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import ComposableArchitecture

struct YearMonthDateFeature: ReducerProtocol {

    struct State: Equatable {
        // Scope State
        var baggleDatePicker = BaggleDatePickerFeature.State()
    }

    enum Action: Equatable {

        // Tap
        case completeButtonTapped
        case cancelButtonTapped

        // Scope Action
        case baggleDatePicker(BaggleDatePickerFeature.Action)
    }

    @Dependency(\.dismiss) var dismiss

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Scope
        Scope(state: \.baggleDatePicker, action: /Action.baggleDatePicker) {
            BaggleDatePickerFeature()
        }

        // MARK: - Reduce

        Reduce { state, action in

            switch action {

            case .completeButtonTapped:
                return .run { _ in await self.dismiss() }

            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }

            case .baggleDatePicker:
                return .none
            }
        }
    }
}
