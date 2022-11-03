//
//  KakaoAuthVM.swift
//  KaKaoLogin(UIKit)-tuto
//
//  Created by 백대홍 on 2022/11/02.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KaKaoAuthVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    init() {
        print("kakaoAuthVM init() called")
    }
    
    func handleKaKaoLogin() {
        print("KakaoAuthVM - handleKakaoLogin() called")
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                }
            }
        }
            // 카톡이 설치되지 않은 경우
        else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        _ = oauthToken
                    }
                }
        }

    }
}

