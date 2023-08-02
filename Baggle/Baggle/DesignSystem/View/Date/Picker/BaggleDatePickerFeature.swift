//
//  BaggleDatePickerFeature.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

import ComposableArchitecture

struct BaggleDatePickerFeature: ReducerProtocol {

    struct State: Equatable {
        var date: Date = Date()
    }

    enum Action: Equatable {
        // MARK: - Scope Action
        case dateChanged(Date)
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Reduce

        Reduce { state, action in

            switch action {
            case let .dateChanged(newDate):
                state.date = newDate
                return .none
            }
        }
    }
}
