# Captures d'Écran 

Cette section présente des descriptions textuelles des captures d'écran qui auraient été prises lors de la réalisation des TP 2 et 3. Elles illustrent les étapes clés et les résultats attendus.

## 1. Installation et Configuration de Mosquitto

### Capture 1.1: Installation des paquets
```text
ubuntu@sandbox:~ $ sudo apt update && sudo apt upgrade -y
...
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.

ubuntu@sandbox:~ $ sudo apt install -y curl gnupg2 ca-certificates software-properties-common lsb-release docker.io docker-compose mosquitto-clients net-tools
...
Setting up mosquitto (2.0.11-1ubuntu1.2) ...
Setting up mosquitto-clients (2.0.11-1ubuntu1.2) ...
```
*Description :* Cette capture montrerait la sortie de la console après l'exécution des commandes d'installation des prérequis et de Mosquitto, confirmant que tous les paquets ont été installés avec succès.

### Capture 1.2: Test initial de Mosquitto
```text
ubuntu@sandbox:~ $ mosquitto_sub -h localhost -t "test/topic" -v &
[1] 12345
ubuntu@sandbox:~ $ mosquitto_pub -h localhost -t "test/topic" -m "Hello MQTT"
test/topic Hello MQTT
```
*Description :* Cette capture illustrerait le succès de la publication et de la souscription à un topic MQTT sur le broker Mosquitto fraîchement installé, démontrant son bon fonctionnement de base.

## 2. Sécurisation (Authentification, TLS, ACL)

### Capture 2.1: Création du fichier de mot de passe
```text
ubuntu@sandbox:~/IoT/TP2-3/config $ mosquitto_passwd -b passwd user1 password123
ubuntu@sandbox:~/IoT/TP2-3/config $ cat passwd
user1:$7$C0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
```
*Description :* Cette capture montrerait la création du fichier `passwd` avec l'utilisateur `user1` et son mot de passe haché, ainsi que le contenu du fichier.

### Capture 2.2: Génération des certificats TLS
```text
ubuntu@sandbox:~/IoT/TP2-3/certs $ openssl genrsa -out ca.key 2048
...
ubuntu@sandbox:~/IoT/TP2-3/certs $ openssl req -new -x509 -key ca.key -out ca.crt -days 3650 -subj "/C=FR/ST=Ile-de-France/L=Paris/O=IB/OU=IB-Data/CN=MQTT-CA-Docker"
...
```
*Description :* Cette capture présenterait la sortie des commandes OpenSSL utilisées pour générer la clé privée et le certificat de l'autorité de certification (CA), ainsi que la clé privée et la demande de signature de certificat (CSR) pour le broker.

### Capture 2.3: Contenu du fichier ACL
```text
ubuntu@sandbox:~/IoT/TP2-3/config $ cat aclfile
user user1
topic readwrite test/#
topic read maison/temperature

user sensor_node_1
topic readwrite home/sensor1/#

user dashboard
topic read home/#

topic deny $SYS/#
```
*Description :* Cette capture afficherait le contenu du fichier `aclfile`, détaillant les règles d'accès pour les différents utilisateurs et topics.

## 3. Docker Compose

### Capture 3.1: Fichier docker-compose.yml
```yaml
version: '3.8'
services:
  mqtt-broker:
    image: eclipse-mosquitto:2.0
    ports:
      - "1883:1883"
      - "8883:8883"
      - "9001:9001"
    volumes:
      - ./config/mosquitto.conf:/mosquitto/config/mosquitto.conf:ro
      - ./config/passwd:/mosquitto/config/passwd:ro
      - ./config/aclfile:/mosquitto/config/aclfile:ro
      - ./certs/ca.crt:/mosquitto/config/certs/ca.crt:ro
      - ./certs/server.crt:/mosquitto/config/certs/server.crt:ro
      - ./certs/server.key:/mosquitto/config/certs/server.key:ro
      - mosquitto_data:/mosquitto/data
    restart: unless-stopped

volumes:
  mosquitto_data:
```
*Description :* Cette capture montrerait le contenu du fichier `docker-compose.yml` configuré pour lancer le broker Mosquitto avec les volumes nécessaires pour les configurations de sécurité.

### Capture 3.2: Démarrage des services Docker Compose
```text
ubuntu@sandbox:~/IoT/TP2-3 $ docker compose up -d
[+] Running 1/1
 ✔ Container tp2-3-mqtt-broker-1  Started
```
*Description :* Cette capture illustrerait la sortie de la commande `docker compose up -d`, confirmant le démarrage réussi du conteneur Mosquitto.

## 4. Tests de Sécurité

### Capture 4.1: Script de test d'authentification et ACL
```bash
#!/bin/bash
...
# Test 1: Publication anonyme (devrait échouer)
Echec attendu: Publication anonyme refusée

# Test 2: Publication avec authentification (devrait réussir)
Succès: Publication authentifiée

# Test 4: Publication avec ACL (user1 sur test/# - devrait réussir)
Succès: Publication ACL user1

# Test 5: Publication avec ACL (user1 sur home/sensor1/# - devrait échouer)
Echec attendu: Publication ACL user1 non autorisée
```
*Description :* Cette capture montrerait des extraits de la sortie du script `test_mqtt_security.sh`, validant le bon fonctionnement de l'authentification et des règles ACL.
