

# WampusWorld

Wampus World est un jeu où un explorateur doit trouver le trésor puis de se diriger vers la sortie. 
Il devra éviter les trous et un monstre, le wanpus, qui lui bloquent la route.

![Wampus World](http://i.imgur.com/3Z2OYHY.png)

# Comment lancer le jeu

Pour lancer le jeu, rien de plus simple. 
Téléchargez SWI-Prolog : http://www.swi-prolog.org/Download.html

Puis lancez swi-prolog avec le fichier Wampus.pl.
Puis exécutez la commande 

    start.

# L'interface

![Une case](http://i.imgur.com/LVH0gSk.png?1)

Nous pouvons séparer une case en 2.
La moitié du haut représente l'état réel de la case.
Alors que la moitié du bas représente ce que sait l'explorateur sur cette case.

En haut à gauche nous avons l'élément présent sur la case:

 - J (En cyan): Le joueur qui se balade sur la carte
 - A (En orange): L'ascenseur qui représente la sortie du labyrinthe
 - T (En jaune): Le trésor, à trouver avant de sortir
 - M (En vert): Le monstre, le Wampus
 - T (En marron): Un trou
 - M (En noir): Un mur

En haut à droite, nous avons les percepts qui donnent des indices sur les cases voisines: 

 - S (en rouge): *Souffle* - Il y a au moins un trou dans une case voisine
 - B (en violet): *Bruit* - Il y a l'ascenseur sur une case voisine
 - O (en bleu): *Odeur* - Il y a un monstre sur une case voisine
 - B (en jaune): *Bling* - Il y a un trésor sur une case voisine

En bas à gauche, nous avons les déductions du joueur:

 - ! (En rouge): Il est certain qu'il n'y a pas cet élément sur cette case
 - ? (En orange): Il a un risque qu'il y ait cet élément sur cette case
 - ~ (En gris): Il n'a aucun indice pour cet élément sur cette case
 - . (En la couleur de l'élément): Il est certain que cet élément est sur cette case
 
Les éléments:
 
 - M : Le Monstre
 - T : Un trou
 - A : L'ascenseur
 -  T : Le trésor

Puis pour finir, en bas à droite nous avons l'état de la case:

 - V (En beige): La case a déjà été visitée
 - S (En vert): La case est considérée comme sûre par le Joueur
 
------ 
2016 - Corentin Vanson
