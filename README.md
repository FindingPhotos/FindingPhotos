<img width="100" alt="1" src="https://user-images.githubusercontent.com/108605997/231352131-34d4e272-f916-4d69-ba9f-2520ee5da458.png"> 

## Nemo : 네모
📸 나의 네 컷 사진 모아보기  
> 개발기간 2023.03.23 ~ 2023.04.08 (1차)

## 팀 구성원
|[강창혁(Kyle)](https://github.com/KangChangHyeok)|[이형주(John)](https://github.com/HJLEE-22)|[고주영(Jess)](https://github.com/jessicakohh)|
|---|---|---|
|<img width="100" alt="1" src="https://user-images.githubusercontent.com/108605997/231363321-97ab6aa7-afcb-4649-acb9-9532e57e9949.jpeg">|<img width="100" alt="1" src="https://user-images.githubusercontent.com/108605997/231363267-33b6aa65-03a7-4f4b-806b-54a071ff589e.png">|<img width="100" alt="1" src="https://user-images.githubusercontent.com/108605997/231362961-11907fbe-1c29-4862-bf73-0bfb490b9746.png"> |
|지도 관련 기능 구현|계정 관련 기능 구현|앨범 관련 기능 구현|

## 구현기능
### 📍 지도
|포토부스 찾기|포토부스 즐겨찾기|
|---|---|
|이미지|이미지|
|내 주변 가장 가까이 위치한 포토부스를 한 눈에 볼 수 있습니다.|내가 즐겨찾는 포토부스를 저장하고, 한 눈에 확인할 수 있습니다.|

### 📷 앨범
|나의 네 컷 사진 모아보기|사진 및 메모 저장하기|선택하여 삭제하기|
|---|---|---|
|이미지|이미지|이미지|
|앨범 속 네 컷 즉석사진을 한 눈에 모아볼 수 있습니다.|간단한 메모와 함께 날짜별로 사진을 저장할 수 있습니다.|사진을 하나하나 누르지 않고 선택하여 삭제할 수 있습니다.|

### 🔐 로그인
|이메일로 회원가입하기|이메일로 로그인하기|가입하지 않고 둘러보기|
|---|---|---|
|이미지|이미지|이미지|
|- 유저들의 기존 이메일을 이용해 회원가입을 할 수 있습니다. <br> 원하는 프로필 사진을 선택하고, 닉네임을 설정할 수 있습니다.|회원가입한 아이디와 비밀번호로 로그인 할 수 있습니다.|가입하지않고 익명으로 로그인할 수 있습니다.|

|비밀번호 재설정|탈퇴하기|
|---|---|
|이미지|이미지|
|가입한 이메일 주소로 비밀번호를 리셋할 수 있습니다. |서비스를 더이상 원하지 않는다면 저장된 유저 정보를 삭제하고 탈퇴할 수 있습니다. |

### 차후 업데이트 예정
|분류|기능|
|---|---|
|지도| - 장소 검색기능|
|앨범| - TableView로 폴더 구현|
|로그인| - 애플로그인 / 네이버 소셜 로그인 구현|



## ⚙️ 기술 스택
|Swift|뷰 드로잉|백엔드|네트워킹|
|---|---|---|---|
|<img src="https://img.shields.io/badge/Swift5-494949?style=flat-square&logo=Swift&#F05138=white"> <img src="https://img.shields.io/badge/UIKit-494949?style=flat-square&logo=UIKit&logoColor=white">|<img src="https://img.shields.io/badge/SnapKit-494949?style=flat-square&logo=SnapKit&logoColor=white">|<img src="https://img.shields.io/badge/Realm-494949?style=flat-square&logo=Realm&logoColor=white"> <img src="https://img.shields.io/badge/FireBase-494949?style=flat-square&logo=FireBase&logoColor=white">|<img src="https://img.shields.io/badge/URLSession-494949?style=flat-square&logo=URLSession&logoColor=white">|

|반응형 프로그래밍|개발 아키텍처 및 디자인 패턴|오픈소스|
|---|---|---|
|- RxSwift <br> - RxCocoa <br> - Rxgesture <br> - RxViewController <br> - RxRealm <br> - RxDataSources | - MVVM(일부분 MVC 패턴 구현)|- Kingfisher <br> - NMaps(네이버 맵 api) <br> - IQKeyboardManagerSwift|



