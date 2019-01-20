# inkdev_infra
Добавлено домашнее задание №5
bastion_IP = 104.155.57.87
someinternalhost_IP = 10.132.0.3

Подключение к someinternalhost в одну команду:

В файле ~/.ssh/config создаем запись вида
```
Host bastion
HostName 104.155.57.87
ForwardAgent yes
User appuser
IdentityFile ~/.ssh/appuser
```

Подключение в одну команду
```
ssh -t bastion ssh 10.132.0.3
```

Чтобы подключиться к удаленному хосту напрямую, создаем alias и прописываем ему опцию ProxyCommand  в файле ~/.ssh/config
```
Host someinternalhost
Hostname 10.132.0.3
ProxyCommand ssh bastion -W %h:%p
User appuser
```

Проверяем из консоли
```
ssh someinternalhost
```
Подключение к pritunl осуществляем с помощью клиента OpenVPNи настроек для него:
```
openvpn --config cloud-bastion.ovpn
```

Доступ к Web Pritunl с помощью let's encrypt сертификата
https://104.155.57.87.xip.io


##Домашнее задание №6(cloud-testapp)

Данные для подключения:
testapp_IP = 35.247.17.144
testapp_port = 9292

Добавлена команда по автоматическому созданию и развертыванию приложения с помощью startup_script
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=startup_script.sh
```

Добавлена команда для создания правила default-puma-server:
```
gcloud compute firewall-rules create default-puma-server\
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:9292 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=puma-server \
  --description="Allow incoming traffic for puma-server" 




