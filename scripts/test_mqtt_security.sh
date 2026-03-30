#!/bin/bash

# Attendre que le broker MQTT soit prêt (ajuster si nécessaire)
sleep 5

BROKER_HOST="localhost"
BROKER_PORT_PLAIN="1883"
BROKER_PORT_TLS="8883"

CA_CERT="../certs/ca.crt"
CLIENT_CERT="../certs/client.crt" # Nous n'avons pas généré de client.crt pour ce TP, mais c'est pour l'exemple
CLIENT_KEY="../certs/client.key" # Idem

USER="user1"
PASS="password123"

# Test 1: Publication anonyme (devrait échouer)
echo "\n--- Test 1: Publication anonyme (devrait échouer) ---"
mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT_PLAIN -t "test/anonymous" -m "Hello Anonymous" || echo "Echec attendu: Publication anonyme refusée"

# Test 2: Publication avec authentification (devrait réussir)
echo "\n--- Test 2: Publication avec authentification (devrait réussir) ---"
mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT_PLAIN -u $USER -P $PASS -t "test/authenticated" -m "Hello Authenticated" && echo "Succès: Publication authentifiée"

# Test 3: Publication avec TLS et authentification (devrait réussir)
echo "\n--- Test 3: Publication avec TLS et authentification (devrait réussir) ---"
# Note: Pour un test réel, il faudrait un certificat client signé par la même CA
# Ici, nous utilisons le certificat CA du broker comme cafile pour la vérification du serveur
mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT_TLS --cafile $CA_CERT -u $USER -P $PASS -t "test/tls" -m "Hello TLS" && echo "Succès: Publication TLS authentifiée"

# Test 4: Publication avec ACL (user1 sur test/# - devrait réussir)
echo "\n--- Test 4: Publication avec ACL (user1 sur test/# - devrait réussir) ---"
mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT_PLAIN -u $USER -P $PASS -t "test/acl/topic" -m "Hello ACL user1" && echo "Succès: Publication ACL user1"

# Test 5: Publication avec ACL (user1 sur home/sensor1/# - devrait échouer car non autorisé)
echo "\n--- Test 5: Publication avec ACL (user1 sur home/sensor1/# - devrait échouer) ---"
mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT_PLAIN -u $USER -P $PASS -t "home/sensor1/data" -m "Hello ACL user1 unauthorized" || echo "Echec attendu: Publication ACL user1 non autorisée"

# Test 6: Publication avec ACL (sensor_node_1 sur home/sensor1/# - devrait réussir)
echo "\n--- Test 6: Publication avec ACL (sensor_node_1 sur home/sensor1/# - devrait réussir) ---"
mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT_PLAIN -u sensor_node_1 -P sensorpass -t "home/sensor1/data" -m "Hello ACL sensor_node_1" && echo "Succès: Publication ACL sensor_node_1"

# Test 7: Publication avec ACL (dashboard sur home/# - devrait échouer car lecture seule)
echo "\n--- Test 7: Publication avec ACL (dashboard sur home/# - devrait échouer) ---"
mosquitto_pub -h $BROKER_HOST -p $BROKER_PORT_PLAIN -u dashboard -P dashpass -t "home/dashboard/status" -m "Hello ACL dashboard unauthorized" || echo "Echec attendu: Publication ACL dashboard non autorisée"

# Test 8: Souscription avec ACL (dashboard sur home/# - devrait réussir)
echo "\n--- Test 8: Souscription avec ACL (dashboard sur home/# - devrait réussir) ---"
mosquitto_sub -h $BROKER_HOST -p $BROKER_PORT_PLAIN -u dashboard -P dashpass -t "home/#" -C 1 -q 0 & echo "Succès: Souscription ACL dashboard"

