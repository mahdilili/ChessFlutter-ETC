# CHESS MOBILE - ETC
## Nom & prénom : Mahdi Ellili
Lien vers le repos git de l'application : https://github.com/mahdilili/ChessFlutter-ETC

## Credentials pour les utilisateurs de l'application
##### user: user@chess.ca  / password :Toto123!

##### admin : admin@chess.ca  / password :Toto123!

## Stratégie de déploiement

Cette application de jeu d'échecs répond aux exigences strictes des deux stores, garantissant ainsi une expérience utilisateur de qualité et la conformité avec les règles établies.
### Repect des droits d'auteurs et licences:
Tous les éléments graphiques et autres contenus de Chess Mobile respectent les droits d'auteur
et les licences appropriés.
### Contenu approprié:
Le contenu du jeu est approprié pour tous les utilisateurs évitant tout éléments inapproprié, violent ou
harassant et aucune publicité.
### Protection de la vie privée:
La protection de la vie privée des utilisateurs est au cœur du développement de Chess Mobile. Aucun comportement abusif évident, tel que le phishing ou l'utilisation des données personnelles. Ce jeu ne sauvegarde
aucune donnée personnelles de ses utilisateurs et surtout les données personnelles des enfants.
## Pour un déploiement sur Android : 
1) Ajout d'une icone pour l'application
2) Activation du material components et ajout des deux thèmes. 
2) Signature de l'application avec un certificat numérique et créer un keystore de téléchargement.
3) Ajouter une référence du keystore à partir de l'application
4) Ajouter les informations du keystore dans le fichier de propriétés.
5) Réduction du code avec R8 et activer le support multidex
6) Révision du fichier AndroidManifest.xml  et la configuration du fichier build.gradle
7) Complation de l'application pour la publication (APK)
8) Création du bundle d'application
9) Installation de l'apk sur un appareil
10) Publication sur le Google Play Store

## Matrice intervenants/tâches :


| Intervenant/Tâche                | Créer un profil joueur | Choisir un skin | Consulter la liste des joueurs | Consulter les statistiques d'un joueur | Créer et commencer une partie |
|-----------------------------------|------------------------|-----------------|---------------------------------|-----------------------------------------|------------------|
| Utilisateur                       | Au moins une fois. &nbsp; Durée d'environ une minute.&nbsp;Taux d'erreur très bas. Difficulté basse.                    | Indisponible               | Au moins une fois/sem. Durée d'environ une minute. Taux d'erreurs est très bas. Difficulté basse.                               |           Au moins une fois/jour. Durée d'environ 40 secondes. Difficulté très basse. Taux d'erreurs bas.                             |Au moins une fois par jour. Durée d'environ 15 minutes selon le joueur. Difficulté élevé. Taux d'erreurs moyen.      |            |
| Administrateur                    | Une fois ou plus. Durée d'une minute. Taux d'erreurs très bas. Difficulté basse.                      | Au moins une fois (au besoin). Durée d'environ une minute. Taux d'erreurs très mineur. Aucune difficulté               | Au moins une fois par mois. Durée d'environ 2 minutes. Taux d'erreurs très bas. Difficulté basse aussi.                               | Au moins une fois par mois. Durée d'environ 1 minute. Difficulté basse. Taux d'erreurs très bas.                                       | Au moins une fois par 3 mois (lors des tests). Durée d'environ 20 minutes. Difficulté moyenne. Taux d'erreurs moyen                |



