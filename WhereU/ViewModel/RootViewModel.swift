//
//  MainViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/02.
//

import Foundation
import KakaoSDKUser
import AuthenticationServices

final class RootViewModel {
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            loginStateObserver(user)
        }
    }
    
    var loginStateObserver: (User) -> Void = { _ in }
    
    func checkUserLoggedIn() -> Bool {
        guard let platform = UserDefaults.standard.string(forKey: Constants.LOGIN_PLATFORM) else {
            // 로그인한 기록이 없음
            return false
        }
        if platform == Constants.APPLE {
            checkAppleLogin()
        } else {
            checkKakaoLogin()
        }
        return true
    }
    
    
    private func checkAppleLogin() {
        // Apple 로그인 확인
        // Apple은 최초 로그인시에만 id, name, email을 모두 전달함
        // 이 후에는 name과 email을 받을 수 없어서 서버로부터 가져오는 작업은 따로 처리해야함
        guard let uid = UserDefaults.standard.string(forKey: Constants.APPLE_USER_ID) else {
            // 애플 로그인한적 없음
            print("애플 로그인 필요")
            return
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: uid) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // Authorization Logic
                print("애플 로그인 완료")
                self.user = User(id: uid, name: "홍길동", profileImage: "")
            default:
                break
            }
        }
    }
    
    private func checkKakaoLogin() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("사용자 정보 가져오기 성공")
                guard let user = user else {
                    print("user is nil")
                    return
                }
                guard let id = user.id,
                      let name = user.properties?["nickname"],
                      let profileImageUrl = user.properties?["profile_image"] else { return }
                        
                let currentUser = User(id: String(id), name: name, profileImage: profileImageUrl)
                self.user = currentUser
            }
        }
    }
}
