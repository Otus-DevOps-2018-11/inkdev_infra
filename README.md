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

Полезные команды
```
terraform init #инициализация окружения
terraform plan №планирование изменений
terraform apply -auto-approve=true #применение с ключом подтверждения
terraform show #посмотреть state
terraform taint google_compute_instance.app #применение к существующему инстансу
terraform destroy #удаление окружения
```

## Домашнее задание №9(terraform-2)

- Разбили монолитное приложение на отдельные модули app, db, vpc:
   - Модуль app для деплоя приложения puma-server
   - Модуль db для деплоя БД
   - Модуль VPC с правилом доступа по ssh

- Создали окружения prod и stage
- Создали два хранилища bucket в Google Cloud Storage

### Полезные команды
```
terraform import
terraform get #прочитать модули
```
Сборка образов для app и db packer
```
packer build -var-file variables.json db.json
packer build -var-file variables.json app.json
```
Дебаг packer в терминал
```
PACKER_LOG=1 packer build -var-file variables.json db.json
```
В процессе создания образа packer необходимо не забывать о том, что скрипты провижионеров должны работать по ssh. Cоответственно, без правила фаерволла для пакера, образы собираться не будут.

### Задание со *
Настройка хранения стейт файла в бакете GCP
- В директории terraform создаем файл storage-bucket.tf с описанием создания двух бакетов. Применяем через terraform init и terraform apply
- В окружении  stage создаем файл backend.tf c описанем хранения stage-файла на GCS. Делаем terraform init и соглашаемся с предложением хранить .tfstate файл в указанном бакете GCP. Теперь terrafrom будет писать состояние в этот файл.
- Копируем конфигурационные файлы в папку tftest, убеждаемся, что отсутствует файл .tfstate, хранящийся в бакете, запускаем и видим что terraform успешно применил конфигурацию вне зависимости от расположения конф. файлов 
- При попытке запустить два экземпляра terraform одновременно, получаем ошибку:
```
Error: Error locking state: Error acquiring the state lock: writing "gs://inkdev-bucket1/terraform/state/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
Lock Info:
  ID:        1550135439289646
  Path:      gs://inkdev-bucket1/terraform/state/default.tflock
  Operation: OperationTypeApply
  Who:       alexis@inkdev
  Version:   0.11.9
  Created:   2019-02-14 09:10:39.178194674 +0000 UTC
  Info:


Terraform acquires a state lock to protect the state from being written
by multiple users at the same time. Please resolve the issue above and try
again. For most commands, you can disable locking with the "-lock=false"
flag, but this is not recommended.
```
### Задание со **
Приложение разнесено по разным нодам:puma на reddit-app и БД на reddit-db
- В модули app и db добавлены необходимые provisioner'ы для работы приложения.
- Подстановка адреса БД осущетвляется через переменную db_local_ip. Указанную переменную берем из внутреннего адреса инстанса reddit-db и подставлеяем с помощью переменной окружения DATABASE_URL в файл tmp/puma.env. Таким образом, приложение reddit знает на каком инстансе запущена БД.
- В модуле db адрес листнера заменен с адреса localhost 127.0.0.1 на 0.0.0.0 для возможности подключения со всех ip-адресов.
- Проверено подключение







