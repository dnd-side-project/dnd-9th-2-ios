//
//  MyPageFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/22.
//

import ComposableArchitecture

struct MyPageFeature: ReducerProtocol {

    struct State: Equatable {
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

        Reduce { _, action in

            switch action {

            case .withdrawButtonTapped:
                return .run { send in
                    let withdrawStatus = await withdrawService.withdraw()
                    await send(.withdrawResult(withdrawStatus))
                }
                
            case let .withdrawResult(status):
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
