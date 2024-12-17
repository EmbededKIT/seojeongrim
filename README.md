# seojeongrim

## 1. app-release.apk
 * 모바일 앱 다운로드 파일(안드로이드에서만 동작)

<br/><br/>

## 2. bluetooth_server.c
 * UART 통신 이용
 * 참고: 강의자료 5-3 UART 통신 예제 코드 2
 * 동작 순서
   1. UART1 포트 열기
   2. 데이터 수신
   3. 읽은 데이터가 원하는 데이터인 경우에 저장
   4. 데이터 출력

<br/><br/>

## 3. main.dart
 * 참고: Serial Bluetooth Terminal 앱
 * 앱 화면
    1. 1페이지(메인 화면)
      - 시작 버튼: 2페이지로 이동
      - 설명 버튼: 앱 기능 설명 출력
![1734445958737-1](https://github.com/user-attachments/assets/21f7a83d-1df3-4bcb-be1f-78ac0e5fe784)
    2. 2페이지(블루투스 연결 화면)
      - 연결 버튼: 페어링 된 라즈베리 파이 모듈과 연결
      - 숫자 입력 박스: 1~5사이의 수 입력
      - 전송 버튼: 입력한 수를 라즈베리 파이로 전송
![1734445958737-0](https://github.com/user-attachments/assets/0af7d213-2b35-4b2e-b85c-0cc636eee748)
 * 사용 기술
   1. 안드로이드 권한 요청(근처 기기)
   2. 페어링 된 블루투스 모듈과 연결
   3. 연결된 모듈로 값 전달

<br/><br/>

## 4. main_image.png
 * 메인 화면 이미지

