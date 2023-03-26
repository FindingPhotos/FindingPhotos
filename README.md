# FindingPhotos
팀 프로젝트: 주변 즉석사진점을 검색하고 사진을 저장하는 iOS 앱 개발
노션정리 : https://jesskoh.notion.site/FindingPhotos-8550cf67ce934538a998e61919b24a87

- 프로젝트 이름 : 인생네컷찾기(가제)
    - 계획
        - 탭 3개
            - 지도api를 이용해 근처 모든 종류의 인생네컷 검색
            - 개인 사진 업로드 앨범 / 폴더로 구현(테이블뷰-컬렉션뷰 중첩)
            - 개인정보/설정
        - 추후 구현 가능: 로그인 / 친구와 앨범 공유 / 테이블뷰-컬렉션뷰 전환
    
- 3/23일자 회의 내용
    - 지도: Kyle
        - 1차 구현
            - 지도 api : 카카오 (즉석사진 카테고리로 제한된 검색 용이) 로드
            - ModalPresent를 이용한 장소 정보 구현
        - 2차 구현
            - 장소 검색기능
            - 즐겨찾기 설정 및 목록
    - 앨범 : Jess
        - 1차 구현
            - NavigationController/collectionView를 이용한 중첩된 폴더 형식의 UI 구현
            - NSCache를 이용한 데이터 캐시처리
        - 2차 구현
            - TableView로 폴더 구현
            - Firestore 및 Firebase storage를 이용해 앨범
            - 계정기능 구현 후 친구와 공유 가능
    - 계정 : John
        - 1차 구현
            - 설정 방식 : 로컬 이메일 / 익명로그인
            - 연동 방식 : firebaseAuth
            - 계정에 필요한 값 : 이메일, 닉네임, uid, 친구목록(팔로우)
            - 로그인화면 및 회원가입화면 UI 구현
            - user 탭에 사용자 정보 나타내기
        - 2차 구현
            - 애플로그인 / 네이버 소셜로그인 구현
    
- 각 영역 담당 지정
- 디자인패턴 지정 : MVVM 구현 방식 / Rx 구현 여부 및 방식
    - RxSwift로 진행하는 이유? : 협업을 위한 형식의 통일.
    - RxSwift로 바로 진행하기…
- 사용할 라이브러리
    - RxSwift
    - SnapKit
    - Firestore : 사진저장
    - FirebaseAuth : 계정 저장
    - 로컬 데이터베이스 : CoreData
    - 
- UI : codebase / Snapkit
- 데이터베이스
    - 로컬 데이터베이스 :  CoreData
    - 네트워크 데이터베이스 : Firestore
    - 이미지 데이터베이스 : Firebase Storage
- 계정 로그인 방식 : 로컬로그인 / 익명로그인 with FirebaseAuth // 차후 : 애플로그인 / 네이버로그인
- 지도 api : 카카오맵
- 데이터 캐시처리 : NSCache
