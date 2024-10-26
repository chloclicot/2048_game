# 2048 Projet développement mobile
*par Chloé Varin*

## Principe

Le jeu 2048 est un jeu de réflexion dans lequel le joueur doit déplacer des tuiles sur une grille pour les fusionner entre elles et créer une tuile portant le nombre 2048. Le jeu se joue sur une grille de 4x4 cases, 
et le joueur peut déplacer les tuiles dans quatre directions : haut, bas, gauche et droite. À chaque mouvement, une nouvelle tuile apparaît sur la grille, et le joueur doit continuer à déplacer les tuiles pour les fusionner entre 
elles et obtenir le nombre 2048.
(Ici on a décidé de ne pas limiter le jeu à 2048, le joueur peut continuer à jouer après avoir atteint ce score)

## Fonctionnalités

### Conservation du High Score via les shared preferences
Le joueur qui a quitté l'appli peut retrouver son meilleur score.

## Bugs observés

Il reste un bug qui n'empêche pas le jeu de fonctionner mais qui peut être gênant pour le joueur. En effet, parfois lorsque le joueur a plusieurs tuiles fusionnable sur une lignes,
imaginons en ligne 8 _ _ 4 4 la fusion des deux 4 va se suivre automatiquement de la fusion avec le 8 pour récupérer 16 _ _ _ _ . Cela empêche le joueur 
de faire un mouvement dans une autre direction pour utiliser les deux 8.

## Améliorations possibles
