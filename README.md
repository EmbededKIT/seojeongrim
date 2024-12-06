# seojeongrim

1. apk파일 실행시킬 때
apk파일은 그냥 실행시키면 됩니다.
하지만 라즈베리파이 블루투스 모듈이 제 모듈의 주소로 설정되어 있어 다른 모듈과 통신하려고 하면 main.dart파일을 통해 블루투스 연결 주소를 직접 바꾸시거나
저한테 블루투스 모듈 주소를 보내주시면 해당 모듈 주소로 변경된 apk파일을 보내드리겠습니다. 

3. main.dart파일을 new flutter project에 그대로 복사 붙여넣기 할 때
apk 파일로 구동하지 않고 직접 vs code나 android studio로 실행시킬 때,
이 README 파일에 있는 사항들을 전부 실행시켜야 작동합니다.

2-1. pubspec.yaml에 해당 코드 추가
dependencies:
  flutter_bluetooth_serial: ^0.4.0
  permission_handler: ^10.0.0

flutter:
  assets:
    - assets/fonts/Cafe24Ssurround.ttf
    - assets/main_image.png
  fonts:
    - family: Cafe24Ssurround
      fonts:
        - asset: assets/fonts/Cafe24Ssurround.ttf

추가 후 우측 상단 pub get 누르기

2-2. AndroidManifest.xml에 해당 코드 추가
해당 파일 위치: 좌측 상단의 Project를 Android로 변경 후 프로젝트 파일>app>src>main>AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"> 아래에 해당 코드 추가
[추가 코드들]
    <!-- 페어링된 장치와의 연결을 위한 권한 -->
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
    <uses-permission android:name="android.permission.NEARBY_DEVICES" />

2-3. assets 디렉토리 추가 및 폰트, 이미지 파일 추가
좌측상단의 Android를 다시 Project로 바꾸고 계속.
메인 프로젝트 디렉토리에서 New를 눌러 디렉토리 추가 이름: assets
assets 디렉토리 아래에 fonts 디렉토리 추가
올려진 main_image.png를 assets 디렉토리에 추가
https://fonts.cafe24.com/ 해당 홈페이지에서 카페24 써라운드 다운로드
Cafe24Ssurround.ttf 파일을 fonts 디렉토리에 추가

2-4. main.dart 파일에서 블루투스 주소 변경
Serial Bluetooth Terminal 앱에서 페어링 한 블루투스 모듈의 주소 확인
138번 줄의 final String targetAddress = "98:D3:41:FD:DE:CC";에서 98:D3:41:FD:DE:CC이 값을 자신의 모듈 주소로 변경

2-5. apk파일 만들기
왼쪽 위 줄 4개 클릭>Build 클릭>flutter>build apk 클릭
이 과정에서 오류가 난다면 그냥 블루투스 모듈의 주소를 주시면 제가 apk 만들어서 보내드리겠습니다.

2-6. 앱 실행
apk를 설치한 후 앱 내에서 시작버튼을 눌러서 인원수 입력 페이지로 간 뒤 연결 버튼을 누름
권한 요청을 허용하고 연결함. 이 때 블루투스 모듈은 휴대폰과 페어링 되어있어야 함
블루투스 모듈의 빛이 깜빡거리지 않으면 연결 성공
bluetooth_server.c를 라즈베리 파이에서 실행, 이 때 baudrate가 작동하고 있는 블루투스 모듈과 같아야함 강의자료 5-3 참고
실행시키고 앱에서 인원수를 입력해서 보내면 printf로 받은 값 그대로 출력>정상작동

2-7. 확인 끝

