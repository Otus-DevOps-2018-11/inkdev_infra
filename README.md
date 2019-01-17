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





