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


## Домашнее задание №6(cloud-testapp)

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
```

## Домашнее задание №7(packer-base)
Создан базовый образ reddit-base на основании шаблона Ubuntu16.json
Указанный шаблон настроен на работу с переменными, описанными в файле variables.json
В целях безопасности, указанный шаблон добавлен в файл .gitignore. В репозиторий добавлена его копия variables.json.example
Добавлены параметры для  базового образа:
 - Описание
 - Размер диска
 - тип диска
 - тег
 
Указанный шаблон валидирован с помощью команды
```
packer validate -var-file variables.json ./ubuntu16.json
```
Образ собран с помощью команды
```
packer build -var-file variables.json ./ubuntu16.json
```

На основании  шаблона immutable.json создан образ reddit-full-1548324659, в котором сделан  bake приложения reddit. Добавлен старт приложения с помощью systemd.
Также в папку /config-scripts добавлен скрипт create-reddit-vm.sh с возможностью запуска инстанса с помощью команды gcloud.

## Домашнее задание №8(terraform-1)
Выполнено развертывание инстанса на основании образа reddit-base  с помощью инструмента Terraform.
Конфигурационные файлы параметризованы с помощью переменных

### Задание со *
- В метаданных проекта дополнительно объявлен appuser1 с помощью команды
  ```
  metadata {
     ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}"
  }
  ```
- Для множественного объявления нескольких юзеров используется конструкция
  ```
  resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}appuser3:${file(var.public_key_path)}"
  }
  ```
- В web-интерфейсе GCP добавлен ключ пользователя appuser_web и применен terraform apply. В результате вновь добавленный ключ appuser_web удален, так как он не объявлен в конфигурации terraform, таким образом сохранена идемпотентность проекта.

### Задание с **
- Создан файл lb.tf в котором описано создание HTTP-балансировщика с помощью методов google_compute_forwarding_rule и google_compute_target_pool.
Добавлен вывод ip-адреса балансировщика через переменную app_external_ip_lb





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


## Домашнее задание №6(cloud-testapp)

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
```

## Домашнее задание №7(packer-base)
Создан базовый образ reddit-base на основании шаблона Ubuntu16.json
Указанный шаблон настроен на работу с переменными, описанными в файле variables.json
В целях безопасности, указанный шаблон добавлен в файл .gitignore. В репозиторий добавлена его копия variables.json.example
Добавлены параметры для  базового образа:
 - Описание
 - Размер диска
 - тип диска
 - тег
 
Указанный шаблон валидирован с помощью команды
```
packer validate -var-file variables.json ./ubuntu16.json
```
Образ собран с помощью команды
```
packer build -var-file variables.json ./ubuntu16.json
```

На основании  шаблона immutable.json создан образ reddit-full-1548324659, в котором сделан  bake приложения reddit. Добавлен старт приложения с помощью systemd.
Также в папку /config-scripts добавлен скрипт create-reddit-vm.sh с возможностью запуска инстанса с помощью команды gcloud.

## Домашнее задание №8(terraform-1)
Выполнено развертывание инстанса на основании образа reddit-base  с помощью инструмента Terraform.
Конфигурационные файлы параметризованы с помощью переменных

### Задание со *
- В метаданных проекта дополнительно объявлен appuser1 с помощью команды
  ```
  metadata {
     ssh-keys = "appuser:${file(var.public_key_path)}appuser1:${file(var.public_key_path)}"
  }
  ```
- Для множественного объявления нескольких юзеров используется конструкция
  ```
  resource "google_compute_project_metadata_item" "default" {
  key   = "ssh-keys"
  value = "appuser1:${file(var.public_key_path)}appuser2:${file(var.public_key_path)}appuser3:${file(var.public_key_path)}"
  }
  ```
- В web-интерфейсе GCP добавлен ключ пользователя appuser_web и применен terraform apply. В результате вновь добавленный ключ appuser_web удален, так как он не объявлен в конфигурации terraform

### Задание с **
- Создан файл lb.tf в котором описано создание HTTP-балансировщика с помощью методов google_compute_forwarding_rule и google_compute_target_pool.
Добавлен вывод ip-адреса балансировщика через переменную app_external_ip_lb
- В файл main.tf добавлен еще один resource reddit-app2, оба ресурса добавлены в балансировщик. При этом, при остановке приложения на одном из инстансов, приложение остается доступно по внешнему адресу за счет работы приложения на втором инстансе. Однако, при такой кофигурации, интсансы содержат разные экземпляры БД и не соблюдается принцип консистентности, т.е на одном инстансе будут храниться данные, отличные от данных на другом инстансе.
- Добавлено создание инстанса reddit-app2 с помощью директивы и перемнной count.





