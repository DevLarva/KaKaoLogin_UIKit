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
    @Published var isLoggedIn : Bool = false
    
    lazy var loginStatusInfo : AnyPublisher<String?, Never> =
    $isLoggedIn.compactMap{ $0 ? "로그인 상태" : "로그아웃 상태"}.eraseToAnyPublisher()
    
    init() {
        print("kakaoAuthVM init() called")
    }
    //카카오톡앱으로 로그인 인증
    func kakaoLoginWithApp() async ->Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                    
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    // 카카오 계정 웹으로 로그인
    func kakaoLoginWithAccout() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor
    func kakaoLogin() {
        print("KakaoAuthVM - handleKakaoLogin() called")
        Task{
            // 카카오톡 설치 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                isLoggedIn = await kakaoLoginWithApp()
                
                // 카톡이 설치되지 않은 경우
                
            } else {
                isLoggedIn  = await kakaoLoginWithAccout()
                
                
            }
        }
        
        
    }// login
    
    func kakoLogout() {
        Task {
            if await handlekakaoLogout() {
                self.isLoggedIn = false
            }
        }
    }
    
    func handlekakaoLogout() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
            
        }
    }
}

