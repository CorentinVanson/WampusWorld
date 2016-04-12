

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
 
Le éléments:
 
 - M : Le Monstre
 - T : Un trou
 - A : L'ascenseur
 -  T : Le trésor

Puis pour finir, en bas à droite nous avons l'état de la case:

 - V (En beige): La case a déjà été visitée
 - S (En vert): La case est considérée comme sûre par le Joueur

## Partie 2 ##

L'interface du deuxième programme change un peu. 
Le souffle est remplacé par le nombre de trou sur les cases voisines.

## Intelligence artificielle ##

Le joueur est commandé par une intelligence artificielle qui lui permet de faire des choix.

Les choix sont fait en fonction de priorités : 

 - Si le joueur a trouvé le trésor et connais l'ascenseur, il y va
 - Une case définie comme safe, où le joueur sait qu'il ne risque rien
 - Si'il a déjà visité une case avec odeur, et si il lui reste une fleche, il y va, et il tire dans une direction où le monstre est sûr d'être 
 - Si'il a déjà visité une case avec odeur, et si il lui reste une fleche, il y va, et il tire dans une direction où le monstre peut être 
 - Sinon il tente un coup risqué avec une case au hasard

Pour le déplacement, le joueur ne peut aller uniquement que dans les cases voisines aux cases qu'il a déjà visité, sauf dans le cas où il veut tirer une flèche, là il peut aller sur une case odeur qu'il aurait déjà visité.
Cela permet de s'assurer qu'il existe un chemin sûr jusque cette case, donc le joueur peut y aller sans risque.

Pour ce qui est des prédicats, ils sont mit à jour à chaque déplacement. 
Tout d'abord on met à jour les prédicats de la case visitée, puis on metà jour les prédicats sur les cases voisines, grâce aux indices de notre case.
Puis, étant donné que des déductions sont faites sur les cases voisines, il est possible que nous pouvons faire des déductions sur des cases plus éloignées.
C'est pourquoi nous mettons ensuite à jour tous les prédicats de toutes les cases.
 
------ 
2016 - Corentin Vanson / Clément Grégoire