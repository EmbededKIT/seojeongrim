//해당 코드를 실행하기 전에 꼭 README 파일에 적혀져있는 사항을 실행한 뒤 실행할 것

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart'; // 권한 요청 패키지
import 'dart:typed_data'; // Uint8List를 사용하기 위해 추가

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // 배경 흰색
        fontFamily: 'Cafe24Ssurround', // 사용자 지정 폰트
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 중앙 이미지
            Image.asset(
              'assets/main_image.png', // 중앙 이미지
              height: MediaQuery.of(context).size.height * 0.4, // 화면 높이의 40%
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 화면 높이의 2% 여백
            // 앱 제목
            Text(
              '카드분배기',
              style: TextStyle(
                fontFamily: 'Cafe24Ssurround', // 폰트 적용
                fontSize: MediaQuery.of(context).size.width * 0.12, // 화면 너비의 12%
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04), // 화면 높이의 4% 여백
            // 시작 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // 버튼 색상
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.25, // 너비의 25%
                  vertical: MediaQuery.of(context).size.height * 0.025, // 높이의 2.5%
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BluetoothApp()),
                );
              },
              child: Text(
                '시작',
                style: TextStyle(
                  fontFamily: 'Cafe24Ssurround', // 폰트 적용
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05, // 너비의 5%
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03), // 화면 높이의 3% 여백
            // 설명 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // 버튼 색상
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.25, // 너비의 25%
                  vertical: MediaQuery.of(context).size.height * 0.025, // 높이의 2.5%
                ),
              ),
              onPressed: () {
                _showExplanationDialog(context);
              },
              child: Text(
                '설명',
                style: TextStyle(
                  fontFamily: 'Cafe24Ssurround', // 폰트 적용
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05, // 너비의 5%
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExplanationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          '앱 설명',
          style: TextStyle(
            fontFamily: 'Cafe24Ssurround', // 폰트 적용
          ),
        ),
        content: Text(
          '이 앱은 블루투스를 통해 입력받은 인원수를 전송합니다.',
          style: TextStyle(
            fontFamily: 'Cafe24Ssurround', // 폰트 적용
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '확인',
              style: TextStyle(
                fontFamily: 'Cafe24Ssurround', // 폰트 적용
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  final String targetAddress = "98:D3:41:FD:DE:CC"; // HC-06 블루투스 주소
  BluetoothConnection? connection; // 블루투스 연결 객체
  String connectionStatus = "연결되지 않음"; // 초기 연결 상태
  final TextEditingController valueController = TextEditingController(); // 값 입력 컨트롤러

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  // 블루투스 관련 권한 요청
  Future<bool> _requestBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise
    ].request();
    return statuses.values.every((status) => status.isGranted);
  }

  // 블루투스 연결
  Future<void> _connectToDevice() async {
    bool permissionGranted = await _requestBluetoothPermissions();
    if (!permissionGranted) {
      setState(() {
        connectionStatus = "권한 거부됨";
      });
      _showAlert("권한 오류", "블루투스 권한이 필요합니다.");
      return;
    }

    setState(() {
      connectionStatus = "연결 중...";
    });

    try {
      BluetoothConnection connectionResult =
      await BluetoothConnection.toAddress(targetAddress);
      setState(() {
        connection = connectionResult;
        connectionStatus = connection!.isConnected ? "연결 성공" : "연결 실패";
      });
    } catch (e) {
      setState(() {
        connectionStatus = "연결 실패";
      });
      print('Error: $e');
    }
  }

  // 값 전송
  void _sendValue() {
    if (connection == null || !connection!.isConnected) {
      _showAlert("연결 오류", "블루투스가 연결되지 않았습니다.");
      return;
    }

    final value = valueController.text;
    if (int.tryParse(value) == null || int.parse(value) < 2 || int.parse(value) > 6) {
      _showAlert("잘못된 값", "2에서 6 사이의 값을 입력하세요.");
      return;
    }

    connection!.output.add(Uint8List.fromList(value.codeUnits));
    connection!.output.allSent.then((_) {
      _showAlert("전송 성공", "값이 성공적으로 전송되었습니다.");
    }).catchError((e) {
      _showAlert("전송 실패", "값 전송 중 문제가 발생했습니다.");
    });
  }

  // 경고창 표시
  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = MediaQuery.of(context).size.height * 0.08;
    final double buttonWidth = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '인원수 입력',
          style: TextStyle(
            fontFamily: 'Cafe24Ssurround',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey, // AppBar 배경색 변경
        elevation: 0, // AppBar 그림자 제거 (선택 사항)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 연결 상태 텍스트
            Container(
              alignment: Alignment.center,
              width: buttonWidth, // 버튼과 동일한 가로 크기
              child: Text(
                "상태: $connectionStatus",
                style: TextStyle(
                  fontSize: 24, // 텍스트 크기 증가
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            // 연결 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                fixedSize: Size(buttonWidth, buttonHeight),
              ),
              onPressed: _connectToDevice,
              child: Text(
                '연결',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            // 값 입력 필드
            SizedBox(
              width: buttonWidth, // AppBar 그림자 제거 (선택 사항)
              height: buttonHeight,
              child: TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "값 입력 (2-6)",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            SizedBox(height: 20),
            // 전송 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                fixedSize: Size(buttonWidth, buttonHeight),
              ),
              onPressed: _sendValue,
              child: Text(
                '전송',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
