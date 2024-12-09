//앱을 통해 값이 제대로 보내지는지 확인하기 위한 라즈베리파이 C언어 코드

#include <stdio.h>
#include <unistd.h>
#include <wiringPi.h>
#include <wiringSerial.h>

#define BAUD_RATE 115200
static const char* UART1_DEV = "/dev/ttyAMA1"; // RPi5: UART1 장치 파일
int people_number = 0; // 전역 변수
int card_number = 0;   // 전역 변수

unsigned char serialRead(const int fd); // 1Byte 데이터를 수신하는 함수

// 1Byte 데이터를 수신하는 함수
unsigned char serialRead(const int fd) {
    unsigned char x;
    if (read(fd, &x, 1) != 1) // 1바이트 읽기 실패 시 -1 반환
        return -1;
    return x;
}

int main() {
    int fd_serial;
    unsigned char dat;
    unsigned char buffer[20]; // 데이터를 저장할 버퍼
    int buffer_idx = 0;

    // WiringPi 초기화
    if (wiringPiSetupGpio() < 0) {
        printf("WiringPi 초기화 실패\n");
        return 1;
    }

    // UART1 포트 열기
    if ((fd_serial = serialOpen(UART1_DEV, BAUD_RATE)) < 0) {
        printf("UART 포트를 열 수 없습니다: %s\n", UART1_DEV);
        return 1;
    }

    while (1) {
        if (serialDataAvail(fd_serial)) { // 읽을 데이터가 있는 경우
            dat = serialRead(fd_serial);  // 1바이트 데이터를 읽음
            
            // 데이터 수신 및 버퍼에 저장
            if (dat != '\n' && buffer_idx < sizeof(buffer) - 1) {
                buffer[buffer_idx++] = dat;
            } else {
                buffer[buffer_idx] = '\0'; // 문자열 종료
                buffer_idx = 0;

                // 데이터 포맷 파싱 (예: "P4C2")
                if (buffer[0] == 'P' && buffer[2] == 'C') {
                    people_number = buffer[1] - '0'; // P 뒤 숫자
                    card_number = buffer[3] - '0';   // C 뒤 숫자
                    printf("People number: %d, Card number: %d\n", people_number, card_number);
                } else {
                    printf("무시된 데이터: %s\n", buffer);
                }
            }
        }
        delay(10); // 짧은 대기 (10ms)
    }
}
// gcc –o bluetooth_server bluetooth_server.c –lwiringPi
