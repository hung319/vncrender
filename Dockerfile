FROM ubuntu:latest

# Cài đặt các gói cần thiết
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    x11vnc \
    xvfb \
    tigervnc-standalone-server \
    xfonts-base \
    && rm -rf /var/lib/apt/lists/*

# Tạo người dùng vncuser và đặt mật khẩu VNC
ARG VNC_PASSWORD=your_strong_password
RUN useradd -ms /bin/bash vncuser \
    && mkdir /home/vncuser/.vnc \
    && x11vnc -storepasswd "${VNC_PASSWORD}" /home/vncuser/.vnc/passwd \
    && chown -R vncuser:vncuser /home/vncuser/.vnc

# Khai báo cổng cho VNC
EXPOSE 5901

# Cài đặt môi trường desktop (tùy chọn)
# RUN apt-get install -y xfce4 xfce4-terminal

# Khởi động VNC khi container chạy
USER vncuser
CMD vncserver :1 -geometry 1280x800 -SecurityTypes None -AlwaysShared -localhost
