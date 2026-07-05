FROM python:3.10-alpine

ENV PORT=3000
ENV AUTO_ACCESS=true
WORKDIR /app

COPY . .

EXPOSE 8080 3000 22

RUN apk update && apk --no-cache add openssl openssh bash curl iproute2 btop tmux &&\
    ssh-keygen -A && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "root:passw0rd" | chpasswd && \
    chmod +x app.py &&\
    pip install -r requirements.txt
    
CMD ["/bin/sh", "-c", "/usr/sbin/sshd && echo 'Starting...' && AUTO_ACCESS=true python3 app.py "]
