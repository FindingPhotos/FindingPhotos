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
    
    func logIn(email: String, password: String) -> Observable<Bool> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    print("DEBUG: 로그인 실패")
                    observer.onNext(false)
                    return
                }
                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
                observer.onNext(true)
            }
            return Disposables.create()
        }
    }
    
    func signIn(email: String, password: String, name: String, image: UIImage?) -> Observable<String?>  {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard error == nil else {
                    print("debug: \(error!.localizedDescription)")
                    observer.onNext("이미 가입한 이메일입니다❌")
                    return
                }
                guard let email = authResult?.user.email,
                      let uid = authResult?.user.uid else { return }
                if let image {
                    ImageUploaderToFirestorage.uploadImage(image: image) { imageUrlString in
                        FirestoreAddress.collectionUsers.document(uid).setData(["name": name, "email": email, "uid": uid, "imageUrl": imageUrlString])
                        observer.onNext(nil)
                    }
                } else {
                    let currentUserModel = UserModel(name: name, email: email, uid: uid)
                    print("DEBUG: currentUserModel:\(currentUserModel)")
                    FirestoreAddress.collectionUsers.document(uid).setData(["name": name, "email": email, "uid": uid, "imageUrl": ""])
                    observer.onNext(nil)
                }
                print("DEBUG: 회원가입 성공")
                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
            }
            return Disposables.create()
        }
    }
    
    /*
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
                        FirestoreAddress.collectionUsers.document(uid).setData(["name": name, "email": email, "uid": uid, "imageUrl": imageUrlString])
                        observer.onNext(true)
                    }
                } else {
                    let currentUserModel = UserModel(name: name, email: email, uid: uid)
                    print("DEBUG: currentUserModel:\(currentUserModel)")
                    FirestoreAddress.collectionUsers.document(uid).setData(["name": name, "email": email, "uid": uid, "imageUrl": ""])
                    observer.onNext(true)
                }
                print("DEBUG: 회원가입 성공")
                NotificationCenter.default.post(name: .AuthStateDidChange, object: nil)
            }
            return Disposables.create()
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
    
    
    func getUserInformation() -> Observable<UserModel?> {
        return Observable.create { observer in
            guard let currentUser = Auth.auth().currentUser else { return Disposables.create() }
            guard currentUser.isAnonymous == false else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            let uid = currentUser.uid
            FirestoreAddress.collectionUsers.document(uid).getDocument { snapshot, error in
                guard error == nil else { return observer.onError(error!)}
                snapshot?.data().map { data in
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let imageUrl = data["imageUrl"] as? String ?? ""
                    let userModel = UserModel(name: name, email: email, uid: uid, profileImageUrl: imageUrl)
                    observer.onNext(userModel)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func updateUserInformation(changedName: String?, changedImageUrl: String?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if changedName != nil && changedImageUrl != nil {
            guard let changedName, let changedImageUrl else { return }
            FirestoreAddress.collectionUsers.document(uid).updateData(["name": changedName, "imageUrl": changedImageUrl])
        } else if let changedName {
            FirestoreAddress.collectionUsers.document(uid).updateData(["name": changedName])
        } else if let changedImageUrl {
            FirestoreAddress.collectionUsers.document(uid).updateData(["imageUrl": changedImageUrl])
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
        firebaseAuth.currentUser?.delete() { error in
            guard error != nil else { return print("DEBUG: delete error:\(error)") }
            FirestoreAddress.collectionUsers.document(uid).delete()
        }
    }
    
    func sendForgotPasswordEmail(email: String) -> Observable<String?> {
        let firebaseAuth = Auth.auth()
        return Observable.create { observer in
            firebaseAuth.sendPasswordReset(withEmail: email) { error in
                guard error == nil else {
                    print("DEBUG: Password reset error occured :\(error?.localizedDescription)")
                    observer.onNext("입력하신 이메일이 존재하지 않습니다❌")
                    return
                }
                observer.onNext(nil)
            }
            return Disposables.create()
        }
    }
    
    // Auth 리스트에 존재하는 이메일인지 확인 불가...
//    func checkEmailForReset(email : String) {
//        let firebaseAuth = Auth.auth()
//
//
//    }
}
