//
//  AuthManager.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/31.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import RxSwift

final class AuthManager {
    
    static let shared = AuthManager()
    
//    func logIn(email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                print("DEBUG: 로그인 실패")
//                return
//            }
//            NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
//        }
//    }
    func logIn(email: String, password: String) -> Observable<Void> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    print("DEBUG: 로그인 실패")
                    return
                }
                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
            }
            return Disposables.create()
        }
    }
    /*
    func logIn(email: String, password: String) -> Observable<(AuthDataResult?, Error)> {
        Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    print("DEBUG: 로그인 실패")
                     observer.onNext((nil, error))
                }
                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                observer.onNext((authResult, nil))
                print("DEBUG: 로그인 성공 ")
            }
            return Disposables.create()
        }
    }
     */
    
    func signIn(email: String, password: String, name: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let email = authResult?.user.email,
                  let uid = authResult?.user.uid else { return }
            let currentUserModel = UserModel(name: name, email: email, uid: uid)
            UserDefaults.standard.set(currentUserModel, forKey: "currentUserModel")
            NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
        }
    }
    func signIn(email: String, password: String, name: String, image: UIImage?) -> Observable<Bool>  {
        
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    observer.onNext(false)
                    return
                }
                guard let email = authResult?.user.email,
                      let uid = authResult?.user.uid else { return }
                if let image {
                    ImageUploaderToFirestorage.uploadImage(image: image) { imageUrlString in
                        let currentUserModel = UserModel(name: name, email: email, uid: uid, profileImageUrl: imageUrlString)
//                        UserDefaults.standard.set(currentUserModel, forKey: "currentUserModel")
                        observer.onNext(true)
                    }
                } else {
                    let currentUserModel = UserModel(name: name, email: email, uid: uid)
                    print("DEBUG: currentUserModel:\(currentUserModel)")

//                    UserDefaults.standard.set(currentUserModel, forKey: "currentUserModel")
                    observer.onNext(true)
                }
                print("DEBUG: 회원가입 성공")
                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
            }
            return Disposables.create()
        }
    }
    /*
    func signInWithAnonymous() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
        }
    }
    */
    func signInWithAnonymous() -> Observable<Void> {
        return Observable.create { observer in
            Auth.auth().signInAnonymously() { (authResult, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    print(error.debugDescription)
                    print("DEBUG: 익명 로그인 에러")
                    return
                }
                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
            }
            return Disposables.create()
        }
    }
    
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteAccount() {
        let firebaseAuth = Auth.auth()
        guard let uid = firebaseAuth.currentUser?.uid else { return }
        do {
           try firebaseAuth.currentUser?.delete() { error in
//                firestore에 유저데이터 생성 시 지워주기
//                collectionUsers.document(uid).delete()
               print("DEBUG: delete error:\(error)")
               UserDefaults.standard.removeObject(forKey: "currentUserModel")
            }
        } catch {
            
        }
    }
    
}



//        Auth.auth().addStateDidChangeListener(<#T##listener: (Auth, User?) -> Void##(Auth, User?) -> Void#>)
