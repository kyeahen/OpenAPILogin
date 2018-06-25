//
//  AppDelegate.swift
//  OpenAPILogin
//
//  Created by 김예은 on 2018. 6. 20..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //네이버 로그인
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isInAppOauthEnable = true // 네이버 앱이 설치되어있다면 네이버 앱을 통해 인증
        instance?.isNaverAppOauthEnable = true // 네이버 앱이 없다면 사파리를 통해 인증. 앱 인증과 사파리 인증이 둘 다 활성화되어 있다면 네이버 앱이 있는지 먼저 검사를 한 후 네이버 앱이 있다면 네이버 앱으로, 없다면 사파리를 통해 인증을 진행
        instance?.isOnlyPortraitSupportedInIphone() // 인증 화면을 세로 모드에서만 진행하는 코드
        // NaverThirdPartyConstantsForApp.h 파일에서 명시해준 URL Scheme과 클라이언트 ID, Secret, 앱 이름을 할당
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

