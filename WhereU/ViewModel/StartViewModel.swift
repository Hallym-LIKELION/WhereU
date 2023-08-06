//
//  StartViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/02.
//

import Foundation
import AuthenticationServices
import KakaoSDKUser

final class StartViewModel {

    func appleLogin(currentVC: StartViewController) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = currentVC
        authorizationController.presentationContextProvider = currentVC
        authorizationController.performRequests()
    }
    
    func successAppleLogin(authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
            let email = appleIDCredential.email
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \(name)")
            
            UserDefaults.standard.setValue(userIdentifier, forKey: Constants.APPLE_USER_ID)
            UserDefaults.standard.setValue(Constants.APPLE, forKey: Constants.LOGIN_PLATFORM)
        default:
            break
        }
    }
    
    func kakaoLogin(completion: @escaping () -> Void) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    UserDefaults.standard.setValue(Constants.KAKAO, forKey: Constants.LOGIN_PLATFORM)
                    
                    self.getKakaoUserInfo { completion() }
                }
            }
        }
    }
    
    private func getKakaoUserInfo(completion: @escaping () -> Void) {
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
                completion()
            }
        }
    }
    
    func makeAttributedText() -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(
            string: "근처에서 일어나는 재난 실시간 알림부터\n재난 가이드까지",
            attributes: [.font: UIFont.systemFont(ofSize: 14)]
        )
        attrString.append(
            NSAttributedString(
                string: "재난의 WAY, 웨얼유",
                attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]
            )
        )
        
        return attrString
    }
}
 
