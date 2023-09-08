//
//  LoginFeature.swift
//  PromiseDemo
//
//  Created by youtak on 2023/07/19.
//

import ComposableArchitecture

struct LoginFeature: ReducerProtocol {
    
    struct State: Equatable {
        
        var disableDismissAnimation: Bool = false
        var completeSplashAnimation: Bool = false
        
        // MARK: - Alert
        
        var isAlertPresented: Bool = false
        var alertType: AlertLoginType?
        
        // MARK: - Child State
        
        @PresentationState var signUpNickname: SignUpFeature.State?
    }
    
    enum Action: Equatable {
        
        case completeSplashAnimation
        
        // MARK: - Button Tapped
        
        case appleLoginButtonTapped(String)
        case kakaoLoginButtonTapped
        case requestLogin(LoginPlatform, String)
        case moveToSignUp(LoginPlatform, String)
        
        // MARK: - Apple Login
        
        case appleLoginFailed
        
        // MARK: - Alert
        
        case presentAlert(Bool)
        case alertTypeChanged(AlertLoginType)
        case alertButtonTapped
        
        // MARK: - Child Action
        
        case signUpNickname(PresentationAction<SignUpFeature.Action>)
        
        // MARK: - Delegate
        case delegate(Delegate)
        
        enum Delegate {
            case moveToMainTab
        }
    }
    
    @Dependency(\.loginService) private var loginService
    
    var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            
            switch action {
                
            case .completeSplashAnimation:
                state.completeSplashAnimation = true
                return .none
                
                
                // MARK: - Button Tapped
                
            case .appleLoginButtonTapped(let token):
                print("🍎 확인용 - token: \(token)")
                return .run { send in
                    // 로그인 통신
                    await send(.requestLogin(.apple, token))
                }
                
            case .kakaoLoginButtonTapped:
                return .run { send in
                    do {
                        let token = try await loginService.kakaoLogin()
                        print("🍫 확인용 - token: \(token)")
                        // 로그인 통신
                        await send(.requestLogin(.kakao, token))
                    } catch {
                        print("카카오 로그인 에러")
                        print(error)
                    }
                }
                
            case .requestLogin(let platform, let token):
                let requestModel = LoginRequestModel(
                    platform: platform,
                    fcmToken: UserDefaultList.fcmToken ?? ""
                )
                
                return .run { send in
                    let result = await loginService.login(requestModel, token)
                    
                    switch result {
                    case .success: // 성공이면 메인 탭 이동
                        await send(.delegate(.moveToMainTab))
                    case .requireSignUp: // 새로운 유저면 회원가입 화면 이동
                        await send(.moveToSignUp(platform, token))
                    case .networkError(let description): // 네트워크 에러
                        await send(.alertTypeChanged(.networkError(description)))
                    case .userError: // 유저 정보 저장 에러
                        await send(.alertTypeChanged(.userError))
                    }
                }
                
            case .moveToSignUp(let platform, let token):
                state.disableDismissAnimation = false // 화면 전환 애니메이션 활성화
                
                state.signUpNickname = SignUpFeature.State(
                    loginPlatform: platform,
                    socialLoginToken: token
                )
                return .none
                
                // MARK: - Apple Login
                
            case .appleLoginFailed:
                return .run { send in await send(.alertTypeChanged(.appleLoginError)) }
                
                // MARK: - Alert
                
            case .presentAlert(let isPresented):
                if !isPresented {
                    state.alertType = nil
                }
                state.isAlertPresented = isPresented
                return .none
                
            case .alertTypeChanged(let alertType):
                state.alertType = alertType
                state.isAlertPresented = true
                return .none
                
            case .alertButtonTapped:
                guard let alertType = state.alertType else {
                    return .none
                }
                state.alertType = nil
                
                switch alertType {
                case .networkError, .userError, .appleLoginError:
                    return .none
                }
                
                // MARK: - Child Action
                
            case .signUpNickname(.presented(.delegate(.successSignUp))):
                state.disableDismissAnimation = true // 홈 화면 이동시 화면 전환 애니메이션 비활성화
                return .run { send in await send(.delegate(.moveToMainTab)) }
                
            case .signUpNickname:
                return .none
                
                // MARK: - Delegate
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$signUpNickname, action: /Action.signUpNickname) {
            SignUpFeature()
        }
    }
}
