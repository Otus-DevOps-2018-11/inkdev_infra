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

# Домашнее задание №10(ansible-1)
Полезные команды
Проверяем версию python
```
python --version
```
Установка стабильной версии ansible на Debian stretch
```
sudo echo `deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main` >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo apt-get update
sudo apt-get install ansible
```
Проверка версии ansible

```
ansible --version
ansible 2.7.8
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/alexis/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.13 (default, Sep 26 2018, 18:42:22) [GCC 6.3.0 20170516]
```

- Подняли инфраструктуру из тестового окружения stage
- Создали inventory-файл, в котором указали хост appserver для подключения. Протестировали с помощью модуля ping
```
ansible appserver -i ./inventory -m ping
```
- Аналогично сделали для хоста dbserver
```
ansible dbserver -i inventory -m ping
```
- Указали credentials для подключения к инстансам в файл ansible.cfg. Поправили inventory-файл.
- С помощью модуля command првоерили работоспособность
```
~/inkdev_infra/ansible$ ansible dbserver -m command -a uptime
dbserver | CHANGED | rc=0 >>
 08:27:38 up 56 min,  1 user,  load average: 0.00, 0.00, 0.00
```
- Добавили возможность работы с группой хостов
```
ansible app -m ping
appserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
- Использовали файл inventory.yml для описания подключения хосстов на языке YAML
```
app:
  hosts:
    appserver:
      ansible_host: XXX.XXX.XXX.XXX

db:
  hosts:
    dbserver:
        ansible_host: YYY.YYY.YYY.YYY
```
- С помощью ansible проверили установку приложений ruby и bundler
```
ansible app -m shell -a 'ruby -v; bundler -v' -i inventory.yml
```
- С помощью ansible проверили работу mongod
```
ansible db -m command -a 'systemctl status mongod' -i inventory.yml

ansible db -m command -a 'systemctl status mongod' -i inventory.yml
dbserver | CHANGED | rc=0 >>
● mongod.service - High-performance, schema-free document-oriented database
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Tue 2019-02-26 07:31:51 UTC; 1h 33min ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 1957 (mongod)
    Tasks: 20
   Memory: 31.4M
      CPU: 30.126s
   CGroup: /system.slice/mongod.service
           └─1957 /usr/bin/mongod --quiet --config /etc/mongod.conf

Feb 26 07:31:51 reddit-db systemd[1]: Stopped High-performance, schema-free document-oriented database.
Feb 26 07:31:51 reddit-db systemd[1]: Started High-performance, schema-free document-oriented database.
```
Или через модуль systemd
```
ansible db -m systemd -a name=mongod -i inventory.yml
```
Или через модуль service, в случае системы без systemd
```
ansible db -m service -a name=mongod -i inventory.yml
```

- Применили установку приложения с помощью модуля git
```
ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/appuser/reddit' -i inventory.yml
```
- Создали простой playbook clone.yml и запустили на выполнение
```
ansible-playbook clone.yml -i inventory.yml
#Вывод
PLAY [Clone] **************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [appserver]

TASK [Clone repo] *********************************************************************************************************************************************************************************************
ok: [appserver]

PLAY RECAP ****************************************************************************************************************************************************************************************************
appserver                  : ok=2    changed=0    unreachable=0    failed=0

```
Удалили приложение reddit с помощью команды ansible app -m command -a 'rm -rf ~/reddit' и запустили playbook еще раз, получили результат
```
PLAY [Clone] **************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************************************************************************************
ok: [appserver]

TASK [Clone repo] *********************************************************************************************************************************************************************************************
changed: [appserver]

PLAY RECAP ****************************************************************************************************************************************************************************************************
appserver                  : ok=2    changed=1    unreachable=0    failed=0

```
Занчение поля changed изменилось на "1", так как в предыдущем проходе playbook'а было обнаружено установленное приложение из репозитория, соотвественно,  никаких действий не производилось. Во втором проходе приложения обнаружено не было, оно было установлено и счетчик выполнения сменился на "1". Такми образом, сохранена идемпотентность проекта

### Задание со *
Для генерации динамического inventory на лету написан скрипт inventory.py , выводящий список хостов для ansible в формате json.
Вызов модуля ping:
```
ansible all -m ping -i inventory.py
appserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
dbserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

# Домашнее задание №11(ansible-2)
Полезные команды
```
ansible-playbook reddit_app.yml #Приенить плейбук
ansible-playbook reddit_app.yml --check #Тестовый прогон плейбука
ansible-playbook reddit_app.yml --check --limit db #На какую группу хостов сделать применение плейбука(берем из inventory.yml)
nsible-playbook reddit_app.yml --check --limit app --tags app-tag # Какие таски применить к указанным хостам(теги тасков из плейбука)
```
- Создали playbook reddit_app.yml для деплоя приложения reddit(для исключения лишних файлов добавим расширение *.retry в файл .gitignore)
- Создали сценарий для настройки базы mongod с помощью модуля template. Добавляем тег db-tag
```
---
- name: Configure hosts & deploy application
  hosts: all
  vars:
    mongo_bind_ip: 0.0.0.0 # Переменная задается в блоке vars
  tasks:
     - name: Change mongo config file
       become: true # <-- Выполнить задание от root
       template:
         src: templates/mongod.conf.j2 # <-- Путь до локального файла-шаблона
         dest: /etc/mongod.conf # <-- Путь на удаленном хосте
         mode: 0644 # <-- Права на файл, которые нужно установить
       tags: db-tag # <-- Список тэгов для задачи
```
- Определили переменную для листнера в блоке vars. Значение переменной порта в конфиге темплейта оставили по умолчанию
- Сделали тестовый прогон плейбука с помощью команды
```
ansible-playbook reddit_app.yml --check --limit db
```
- Добавили хендлер для рестарта mongodb при изменениии конфига
```
handlers: # <-- Добавим блок handlers и задачу
- name: restart mongod
  become: true
  service: name=mongod state=restarted
```
- Добавили таск для  копирования unit-файла на хост приложения и таск рестарта приложения через systemd
- Добавили шаблон в директории templates/db_config.j2, содержащий переменную с адресом db. Определили значение этой переменной в плейбуке
- Сделали пробный прогон и применили для группы хостов с тегом app-tag
```
ansible-playbook reddit_app.yml --check --limit app --tags app-tag
ansible-playbook reddit_app.yml --limit app --tags app-tag
```
- Установили приложение с помощью модулей git и bundle, пометили тегом deploy-tag, сделали тестовый прогон и применили
```
ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag
ansible-playbook reddit_app.yml --limit app --tags deploy-tag
```
 - Убедились в том, что приложение работает
 ```
 curl http://http://35.195.39.151:9292/
 ```
 ### Один плейбук несколько сценариев
- Создали файл rediit_app2.yml , в котором разбили предыдущий сценарий на три группы:Configure MongoDB, Configure App и Deploy. На каждый из них повесели соответствующий тег и указали необходимую группу хостов
- Проверили работоспособность

### Несколько плейбуков
- Разбили файл сценария на три новых файла: app.yml dm.yml deploy.yml
- Удалили соответствующие теги
- Создали общий плейбук site.yml, в котором сослались на три наших плейбука
- Сделали тестовый прогон и задеплоили
```
ansible-playbook site.yml --check
ansible-playbook site.yml
```
### Задание со *
Были исследованы две возможности для подключения динамического инвентори:
 - С помощью утилиты gce.py. Показался более грамоздким из-за наличия указания различных параметров, credentials итд. Плюc, утилита ориентирована только на работу с GCP
 - С помощью инструмента terraform-inventory. Показался более гибким в настройке, плюс, поддерживает других провайдеров(AWS, DO)
 Сайт проекта:https://github.com/adammck/terraform-inventory
 Процесс установки и настройки terraform-inventory
   1. Скачиваем дистрибутив для своей ОС отсюда: https://github.com/adammck/terraform-inventory/releases
   2. Для Linux распаковываем, копируем в папку /usr/bin/
   3. Утилита задействует переменную окружения TF_STATE, в которую необходимо записать путь до *.tfstate файла
   4. В общем виде команда деплоя  будет выглядеть так:
      ```
      TF_STATE=../terraform/stage/ ansible-playbook --inventory-file=/usr/bin/terraform-inventory site.yml --check
      TF_STATE=../terraform/stage/ ansible-playbook --inventory-file=/usr/bin/terraform-inventory site.yml
      ```
      где 
      ```
      --inventory-file=/usr/bin/terraform-inventory #Путь до terraform-inventory
      ```
      Если вносим переменную TF_STATE в глобальные переменные и меняем в файле ansible.cfg значение inventory на inventory = /usr/bin/terraform-inventory, то команда сокращается до
      ```
      ansible-playbook site.yml --check
      ansible-playbook site.yml
      ```
      Применяем и проверяем
      ```
      curl http://35.195.39.151:9292
  
      ```

### Провижининг в Packer
- Создали два плейбука packer_app.yml и packer_db.yml для провижининга приложений в образ packer
- Изменили секцию provisioners в файлах шаблонов app.json и db.json
- Создали правило, разрешающее подключаться по ssh снаружи на время билда образов
- Сделали ребилд образов reddit-app и reddit-db из корня репозитория, предварительно удалив старые образы
```
packer build -var-file packer/variables.json packer/db.json
packer build -var-file packer/variables.json packer/app.json
```
- На основе свежих билдов развернули тестовое окружение stage и установили с помощью плейбуков соответствующие приложения
- Проверили работоспособность

***Примечание
При билде app предупреждение, что для перечисления item теперь лучше использовать список. Тем не менее, билд проходит успешно
```
[DEPRECATION WARNING]: Invoking "apt" only once while using a loop via
    googlecompute: squash_actions is deprecated. Instead of using a loop to supply multiple items
    googlecompute: and specifying `name: "{{ item }}"`, please use `name: ['ruby-full', 'ruby-
    googlecompute: bundler', 'build-essential']` and remove the loop. This feature will be removed
    googlecompute:  in version 2.11. Deprecation warnings can be disabled by setting
    googlecompute: deprecation_warnings=False in ansible.cfg.
    googlecompute: changed: [default] => (item=[u'ruby-full', u'ruby-bundler', u'build-essential'])
```

# Домашнее задание №12(ansible-3)
Полезные команды
```
ansible-galaxy init #создать структуру роли с соответствующим форматом
```
- Разнесли плейбуки по ролям app и db
- Создали окружения stage и prod, добавили в них необходимые inventory.yml и переменные групп хостов в group_vars
- Добавили роль jdauphant.nginx в плейбук app.yml
- Прогнали с помощью --check получили ошибку
```
TASK [jdauphant.nginx : Create links for sites-enabled] ************************
failed: [appserver] (item={'value': [u'listen 80', u'server_name "reddit"', u'lo                                                                                       cation / { proxy_pass http://127.0.0.1:9292; }'], 'key': u'default'}) => {"chang                                                                                       ed": false, "item": {"key": "default", "value": ["listen 80", "server_name \"red                                                                                       dit\"", "location / { proxy_pass http://127.0.0.1:9292; }"]}, "msg": "src file d                                                                                       oes not exist, use \"force=yes\" if you really want to create the link: /etc/ngi                                                                                       nx/sites-available/default.conf", "path": "/etc/nginx/sites-enabled/default.conf                                                                                       ", "src": "/etc/nginx/sites-available/default.conf", "state": "absent"}
...ignoring
```
- При этом, при боевом прогоне , все нормально
```
PLAY RECAP ************************************************************************************************************************************************************
appserver                  : ok=27   changed=18   unreachable=0    failed=0
dbserver                   : ok=4    changed=2    unreachable=0    failed=0
```
- Убедились, что proxy pass работает нормально и приложение доступно по 80 порту

###Хранение паролей в Vault
- Создали файл vault.key со строкой ключа
- В секцию default добавили информацию о файле ключ-файла
- Зашифровали файлики credentials.yml в окружениях stage и prod 
```
ansible-vault encrypt environments/prod/credentials.yml
ansible-vault encrypt environments/stage/credentials.yml
``` 
- Расшифровка обратно
```
ansible-vault decrypt environments/prod/credentials.yml
ansible-vault decrypt environments/stage/credentials.yml
```

### Задание со *
Создаем динамический инвентори для окружений stage и prod с помощью утилиты terrafrom-inventory, использованной в предыдущей домашней работе
Для корректной работы создали symbol link c помощью команды
```
ln -s /usr/bin/terraform-inventory terraform-inventory
```
Установку плейбука осуществляем с помощью команды
```
TF_STATE=../terraform/stage ansible-playbook --inventory-file=./environments/stage/terraform-inventory playbooks/site.yml
```
 
### Задание с **
- Добавили packer validate для шаблонов
- Добавили terrafrom validate и линтер tflint для окружений stage и prod
- Добавили линтер ansible-lint для плейбуков ansible
- В README.md добавили бейдж со статусом билда ветки ansible-3
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-11/inkdev_infra.svg?branch=ansible-3)](https://travis-ci.com/Otus-DevOps-2018-11/inkdev_infra)


# Домашнее задание №13(ansible-4)
Полезные команды
```
vagrant -v #Версия Vagrant
vagrant up
vagrant box list
vagrant status #Проверка статуса запущенных VM
vagrant ssh appserver #Доступ по ssh к одной из VM
vagrant destroy -f #Удалить VM

```
- Установлен Vagrant Для локальной разработки ролей
- Доработали роли app и db (сделали провижининг) 
- Настроили тестирование ролей с помощью Molecule и Testinfra
- Написали тест к роли db для проверки использования БД на порту 27017
- В шаблонах Packer использовали Ansible роли вместо плейбуков
- Роль Ansible вынесена в отдельный дистрибутив https://github.com/inkdev/db_otus_test

### Задание со * №1
- Дополнили конфигурацию vagrant корректной работы проксирования приложения с помощью nginx
```
ansible.extra_vars = {
        "deploy_user" => "vagrant",
		    "nginx_sites" => {
          "default" => [
            "listen 80",
            "server_name 'reddit'",
            "location / { proxy_pass http://127.0.0.1:9292; }"
            ]
          }
      }
```

### Задание со * №2
- Создаем сервисный аккаунт в GCP API&Services->Enable API&Services->GCE
- Скачиваем credentials.json
- В соответствии с инструкцией настраиваем интеграцию акканута c travis и подключение к GCE
```
wget https://raw.githubusercontent.com/vitkhab/gce_test/c98d97ea79bacad23fd26106b52dee0d21144944/.travis.yml
# генерируем ключ для подключения по SSH
ssh-keygen -t rsa -f google_compute_engine -C 'travis' -q -N ''
# Должна быть предварительно подключена данная репа в тревисе
# Шифруем ключи credentials для подключения к GCE
travis encrypt GCE_SERVICE_ACCOUNT_EMAIL='ci-test@infra-179032.iam.gserviceaccount.com' --add
travis encrypt GCE_CREDENTIALS_FILE="$(pwd)/credentials.json" --add
travis encrypt GCE_PROJECT_ID='infra-179032' --add
# шифруем файлы
tar cvf secrets.tar credentials.json google_compute_engine
travis login
travis encrypt-file secrets.tar --add

# пушим и проверяем изменения
git commit -m 'Added Travis integration'
git push
```
