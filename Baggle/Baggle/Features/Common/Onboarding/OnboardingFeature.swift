//
//  OnboardingFeature.swift
//  Baggle
//
//  Created by youtak on 2023/09/13.
//

import ComposableArchitecture

struct OnboardingFeature: ReducerProtocol {

    struct State: Equatable {
    }

    enum Action: Equatable {
        
        case buttonTapped
        
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case moveToHome
        }
    }

    var body: some ReducerProtocolOf<Self> {

        // MARK: - Reduce
        
        Reduce { _, action in

            switch action {
            case .buttonTapped:
                return .run { send in await send(.delegate(.moveToHome))}
                
            case .delegate(.moveToHome):
                return .none
            }
        }
    }
}
