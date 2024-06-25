FROM ubuntu:latest

# Cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    x11vnc \
    xvfb \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    dbus-x11 \
    xfonts-base \
    && rm -rf /var/lib/apt/lists/*

# Tạo người dùng mới để chạy VNC
RUN useradd -m -s /bin/bash vncuser

# Cấu hình VNC
RUN mkdir -p /home/vncuser/.vnc
# Đặt mật khẩu (thay đổi 'your_strong_password' thành mật khẩu của bạn)
ARG VNC_PASSWORD=11042006
RUN x11vnc -storepasswd "${VNC_PASSWORD}" /home/vncuser/.vnc/passwd
RUN chown -R vncuser:vncuser /home/vncuser/.vnc

# Cấu hình noVNC (web VNC client)
COPY novnc /home/vncuser/novnc
RUN chown -R vncuser:vncuser /home/vncuser/novnc

# Khai báo cổng noVNC
EXPOSE 6080

# Cấu hình khởi động
USER vncuser
# Cổng noVNC
ARG NOVNC_PORT=6080
ENV NOVNC_PORT $NOVNC_PORT
CMD /usr/bin/vncserver -geometry 1280x800 :1 && \
    /usr/bin/websockify --web /home/vncuser/novnc $NOVNC_PORT localhost:5901
