#!/bin/bash

echo "📱 Đang cài Android..."

# Cập nhật SDK
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-30" "emulator" "system-images;android-30;google_apis;x86_64"

# Tạo máy ảo
echo no | avdmanager create avd -n Phone -k "system-images;android-30;google_apis;x86_64" -d "pixel_4"

# Cài VNC
sudo apt update
sudo apt install -y tigervnc-standalone-server x11vnc novnc websockify xvfb

# Export PATH
export ANDROID_HOME=/home/vscode/android-sdk
export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin

# Tạo màn hình ảo
Xvfb :99 -screen 0 1024x768x24 &
export DISPLAY=:99

# Chạy emulator
emulator -avd Phone -no-window -no-audio -gpu swiftshader_indirect -memory 2048 -no-snapshot &

echo "⏳ Đang khởi động (mất 2 phút)..."
sleep 120

# Khởi động VNC
x11vnc -display :99 -forever -shared -passwd 123456 &

# Khởi động Web VNC
websockify --web /usr/share/novnc 6080 localhost:5900 &

echo ""
echo "✅ Android đã sẵn sàng!"
echo "🔑 Mật khẩu: 123456"
echo "🌐 Mở port 6080 để xem"
