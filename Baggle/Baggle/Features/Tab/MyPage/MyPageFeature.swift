//
//  MyPageFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct MyPageFeature: ReducerProtocol {

    struct State: Equatable {
        var isLoading: Bool = false
    }

    enum Action: Equatable {
        case withdrawButtonTapped
        case withdrawResult(WithdrawServiceStatus)
        
        case delegate(Delegate)
        
        enum Delegate {
            case moveToLogin
        }
    }

    @Dependency(\.withdrawService) var withdrawService
    
    var body: some ReducerProtocolOf<Self> {

        Reduce { state, action in

            switch action {

            case .withdrawButtonTapped:
                state.isLoading = true
                return .run { send in
                    let withdrawStatus = await withdrawService.withdraw()
                    await send(.withdrawResult(.keyChainError))
                }
                
            case let .withdrawResult(status):
                state.isLoading = false
                switch status {
                case .success:
                    print("성공")
                    return .run { send in await send(.delegate(.moveToLogin)) }
                case let .fail(apiError):
                    print("API Error \(apiError)")
                case .keyChainError:
                    print("키체인 에러")
                }
                return .none
                
            case .delegate(.moveToLogin):
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
