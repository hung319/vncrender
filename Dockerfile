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
RUN x11vnc -storepasswd "admin123" /home/vncuser/.vnc/passwd
RUN chown -R vncuser:vncuser /home/vncuser/.vnc

# Cấu hình noVNC (web VNC client)
COPY novnc /home/vncuser/novnc
RUN chown -R vncuser:vncuser /home/vncuser/novnc

# Cấu hình môi trường desktop (tùy chọn)
RUN apt-get install -y \
    xfce4 \
    xfce4-terminal \
    && rm -rf /var/lib/apt/lists/*

# Cấu hình khởi động
USER vncuser
CMD /usr/bin/vncserver -geometry 1280x800 :1 && \
    /usr/bin/websockify --web /home/vncuser/novnc 6080 localhost:5901
