//
//  NaverLoginViewController.swift
//  OpenAPILogin
//
//  Created by 김예은 on 2018. 6. 25..
//  Copyright © 2018년 yeen. All rights reserved.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire
import Kingfisher

class NaverLoginViewController: UIViewController {

    @IBOutlet weak var logoutBtn: UIButton! {
        didSet {
            logoutBtn.isHidden = true
        }
    }
    
    @IBOutlet weak var naverLoginBtn: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.image = nil
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = nil
        }
    }
    
    @IBOutlet weak var birthLabel: UILabel! {
        didSet {
            birthLabel.text = nil
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.text = nil
        }
    }
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 로그아웃 버튼을 눌렀을 때는 두 가지의 방향을 작성.
    // 첫 번째는 단순한 로그아웃이고 인증 토큰만을 삭제한다면
    // 두 번째 연동 해제이며 이는 애플리케이션에 저장된 정보와 네이버 서버에 저장된 인증 정보를 삭제
    @IBAction func logoutAction(_ sender: UIButton) {
        loginInstance?.resetToken() // 로그아웃
        //loginInstance?.requestDeleteToken() // 연동해제
        logoutBtn.isHidden = true
        naverLoginBtn.isHidden = false

    }
    
    //로그인 버튼을 눌렀을 때 delegate를 지정하고 인증 요청.
    //이렇게 인증 요청을 하면 위에서 지정한대로 네이버 앱이나 사파리를 통해 인증이 진행
    @IBAction func naverLoginAction(_ sender: UIButton) {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()

    }

}

extension NaverLoginViewController: NaverThirdPartyLoginConnectionDelegate{
    
    // 네이버 앱이 설치되어 있지 않다면 사파리를 통해 인증 진행 화면을 띄우는 코드
    func oauth20ConnectionDidOpenInAppBrowser(forOAuth request: URLRequest!) {
        let naverLoginViewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request)!
        present(naverLoginViewController, animated: true, completion: nil)
    }
    
    // 이 두 메소드는 접근 토큰과 갱신 토큰을 성공적으로 받아왔을 때 호출되는 메소드.
    //발급 받은 토큰의 유효 기간은 1시간으로 isValidAccessTokenExpireTimeNow() 메소드를 통해 현재 갖고 있는 접근 토큰의 유효 기간이 만료되었는지를 판단할 수 있음
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        getNaverEmailFromURL()
        logoutBtn.isHidden = false
        naverLoginBtn.isHidden = true
    }
   
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Success oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
        getNaverEmailFromURL()
        logoutBtn.isHidden = false
        naverLoginBtn.isHidden = true
    }
    
    // 연동이 성공적을 해제되었을 때 호출되는 메소드
    func oauth20ConnectionDidFinishDeleteToken() {
        print("로그아웃 해제")
    }
    
    // 접근 토큰, 갱신 토큰, 연동 해제등이 실패했을 때 호출되는 메소드
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        print(error)
    }
    
    // 접근 토큰이나 갱신 토큰이 발급되었을 때 실행되어야 할 메소드로 해당 토큰으로 실질적인 사용자 정보에 접근하는 메소드.
    //토큰을 정상적으로 받아오면 NaverThird PartyLoginConnection.getSharedInstance() 안에 담기고 이 토큰을 토큰 타입과 함께 헤더에 담아 코드에 명시된 URL로 요청을 하게 되면 원하는 사용자 정보를 받아올 수 있음. 해당 URL은 네이버 개발자 센터 가이드에 소개되어 있음.
    func getNaverEmailFromURL(){
        guard let loginConn = NaverThirdPartyLoginConnection.getSharedInstance() else {return}
        guard let tokenType = loginConn.tokenType else {return}
        guard let accessToken = loginConn.accessToken else {return}
        
        let authorization = "\(tokenType) \(accessToken)"
        Alamofire.request("https://openapi.naver.com/v1/nid/me", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : authorization]).responseJSON { (response) in
            guard let result = response.result.value as? [String: Any] else {return}
            guard let object = result["response"] as? [String: Any] else {return}
            guard let birthday = object["birthday"] as? String else {return}
            guard let name = object["name"] as? String else {return}
            guard let email = object["email"] as? String else {return}
            guard let profile_image = object["profile_image"] as? String else {return}
            
            self.birthLabel.text = birthday
            self.emailLabel.text = email
            self.nameLabel.text = name
            self.profileImageView.kf.setImage(with: URL(string: profile_image),
                placeholder: UIImage())
        }
    }
}
