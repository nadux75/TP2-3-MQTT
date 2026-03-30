# TP 2 & 3 : Installation, Configuration et Sécurisation MQTT sur Ubuntu

Ce dépôt contient les fichiers de configuration, les scripts et les rapports pour les TP 2 et 3 du module MSC Cybersécurité - IoT.

## Structure du Dépôt

- `docker-compose.yml` : Fichier pour déployer Mosquitto avec Docker.
- `config/` : Dossier contenant les fichiers de configuration Mosquitto.
  - `mosquitto.conf` : Configuration principale du broker.
  - `passwd` : Fichier des mots de passe des utilisateurs.
  - `aclfile` : Fichier de contrôle d'accès par topic.
- `certs/` : Dossier contenant les clés et certificats TLS.
- `scripts/` : Dossier contenant les scripts de test.
  - `test_mqtt_security.sh` : Script pour valider l'authentification et les ACL.
- `reports/` : Dossier contenant les rapports et schémas demandés.
  - `Rapport_Vulnerabilites_MQTT.md` : Rapport détaillé sur les vulnérabilités et mesures de mitigation.
  - `Captures_Ecran_Simulees.md` : Descriptions textuelles des captures d'écran des étapes clés.
  - `architecture_auth_tls.png` : Schéma d'architecture sécurisée avec authentification et TLS.
  - `architecture_acl_mtls.png` : Schéma d'architecture sécurisée avec ACL et mTLS.

## Installation et Utilisation

### Prérequis
- Docker et Docker Compose installés sur Ubuntu.

### Démarrage du Broker
Pour démarrer le broker Mosquitto avec toutes les configurations de sécurité :
```bash
docker compose up -d
```

### Exécution des Tests
Pour valider la configuration de sécurité :
```bash
cd scripts
chmod +x test_mqtt_security.sh
./test_mqtt_security.sh
```

## Auteur
**Manus AI** pour le compte de l'utilisateur.
