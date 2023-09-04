//
//  MeetingDateButtonFeature.swift
//  Baggle
//
//  Created by youtak on 2023/08/31.
//

import Foundation

import ComposableArchitecture

struct MeetingDateButtonFeature: ReducerProtocol {

    struct State: Equatable {
        var dateButtonBeforeStatus: DateInputStatus = .inactive
        var timeButtonBeforeStatus: DateInputStatus = .inactive
        
        var dateButtonStatus: DateInputStatus = .inactive
        var timeButtonStatus: DateInputStatus = .inactive
    }

    enum Action: Equatable {
        case selectDateButtonTapped
        case selectTimeButtonTapped
    }

    var body: some ReducerProtocolOf<Self> {
        
        // MARK: - Scope
        
        // MARK: - Reduce
        
        Reduce { _, action in
            switch action {

            case .selectDateButtonTapped:
                return .none
                
            case .selectTimeButtonTapped:
                return .none
            }
        }
    }
}
