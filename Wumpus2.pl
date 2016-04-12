
:- use_module(library(random)).
:- use_module(library(tabular)).
:- use_module(library(autowin)).

:- dynamic([
       /*******CARTE DE JEU*******/
       joueur/1,
       mur/1,
       monstre/1,
       tresor/1,
       ascenseur/1,
       trou/1,
       souffle/2, % Changement ici, le deuxième parametre désigne le nombre de puits autour
       odeur/1,
       bruit/1,
       bling/1,
       /*********PERCEPTS********/
       maybeAscenseur/1,
       maybeMonstre/1,
       maybeTrou/1,
       maybeTresor/1,
       sureAscenseur/1,
       ascenseurTrouve/0,
       sureMonstre/1,
       sureTrou/1,
       sureTresor/1,
       tresorTrouve/0,
       sureNotAscenseur/1,
       sureNotMonstre/1,
       sureNotTrou/1,
       sureNotTresor/1,
       poidChemin/1,
       chemin/1,
       visite/1,
       safe/1,
       /*****DONNEES DE JEU******/
       direction/1,		  % 1=Nord; 2=Est; 3=Sud; 4=Ouest;
       cri/0,
       flecheTire/0,
       fleche/0,
       gagner/0,
       perdu/0,
       /****PARCOURS INITIAL****/
       initVisite/1,
       tresorFoundable/0,
       ascenseurFoundable/0
   ]).

start :-
	new(P, picture('Wumpus World', size(725,550))),
	start(P).

start(P) :-
	initialise,
	parcoursInit,
	afficherJeu(P),
	sleep(1),
	(   (
	    (not(tresorFoundable);not(ascenseurFoundable)),
	    start(P)
	);boucleDeJeu(P)).

parcoursInit :-
	parcoursInit(1,1),
	!.

parcoursInit(X,Y) :-
	assert(initVisite([X,Y])),
	((tresor([X,Y]),assert(tresorFoundable));!),
	((ascenseur([X,Y]),assert(ascenseurFoundable));!),
	Xp is X + 1,
	Xm is X - 1,
	Yp is Y + 1,
	Ym is Y - 1,
	((not(mur([Xp,Y])), not(trou([Xp,Y])), not(initVisite([Xp,Y])), parcoursInit(Xp,Y));!),
	((not(mur([Xm,Y])), not(trou([Xm,Y])), not(initVisite([Xm,Y])), parcoursInit(Xm,Y));!),
	((not(mur([X,Yp])), not(trou([X,Yp])), not(initVisite([X,Yp])), parcoursInit(X,Yp));!),
	((not(mur([X,Ym])), not(trou([X,Ym])), not(initVisite([X,Ym])), parcoursInit(X,Ym));!),
	!.

/*******************************************/
/**************INITIALISATION***************/
/*******************************************/

initialise :-
	initialisation,
	initialiserJoueur,
	initialiserMur,
	initialiserMonstre,
	initialiserTresor,
	initialiserAscenseur,
	initialiserTrous(3),
	miseAJourPredicat.

initialisation :-
	retractall(joueur([_,_])),
	retractall(mur([_,_])),
	retractall(monstre([_,_])),
	retractall(trou([_,_])),
	retractall(souffle([_,_],_)),
	retractall(bling([_,_])),
	retractall(tresor([_,_])),
	retractall(ascenseur([_,_])),
	retractall(bruit([_,_])),
	retractall(odeur([_,_])),
	retractall(maybeAscenseur([_,_])),
	retractall(maybeMonstre([_,_])),
	retractall(maybeTrou([_,_])),
	retractall(maybeTresor([_,_])),
	retractall(sureAscenseur([_,_])),
	retractall(sureMonstre([_,_])),
	retractall(sureTrou([_,_])),
	retractall(sureTresor([_,_])),
	retractall(sureNotAscenseur([_,_])),
	retractall(sureNotTresor([_,_])),
	retractall(sureNotMonstre([_,_])),
	retractall(sureNotTrou([_,_])),
	retractall(visite([_,_])),
	retractall(safe([_,_])),
	retractall(direction(_)),
	retractall(tresorTrouve),
	retractall(ascenseurTrouve),
	retractall(gagner),
	retractall(perdu),
	retractall(initVisite([_,_])),
	retractall(poidChemin(_)),
	retractall(chemin([_,_])),
	retractall(tresorFoundable),
	retractall(ascenseurFoundable),
	assert(fleche),
	retractall(cri),
	retractall(flecheTire),
	assert(direction(2)),
	!.

initialiserJoueur :-
	assert(joueur([1,1])).

initialiserMur :-
	assert(mur([0,0])),
	assert(mur([0,1])),
	assert(mur([0,2])),
	assert(mur([0,3])),
	assert(mur([0,4])),
	assert(mur([0,5])),
	assert(mur([1,5])),
	assert(mur([2,5])),
	assert(mur([3,5])),
	assert(mur([4,5])),
	assert(mur([5,5])),
	assert(mur([5,4])),
	assert(mur([5,3])),
	assert(mur([5,2])),
	assert(mur([5,1])),
	assert(mur([5,0])),
	assert(mur([4,0])),
	assert(mur([3,0])),
	assert(mur([2,0])),
	assert(mur([1,0])),
	!.

initialiserMonstre :-
	random(1,5,X),
	random(1,5,Y),
	(
	    estVide([X,Y]),
	    assert(monstre([X,Y])),
	    Xp is X + 1,
	    Xm is X - 1,
	    Yp is Y + 1,
	    Ym is Y - 1,
	    assert(odeur([X,Ym])),
	    assert(odeur([X,Yp])),
	    assert(odeur([Xm,Y])),
	    assert(odeur([Xp,Y]))

	);
	initialiserMonstre,
	!.

initialiserTresor :-
	random(1,5,X),
	random(1,5,Y),
	(
	    estVide([X,Y]),
	    assert(tresor([X,Y])),
	    Xp is X + 1,
	    Xm is X - 1,
	    Yp is Y + 1,
	    Ym is Y - 1,
	    assert(bling([X,Ym])),
	    assert(bling([X,Yp])),
	    assert(bling([Xm,Y])),
	    assert(bling([Xp,Y]))

	);
	initialiserTresor,
	!.

initialiserAscenseur :-
	random(1,5,X),
	random(1,5,Y),
	(
	    estVide([X,Y]),
	    assert(ascenseur([X,Y])),
	    Xp is X + 1,
	    Xm is X - 1,
	    Yp is Y + 1,
	    Ym is Y - 1,
	    assert(bruit([X,Ym])),
	    assert(bruit([X,Yp])),
	    assert(bruit([Xm,Y])),
	    assert(bruit([Xp,Y]))
	);
	initialiserAscenseur,
	!.

initialiserTrous(Nb) :-
	initSouffles(0,0),
	assignerTrous(Nb),
	!.

initSouffles(Xa,Ya) :-
	(
             (
		 (Xa < 6, Xb is Xa, Yb is Ya);
		 (Xa > 5, Xb is 0, Yb is Ya + 1)
	     ),

             (
		   (
		         Yb > 5
	           );
	           (
		         assert(souffle([Xb,Yb],0)),
			 Xc is Xb + 1,
		         initSouffles(Xc,Yb)
		   )
	     )
	),
	!.

assignerTrous(Nb) :-
	random(1,5,X),
	random(1,5,Y),
	(
	    estVide([X,Y]),
	    (
		X>2;
		Y>2
	    ),
	    assert(trou([X,Y])),
	    Xp is X + 1,
	    Xm is X - 1,
	    Yp is Y + 1,
	    Ym is Y - 1,
	    (
		souffle([X,Ym],A),
		Aa is A + 1,
		retractall(souffle([X,Ym],_)),
		assert(souffle([X,Ym],Aa))
	    ),
	    (
		souffle([X,Yp],Z),
		Za is Z + 1,
		retractall(souffle([X,Yp],_)),
		assert(souffle([X,Yp],Za))
	    ),
	    (
		souffle([Xp,Y],E),
		Ea is E + 1,
		retractall(souffle([Xp,Y],_)),
		assert(souffle([Xp,Y],Ea))
	    ),
	    (
		souffle([Xm,Y],R),
		Ra is R + 1,
		retractall(souffle([Xm,Y],_)),
		assert(souffle([Xm,Y],Ra))
	    ),
	    Nbb is Nb - 1,
	    (
			    Nbb =< 0;
			    assignerTrous(Nbb)
	    )
	);
	assignerTrous(Nb),
	!.

/*******************************************/
/****************PREDICAT*******************/
/*******************************************/


miseAJourPredicat :-
	getJoueur(X,Y,1,1),
	assert(visite([X,Y])),
	retractall(safe([X,Y])),
	(
	    (
	        not(not(monstre([X,Y]))),
	        monstreTrouve(X,Y,1,1),
		retractall(maybeMonstre([X,Y])),
		retractall(sureNotMonstre([X,Y])),
	        assert(sureMonstre([X,Y]))
	    );
	(
	        not(monstre([X,Y])),
		retractall(maybeMonstre([X,Y])),
	        assert(sureNotMonstre([X,Y]))
	    )
	),
	(
	    (
	        not(not(tresor([X,Y]))),
	        tresorTrouve(X,Y,1,1),
		retractall(maybeTresor([X,Y])),
		retractall(sureNotTresor([X,Y])),
	        assert(sureTresor([X,Y])),
	        assert(tresorTrouve)
	    );
	(
	        not(tresor([X,Y])),
		retractall(maybeTresor([X,Y])),
	        assert(sureNotTresor([X,Y]))
	    )
	),
	(
	    (
	        not(not(ascenseur([X,Y]))),
	        ascenseurTrouve(X,Y,1,1),
		retractall(maybeAscenseur([X,Y])),
		retractall(sureNotAscenseur([X,Y])),
	        assert(sureAscenseur([X,Y])),
	        assert(ascenseurTrouve)
	    );
	(
	        not(ascenseur([X,Y])),
		retractall(maybeAscenseur([X,Y])),
	        assert(sureNotAscenseur([X,Y]))
	    )
	),
	(
	    (
	        not(not(trou([X,Y]))),
		retractall(maybeTrou([X,Y])),
		retractall(sureNotTrou([X,Y])),
	        assert(sureTrou([X,Y]))
	    );
	(
	        not(trou([X,Y])),
		retractall(maybeTrou([X,Y])),
	        assert(sureNotTrou([X,Y]))
	    )
	),
	(   (
	    (souffle([X,Y],A),A=<0),
	    not(odeur([X,Y])),
	    ((Xa is X,Ya is Y + 1, not(mur([Xa,Ya])),not(visite([Xa,Ya])), assert(safe([Xa,Ya])));!),
	    ((Xb is X,Yb is Y - 1, not(mur([Xb,Yb])),not(visite([Xb,Yb])), assert(safe([Xb,Yb])));!),
	    ((Xc is X + 1,Yc is Y, not(mur([Xc,Yc])),not(visite([Xc,Yc])), assert(safe([Xc,Yc])));!),
	    ((Xd is X - 1,Yd is Y, not(mur([Xd,Yd])),not(visite([Xd,Yd])), assert(safe([Xd,Yd])));!)
	);!),
	((
	    not(not(odeur([X,Y]))),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    not(sureMonstre([Xup,Y])),
	    not(sureMonstre([Xdown,Y])),
	    not(sureMonstre([X,Yup])),
	    not(sureMonstre([X,Ydown])),
	    (	(
		not(mur([Xup,Y])),
		(
		    not(not(sureNotMonstre([Xup,Y]))) ;
		    assert(maybeMonstre([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    not(not(sureNotMonstre([Xdown,Y]))) ;
		    assert(maybeMonstre([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    not(not(sureNotMonstre([X,Yup]))) ;
		    assert(maybeMonstre([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    not(not(sureNotMonstre([X,Ydown]))) ;
		    assert(maybeMonstre([X,Ydown]))
		)
	    );!)
	);
	(
	    not(odeur([X,Y])),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    assert(sureNotMonstre([Xup,Y])),
		    retractall(sureMonstre([Xup,Y])),
		    retractall(maybeMonstre([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    assert(sureNotMonstre([Xdown,Y])),
		    retractall(sureMonstre([Xdown,Y])),
		    retractall(maybeMonstre([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    assert(sureNotMonstre([X,Yup])),
		    retractall(sureMonstre([X,Yup])),
		    retractall(maybeMonstre([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    assert(sureNotMonstre([X,Ydown])),
		    retractall(sureMonstre([X,Ydown])),
		    retractall(maybeMonstre([X,Ydown]))

		)
	    );!)
	);!),
	(   (
	    (souffle([X,Y], Z), Z>0),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    not(not(sureNotTrou([Xup,Y]))) ;
		    assert(maybeTrou([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    not(not(sureNotTrou([Xdown,Y]))) ;
		    assert(maybeTrou([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    not(not(sureNotTrou([X,Yup]))) ;
		    assert(maybeTrou([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    not(not(sureNotTrou([X,Ydown]))) ;
		    assert(maybeTrou([X,Ydown]))
		)
	    );!)
	);
	(
	    (souffle([X,Y],R),R=<0),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    assert(sureNotTrou([Xup,Y])),
		    retractall(sureTrou([Xup,Y])),
		    retractall(maybeTrou([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    assert(sureNotTrou([Xdown,Y])),
		    retractall(sureTrou([Xdown,Y])),
		    retractall(maybeTrou([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    assert(sureNotTrou([X,Yup])),
		    retractall(sureTrou([X,Yup])),
		    retractall(maybeTrou([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    assert(sureNotTrou([X,Ydown])),
		    retractall(sureTrou([X,Ydown])),
		    retractall(maybeTrou([X,Ydown]))
		)
	    );!)
	);!),

	(   (
	    not(not(bruit([X,Y]))),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    not(sureAscenseur([Xup,Y])),
	    not(sureAscenseur([Xdown,Y])),
	    not(sureAscenseur([X,Yup])),
	    not(sureAscenseur([X,Ydown])),
	    (	(
		not(mur([Xup,Y])),
		(
		    not(not(sureNotAscenseur([Xup,Y]))) ;
		    assert(maybeAscenseur([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    not(not(sureNotAscenseur([Xdown,Y]))) ;
		    assert(maybeAscenseur([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    not(not(sureNotAscenseur([X,Yup]))) ;
		    assert(maybeAscenseur([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    not(not(sureNotAscenseur([X,Ydown]))) ;
		    assert(maybeAscenseur([X,Ydown]))
		)
	    );!)
	);
	(
	    not(bruit([X,Y])),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    assert(sureNotAscenseur([Xup,Y])),
		    retractall(sureAscenseur([Xup,Y])),
		    retractall(maybeAscenseur([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    assert(sureNotAscenseur([Xdown,Y])),
		    retractall(sureAscenseur([Xdown,Y])),
		    retractall(maybeAscenseur([Xdown,Y]))

		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    assert(sureNotAscenseur([X,Yup])),
		    retractall(sureAscenseur([X,Yup])),
		    retractall(maybeAscenseur([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    assert(sureNotAscenseur([X,Ydown])),
		    retractall(sureAscenseur([X,Ydown])),
		    retractall(maybeAscenseur([X,Ydown]))
		)
	    );!)
	);!),


	(   (
	    not(not(bling([X,Y]))),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    not(sureTresor([Xup,Y])),
	    not(sureTresor([Xdown,Y])),
	    not(sureTresor([X,Yup])),
	    not(sureTresor([X,Ydown])),
	    (	(
		not(mur([Xup,Y])),
		(
		    not(not(sureNotTresor([Xup,Y]))) ;
		    assert(maybeTresor([Xup,Y]))
		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    not(not(sureNotTresor([Xdown,Y]))) ;
		    assert(maybeTresor([Xdown,Y]))
		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    not(not(sureNotTresor([X,Yup]))) ;
		    assert(maybeTresor([X,Yup]))
		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    not(not(sureNotTresor([X,Ydown]))) ;
		    assert(maybeTresor([X,Ydown]))
		)
	    );!)
	);
	(
	    not(bling([X,Y])),
	    Xup is X + 1,
	    Xdown is X - 1,
	    Yup is Y + 1,
	    Ydown is Y - 1,
	    (	(
		not(mur([Xup,Y])),
		(
		    assert(sureNotTresor([Xup,Y])),
		    retractall(sureTresor([Xup,Y])),
		    retractall(maybeTresor([Xup,Y]))

		)
	    );!),
	    (	(
		not(mur([Xdown,Y])),
		(
		    assert(sureNotTresor([Xdown,Y])),
		    retractall(sureTresor([Xdown,Y])),
		    retractall(maybeTresor([Xdown,Y]))

		)
	    );!),
	    (	(
		not(mur([X,Yup])),
		(
		    assert(sureNotTresor([X,Yup])),
		    retractall(sureTresor([X,Yup])),
		    retractall(maybeTresor([X,Yup]))

		)
	    );!),
	    (	(
		not(mur([X,Ydown])),
		(
		    assert(sureNotTresor([X,Ydown])),
		    retractall(sureTresor([X,Ydown])),
		    retractall(maybeTresor([X,Ydown]))
		)
	    );!)
	);!),

	miseAJourPredicatsMonde,
	!.

miseAJourPredicatsMonde :-
	miseAJourPredicatsCase(0,0),
	!.

miseAJourPredicatsCase(Xa,Ya) :-
	(
	     (
		 (Xa < 6, Xb is Xa, Yb is Ya);
		 (Xa > 5, Xb is 0, Yb is Ya + 1)
	     ),

             (
		   (
		         Yb > 5
	           );
	           (
	                 (
			      ((
				   visite([Xb,Yb]),
		                   odeur([Xb,Yb]),
		                   Xup is Xb + 1,
		                   Xdown is Xb -1,
		                   Yup is Yb + 1,
				   Ydown is Yb - 1,
		                   getNumNotMonstreAutourCase(Xb,Yb,N),
				   N == 3,
		                   (((maybeMonstre([Xup,Yb]);(not(sureMonstre([Xup,Yb])),not(sureNotMonstre([Xup,Yb])))), not(mur([Xup,Yb])), retractall(maybeMonstre([Xup,Yb])), assert(sureMonstre([Xup,Yb])), monstreTrouve(Xup,Yb,1,1), assert(sureNotTrou([Xup,Yb])), assert(sureNotTresor([Xup,Yb])), assert(sureNotAscenseur([Xup,Yb])) );!),
		                   (((maybeMonstre([Xdown,Yb]);(not(sureMonstre([Xdown,Yb])),not(sureNotMonstre([Xdown,Yb])))), not(mur([Xdown,Yb])), retractall(maybeMonstre([Xdown,Yb])), assert(sureMonstre([Xdown,Yb])), monstreTrouve(Xdown,Yb,1,1), assert(sureNotTrou([Xdown,Yb])), assert(sureNotTresor([Xdown,Yb])), assert(sureNotAscenseur([Xdown,Yb])) );!),
		                   (((maybeMonstre([Xb,Yup]);(not(sureMonstre([Xb,Yup])),not(sureNotMonstre([Xb,Yup])))), not(mur([Xb,Yup])), retractall(maybeMonstre([Xb,Yup])), assert(sureMonstre([Xb,Yup])), monstreTrouve(Xb,Yup,1,1), assert(sureNotTrou([Xb,Yup])), assert(sureNotTresor([Xb,Yup])), assert(sureNotAscenseur([Xb,Yup])) );!),
		                   (((maybeMonstre([Xb,Ydown]);(not(sureMonstre([Xb,Ydown])),not(sureNotMonstre([Xb,Ydown])))), not(mur([Xb,Ydown])), retractall(maybeMonstre([Xb,Ydown])), assert(sureMonstre([Xb,Ydown])), monstreTrouve(Xb,Ydown,1,1), assert(sureNotTrou([Xb,Ydown])), assert(sureNotTresor([Xb,Ydown])), assert(sureNotAscenseur([Xb,Ydown])) );!)
			      );!),
			      ((
				   visite([Xb,Yb]),
		                   bling([Xb,Yb]),
		                   getNumNotTresorAutourCase(Xb,Yb,Nt),
				   Nt == 3,
		                   Xtup is Xb + 1,
		                   Xtdown is Xb -1,
		                   Ytup is Yb + 1,
				   Ytdown is Yb - 1,
		                   (((maybeTresor([Xtup,Yb]);(not(sureTresor([Xtup,Yb])), not(sureNotTresor([Xtup,Yb])))), not(mur([Xtup,Yb])), retractall(maybeTresor([Xtup,Yb])), assert(sureTresor([Xtup,Yb])), tresorTrouve(Xtup,Yb,1,1), assert(sureNotTrou([Xtup,Yb])), assert(sureNotMonstre([Xtup,Yb])), assert(sureNotAscenseur([Xtup,Yb])),
				    (
				     not(sureMonstre([Xtup,Yb])),
				     not(sureTrou([Xtup,Yb])),
				     assert(safe([Xtup,Yb]))
				    )
				    );!),
		                   (((maybeTresor([Xtdown,Yb]);(not(sureTresor([Xtdown,Yb])),not(sureNotTresor([Xtdown,Yb])))), not(mur([Xtdown,Yb])), retractall(maybeTresor([Xtdown,Yb])), assert(sureTresor([Xtdown,Yb])), tresorTrouve(Xtdown,Yb,1,1), assert(sureNotTrou([Xtdown,Yb])), assert(sureNotMonstre([Xtdown,Yb])), assert(sureNotAscenseur([Xtdown,Yb])),
				     (
				         not(sureMonstre([Xtdown,Yb])),
				         not(sureTrou([Xtdown,Yb])),
				         assert(safe([Xtdown,Yb]))
				     )
);!),
		                   (((maybeTresor([Xb,Ytup]);(not(sureTresor([Xb,Ytup])),not(sureNotTresor([Xb,Ytup])))), not(mur([Xb,Ytup])), retractall(maybeTresor([Xb,Ytup])), assert(sureTresor([Xb,Ytup])), tresorTrouve(Xb,Ytup,1,1), assert(sureNotTrou([Xb,Ytup])), assert(sureNotMonstre([Xb,Ytup])), assert(sureNotAscenseur([Xb,Ytup])), (
				         not(sureMonstre([Xb,Ytup])),
				         not(sureTrou([Xb,Ytup])),
				         assert(safe([Xb,Ytup]))
				     )
);!),
		                   (((maybeTresor([Xb,Ytdown]);(not(sureTresor([Xb,Ytdown])),not(sureNotTresor([Xb,Ytdown])))), not(mur([Xb,Ytdown])), retractall(maybeTresor([Xb,Ytdown])), assert(sureTresor([Xb,Ytdown])), tresorTrouve(Xb,Ytdown,1,1), assert(sureNotTrou([Xb,Ytdown])), assert(sureNotMonstre([Xb,Ytdown])), assert(sureNotAscenseur([Xb,Ytdown])), (
				         not(sureMonstre([Xb,Ytdown])),
				         not(sureTrou([Xb,Ytdown])),
				         assert(safe([Xb,Ytdown]))
				     )
);!)
			      );!),
			      ((
				   visite([Xb,Yb]),
		                   bruit([Xb,Yb]),
		                   getNumNotAscenseurAutourCase(Xb,Yb,Na),
				   Na == 3,
		                   Xaup is Xb + 1,
		                   Xadown is Xb -1,
		                   Yaup is Yb + 1,
				   Yadown is Yb - 1,
		                   (((maybeAscenseur([Xaup,Yb]);(not(sureAscenseur([Xaup,Yb])),not(sureNotAscenseur([Xaup,Yb])))), not(mur([Xaup,Yb])), retractall(maybeAscenseur([Xaup,Yb])), assert(sureAscenseur([Xaup,Yb])), ascenseurTrouve(Xaup,Yb,1,1), assert(sureNotTrou([Xaup,Yb])), assert(sureNotMonstre([Xaup,Yb])), assert(sureNotTresor([Xaup,Yb])), (
				     not(sureMonstre([Xaup,Yb])),
				     not(sureTrou([Xaup,Yb])),
				     assert(safe([Xaup,Yb]))
				    )
);!),
		                   (((maybeAscenseur([Xadown,Yb]);(not(sureAscenseur([Xadown,Yb])),not(sureNotAscenseur([Xadown,Yb])))), not(mur([Xadown,Yb])), retractall(maybeAscenseur([Xadown,Yb])), assert(sureAscenseur([Xadown,Yb])), ascenseurTrouve(Xadown,Yb,1,1), assert(sureNotTrou([Xadown,Yb])), assert(sureNotMonstre([Xadown,Yb])), assert(sureNotTresor([Xadown,Yb])), (
				         not(sureMonstre([Xadown,Yb])),
				         not(sureTrou([Xadown,Yb])),
				         assert(safe([Xadown,Yb]))
				     )
);!),
		                   (((maybeAscenseur([Xb,Yaup]);(not(sureAscenseur([Xb,Yaup])),not(sureNotAscenseur([Xb,Yaup])))), not(mur([Xb,Yaup])), retractall(maybeAscenseur([Xb,Yaup])), assert(sureAscenseur([Xb,Yaup])), ascenseurTrouve(Xb,Yaup,1,1), assert(sureNotTrou([Xb,Yaup])), assert(sureNotMonstre([Xb,Yaup])), assert(sureNotTresor([Xb,Yaup])), (
				         not(sureMonstre([Xb,Yaup])),
				         not(sureTrou([Xb,Yaup])),
				         assert(safe([Xb,Yaup]))
				     )
);!),
		                   (((maybeAscenseur([Xb,Yadown]);(not(sureAscenseur([Xb,Yadown])),not(sureNotAscenseur([Xb,Yadown])))), not(mur([Xb,Yadown])), retractall(maybeAscenseur([Xb,Yadown])), assert(sureAscenseur([Xb,Yadown])), ascenseurTrouve(Xb,Yadown,1,1), assert(sureNotTrou([Xb,Yadown])), assert(sureNotMonstre([Xb,Yadown])), assert(sureNotTresor([Xb,Yadown])), (
				         not(sureMonstre([Xb,Yadown])),
				         not(sureTrou([Xb,Yadown])),
				         assert(safe([Xb,Yadown]))
				     )
);!)
			      );!),
		              ((sureNotMonstre([Xb,Yb]),sureNotTrou([Xb,Yb]),not(visite([Xb,Yb])), not(mur([Xb,Yb])),assert(safe([Xb,Yb])));!),
		              Xc is Xb + 1,
	                      miseAJourPredicatsCase(Xc,Yb)
		         )
		   )
	     )
	),
	!.

getNumNotMonstreAutourCase(X,Y,N) :-
	Xup is X + 1,
	Xdown is X -1,
	Yup is Y + 1,
	Ydown is Y - 1,
	No is 0,
	(((sureNotMonstre([Xup,Y]); mur([Xup,Y])),Ni is No + 1); Ni is No),
	(((sureNotMonstre([Xdown,Y]); mur([Xdown,Y])),Nii is Ni + 1); Nii is Ni),
	(((sureNotMonstre([X,Yup]); mur([X,Yup])),Niii is Nii + 1); Niii is Nii),
	(((sureNotMonstre([X,Ydown]); mur([X,Ydown])),Niiii is Niii + 1); Niiii is Niii),
	N is Niiii,
	!.

getNumNotAscenseurAutourCase(X,Y,N) :-
	Xup is X + 1,
	Xdown is X -1,
	Yup is Y + 1,
	Ydown is Y - 1,
	No is 0,
	(((sureNotAscenseur([Xup,Y]); mur([Xup,Y])),Ni is No + 1); Ni is No),
	(((sureNotAscenseur([Xdown,Y]); mur([Xdown,Y])),Nii is Ni + 1); Nii is Ni),
	(((sureNotAscenseur([X,Yup]); mur([X,Yup])),Niii is Nii + 1); Niii is Nii),
	(((sureNotAscenseur([X,Ydown]); mur([X,Ydown])),Niiii is Niii + 1); Niiii is Niii),
	N is Niiii,
	!.

getNumNotTresorAutourCase(X,Y,N) :-
	Xup is X + 1,
	Xdown is X -1,
	Yup is Y + 1,
	Ydown is Y - 1,
	No is 0,
	(((sureNotTresor([Xup,Y]); mur([Xup,Y])),Ni is No + 1); Ni is No),
	(((sureNotTresor([Xdown,Y]); mur([Xdown,Y])),Nii is Ni + 1); Nii is Ni),
	(((sureNotTresor([X,Yup]); mur([X,Yup])),Niii is Nii + 1); Niii is Nii),
	(((sureNotTresor([X,Ydown]); mur([X,Ydown])),Niiii is Niii + 1); Niiii is Niii),
	N is Niiii,
	!.

tresorTrouve(X,Y, Xa, Ya) :-
	(
	     (
		 (
		    Xa == 1,
                    Ya == 1,
                    retractall(maybeTresor([_,_])),
                    retractall(sureTresor([_,_])),
                    retractall(sureNotTresor([_,_]))
		 );!
	     ),
	     (
		 (Xa < 5, Xb is Xa, Yb is Ya);
		 (Xa > 4, Xb is 1, Yb is Ya + 1)
	     ),

             (
		   (
		         Yb > 4
	           );
	           (
		         ((
			     Xb == X, Yb == Y, assert(sureTresor([Xb,Yb]))
			  );(
			     assert(sureNotTresor([Xb,Yb]))
			 )),
		         Xc is Xb + 1,
	                 tresorTrouve(X,Y,Xc,Yb)
		   )
	     )
	),
	!.

ascenseurTrouve(X,Y, Xa, Ya) :-
	(
	     (
		 (
		    Xa == 1,
                    Ya == 1,
                    retractall(maybeAscenseur([_,_])),
                    retractall(sureAscenseur([_,_])),
                    retractall(sureNotAscenseur([_,_]))
		 );!
	     ),
	     (
		 (Xa < 5, Xb is Xa, Yb is Ya);
		 (Xa > 4, Xb is 1, Yb is Ya + 1)
	     ),

             (
		   (
		         Yb > 4
	           );
	           (
		         ((
			     Xb == X, Yb == Y, assert(sureAscenseur([Xb,Yb]))
		         );(
			     assert(sureNotAscenseur([Xb,Yb]))
			 )),
		         Xc is Xb + 1,
	                 ascenseurTrouve(X,Y,Xc,Yb)
		   )
	     )
	),
	!.

monstreTrouve(X,Y, Xa, Ya) :-
	(
	     (
		 (
		    Xa == 1,
                    Ya == 1,
                    retractall(maybeMonstre([_,_])),
                    retractall(sureMonstre([_,_])),
                    retractall(sureNotMonstre([_,_]))
		 );!
	     ),
	     (
		 (Xa < 5, Xb is Xa, Yb is Ya);
		 (Xa > 4, Xb is 1, Yb is Ya + 1)
	     ),

             (
		   (
		         Yb > 4
	           );
	           (
		         ((
			     Xb == X, Yb == Y, assert(sureMonstre([Xb,Yb]))
			  );(
			     assert(sureNotMonstre([Xb,Yb]))
			 )),
		         Xc is Xb + 1,
	                 monstreTrouve(X,Y,Xc,Yb)
		   )
	     )
	),
	!.

monstreTue :-
	retractall(sureMonstre([_,_])),
	retractall(maybeMonstre([_,_])),
	retractall(sureNotMonstre([_,_])),
	retractall(monstre([_,_])),
	assert(cri),
	monstreTue(1,1),
	!.

monstreTue(Xa,Ya) :-
	(
             (
		 (Xa < 5, Xb is Xa, Yb is Ya);
		 (Xa > 4, Xb is 1, Yb is Ya + 1)
	     ),

             (
		   (
		         Yb > 4
	           );
	           (
                         assert(sureNotMonstre([Xb,Yb])),
		         Xc is Xb + 1,
	                 monstreTue(Xc,Yb)
		   )
	     )
	),
	!.

/*******************************************/
/**************BOUCLE DE JEU****************/
/*******************************************/

boucleDeJeu(P) :-
	(
            etapeSuivante(P),
            verifierEtatJeu,
            afficherJeu(P),
            sleep(1),
            (
		(
		    (not(not(gagner));not(not(perdu))),
		    start(P)
		);
		boucleDeJeu(P)
	    )
	),
	!.

verifierEtatJeu :-
	    getJoueur(X,Y,1,1),
	    ((not(not(ascenseur([X,Y]))),not(not(tresorTrouve)),assert(gagner));!),
	    (((not(not(monstre([X,Y])));not(not(trou([X,Y])))),assert(perdu));!),
	!.

/*******************************************/
/*****************JOUEUR********************/
/*******************************************/

/*******************IA**********************/

etapeSuivante(P) :-
	getProchaineEtape(X,Y,P),
	bougerJoueur([X,Y]),
	!.

getProchaineEtape(X,Y,P) :-
	(
            (
                not(not(tresorTrouve)),
                not(not(ascenseurTrouve)),
                getAscenseur(X,Y,1,1)
	    );
	    assert(poidChemin(10)),
	    assert(chemin([1,1])),
            getProchaineEtapeSafe(X,Y,0,0),
            (
		(
		    poidChemin(N),
		    (N == 2; N == 3),
		    tirerFleche(X,Y,P)
		);!
	    ),
            assert(chemin([_,_])),
            retractall(poidChemin(_))
        ),
	!.

getProchaineEtapeSafe(X,Y,Xa,Ya) :-
	(
	     (
		 (Xa < 6, Xb is Xa, Yb is Ya);
		 (Xa > 5, Xb is 0, Yb is Ya + 1)
	     ),

             (
		   (
		         Yb > 5,
		         chemin([Xch,Ych]),
		         X is Xch,
			 Y is Ych
		   );
	           (
	                 (
		              (
		                  not(visite([Xb,Yb])),
		                  not(sureMonstre([Xb,Yb])),
		                  not(sureTrou([Xb,Yb])),
		                  (
				      (
				          safe([Xb,Yb]),
				          Va is 0
				      );
				      (
					  not(safe([Xb,Yb])),
					  sureMonstre([Xb,Yb]),fleche,
				          Va is 2
				      );
				      (
					  not(safe([Xb,Yb])),
					  not(sureMonstre([Xb,Yb])),
				          maybeMonstre([Xb,Yb]),fleche,
				          Va is 3
				      );
				      (
					  not(safe([Xb,Yb])),
					  not(sureMonstre([Xb,Yb])),
					  not(sureTrou([Xb,Yb])),
					  (not(maybeMonstre([Xb,Yb]));not(fleche)),
				          (maybeAscenseur([Xb,Yb]);maybeTresor([Xb,Yb])),
				          Va is 4
				      );
				      (
					  not(maybeAscenseur([Xb,Yb])),
					  not(maybeTresor([Xb,Yb])),
					  not(safe([Xb,Yb])),
					  not(maybeMonstre([Xb,Yb])),
					  not(sureMonstre([Xb,Yb])),
					  (

					          maybeTrou([Xb,Yb]);
						 (
						      maybeMonstre([Xb,Yb]),
						      not(fleche)
						 )

					  ),
					  Va is 9
				      )
			          ),
		                  (
				      poidChemin(V),
				      Va < V,
				      retractall(poidChemin(_)),
				      retractall(chemin([_,_])),
				      assert(poidChemin(Va)),
				      assert(chemin([Xb,Yb]))
				  )
			      ;!),
		              Xc is Xb + 1,
		              getProchaineEtapeSafe(X,Y,Xc,Yb)
	                 );!
		   )
	     )
	),
	!.

tirerFleche(Xm,Ym, P):-
        getOdeurVisite(Xo,Yo),
	bougerJoueur([Xo,Yo]),
	(
	    (Xo == Xm, Ym > Yo, tournerJoueur(1));
	    (Xo < Xm, Ym == Yo, tournerJoueur(2));
	    (Xo == Xm, Ym > Yo, tournerJoueur(3));
	    (Xo > Xm, Ym == Yo, tournerJoueur(4))
	),
	tirerFleche,
	miseAJourPredicat,
	afficherJeu(P),
	sleep(1),
	retractall(flecheTire),
	!.

tirerFleche :-
	assert(flecheTire),
	getJoueur(X,Y,0,0),
	getDirection(D,1),
	(
	    (
	        D == 1,
		Yup is Y + 1,
	        (   (
		    monstre([X,Yup]),
		    monstreTue
		);
	        (
		    not(monstre([X,Yup])),
		    flecheTire(X,Yup,D)
		))
	    );
	    (
	        D == 2,
		Xup is X + 1,
		(   (
		    monstre([Xup,Y]),
		    monstreTue
		);
	        (
		    not(monstre([Xup,Y])),
		    flecheTire(Xup,Y,D)
		))
	    );
	    (
	        D == 3,
		Ydown is Y + 1,
	        (   (
		    monstre([X,Ydown]),
		    monstreTue
		);
	        (
		    not(monstre([X,Ydown])),
		    flecheTire(X,Ydown,D)
		))
	    );
	    (
	        D == 4,
		Xdown is X - 1,
		(   (
		    monstre([Xdown,Y]),
		    monstreTue
		);
	        (
		    not(monstre([Xdown,Y])),
		    flecheTire(Xdown,Y,D)
		))
	    )
	),
	!.

flecheTire(X,Y,D) :-
	(
	    (
                mur([X,Y])
	    );
	(
        retractall(sureMonstre([X,Y])),
	retractall(maybeMonstre([X,Y])),
	assert(sureNotMonstre([X,Y])),
	(
	    (
	        D == 1,
	        Ya is Y + 1,
	        Xa is X
	    );
	    (
	        D == 2,
	        Ya is Y,
	        Xa is X + 1
	    );
	    (
	        D == 3,
	        Ya is Y - 1,
	        Xa is X
	    );
	    (
	        D == 4,
	        Ya is Y,
	        Xa is X - 1
	    )
	),
	flecheTire(Xa,Ya, D)
	)),
	!.

getOdeurVisite(Xo,Yo) :-
	getOdeurVisite(Xo,Yo,1,1),
	!.

getOdeurVisite(Xo,Yo,Xa,Ya) :-
	(
	     (
		 (Xa < 5, Xb is Xa, Yb is Ya);
		 (Xa > 4, Xb is 1, Yb is Ya + 1)
	     ),

             (
		   (
		         Yb > 4;
			(visite([Xb,Yb]), odeur([Xb,Yb]), Xo is Xb, Yo is Yb)
	           );
	           (
		         Xc is Xb + 1,
	                 getOdeurVisite(Xo,Yo,Xc,Yb)
		   )
	     )
	),
	!.

/*****************DIVERS********************/

tournerJoueur(X) :-
	retractall(direction(_)),
	assert(direction(X)),
	!.

bougerJoueur([X,Y]) :-
	retractall(joueur([_,_])),
	assert(joueur([X,Y])),
	miseAJourPredicat,
	!.

avancerJoueur :-
	getJoueur(X,Y,1,1),
	getDirection(D,1),
	(
	    (D == 1,Xb is X, Yb is Y + 1);
	    (D == 2,Xb is X + 1, Yb is Y);
	    (D == 3,Xb is X, Yb is Y - 1);
	    (D == 4,Xb is X - 1, Yb is Y)
	),
	(
	    not(not(mur([Xb,Yb])));
	    bougerJoueur([Xb,Yb])
	),
	!.

getDirection(D,X) :-
	X > 4;
	(
            not(direction(X)),
            Xb is X + 1,
            getDirection(D,Xb)
	);
	(
            not(not(direction(X))),
            D is X
	),
	!.

getJoueur(X,Y,Xa,Ya) :-
	(
           (
	       not(joueur([Xa,Ya])),
	       Xb is Xa + 1,
               (
		   (
			Xb > 4,
			Xc is 1,
			Yc is Ya + 1
		   );
		   (
			Xb < 5,
			Xc is Xb + 0,
			Yc is Ya + 0
		   )
	       ),
               getJoueur(X,Y,Xc,Yc)
	   );
	   (
	       not(not(joueur([Xa,Ya]))),
	       X is Xa + 0,
	       Y is Ya + 0
	   );
	   Ya > 5
	),
	!.

getAscenseur(X,Y,Xa,Ya) :-
	(
           (
	       not(ascenseur([Xa,Ya])),
	       Xb is Xa + 1,
               (
		   (
			Xb > 4,
			Xc is 1,
			Yc is Ya + 1
		   );
		   (
			Xb < 5,
			Xc is Xb + 0,
			Yc is Ya + 0
		   )
	       ),
               getAscenseur(X,Y,Xc,Yc)
	   );
	   (
	       not(not(ascenseur([Xa,Ya]))),
	       X is Xa + 0,
	       Y is Ya + 0
	   );
	   Ya > 5
	),
	!.


/*******************************************/
/*****************DIVERS********************/
/*******************************************/

estVide([X,Y]) :-
	not(monstre([X,Y])),
	not(mur([X,Y])),
	not(trou([X,Y])),
	not(joueur([X,Y])),
	not(ascenseur([X,Y])),
	not(tresor([X,Y])),
	!.

/*******************************************/
/****************AFFICHAGE******************/
/*******************************************/

afficherJeu(P) :-
	send(P, display, new(T, tabular)),
        send(T, border, 1),
        send(T, cell_spacing, -1),
        send(T, rules, all),
	afficherElements(T,0,5),
	send(T,next_row),
	(
	    (
	         flecheTire,
	         cri,
		 send(T,append("Le Joueur tire... Et touche!", bold, center, valign := center, colour := white, background := blue, rowspan := 1, colspan := 6))
	    );
	    (
	         flecheTire,
		 send(T,append("Le Joueur tire... Mais ne touche pas!", bold, center, valign := center, colour := black, background := yellow, rowspan := 1, colspan := 6))
	    );
	    (
	         (not(ascenseurFoundable); not(tresorFoundable)),
		 send(T,append("Le Jeu n'a pas de solution...", bold, center, valign := center, colour := white, background := black, rowspan := 1, colspan := 6))
	    );
	    (
	         not(not(gagner)),
		 send(T,append("Gagné", bold, center, valign := center, colour := black, background := green, rowspan := 1, colspan := 6))
	    );
	    (
	         not(not(perdu)),
		 send(T,append("Perdu", bold, center, valign := center, colour := white, background := red, rowspan := 1, colspan := 6))
	    );
	    (
		 send(T,append("Recherche en cours...", bold, center, valign := center, colour := black, background := white, rowspan := 1, colspan := 6))
	    )
	),
	send(P, open),
	send(P,flush).

afficherElements(T,X,Y) :-
	(
                (
			X < 6,
			Xb is X + 0,
	                Yb is Y + 0
	        );
                (
		        X > 5,
		        Xb is 0,
			Yb is Y-1,
		        send(T,next_row)
		)
        ),
	(
	    Yb >= 0,
	    send(T,append(new(Q, tabular))),
	    (

		(
		     not(not(joueur([Xb,Yb]))),
		     send(Q,append("j", bold, center, valign := center, colour := black, background := cyan, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(monstre([Xb,Yb]))),
		     send(Q,append("m", bold, center, valign := center, colour := black, background := green, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(tresor([Xb,Yb]))),
		     send(Q,append("t", bold,  center, valign := center, colour := black, background := yellow, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(ascenseur([Xb,Yb]))),
		     send(Q,append("a", bold, center, valign := center, colour := black, background := orange, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(trou([Xb,Yb]))),
		     send(Q,append("t", bold, center, valign := center, colour := white, background := brown, rowspan := 2, colspan := 2))
	        );
		(
		     not(not(mur([Xb,Yb]))),
		     send(Q,append("m", bold, center, valign := center, colour := white, background := black, rowspan := 2, colspan := 2))
	        );
		send(Q,append("c", bold, center, valign := center, colour := white, background := white, rowspan := 2, colspan := 2))
	    ),
	    (
		(
		     (souffle([Xb,Yb],E), E=<0),
		     send(Q,append("0", bold, center, colour := white, background := gray))
	        );
(
		     (souffle([Xb,Yb],E), E==1),
		     send(Q,append("1", bold, center, colour := white, background := red))
	        );
(
		     (souffle([Xb,Yb],E), E==2),
		     send(Q,append("2", bold, center, colour := white, background := red))
	        );
(
		     (souffle([Xb,Yb],E), E==3),
		     send(Q,append("3", bold, center, colour := white, background := red))
	        );
(
		     (souffle([Xb,Yb],E), E>3),
		     send(Q,append("+", bold, center, colour := white, background := red))
	        )
	    ),
	    (
		(
		     not(bruit([Xb,Yb])),
		     send(Q,append("b", bold, center, colour := white, background := gray))
	        );
		send(Q,append("b", bold, center, colour := white, background := purple))
	    ),
	    send(Q,next_row),
	    (
		(
		     not(odeur([Xb,Yb])),
		     send(Q,append("o", bold, center,colour := white, background := gray))
	        );
		send(Q,append("o", bold, center,colour := white, background := blue))
	    ),
	    (
		(
		     not(bling([Xb,Yb])),
		     send(Q,append("b", bold, center,colour := white, background := gray))
	        );
		send(Q,append("b", bold, center,colour := black, background := yellow))
	    ),
	    send(Q,next_row),
	    (
		(
		     not(not(sureMonstre([Xb,Yb]))),
		     send(Q,append(".m ", bold, center, colour := black, background := green))
	        );
		(
		     not(not(sureNotMonstre([Xb,Yb]))),
		     send(Q,append("!m ", bold, center, colour := white, background := red))
	        );
		(
		     not(not(maybeMonstre([Xb,Yb]))),
		     send(Q,append("?m", bold, center, colour := white, background := orange))
	        );
		send(Q,append("~m", bold, center, colour := white, background := gray))
	    ),
	    (
		(
		     not(not(sureTrou([Xb,Yb]))),
		     send(Q,append(".t", bold, center, colour := white, background := brown))
	        );
		(
		     not(not(sureNotTrou([Xb,Yb]))),
		     send(Q,append("!t ", bold, center, colour := white, background := red))
	        );
		(
		     not(not(maybeTrou([Xb,Yb]))),
		     send(Q,append("?t", bold, center, colour := white, background := orange))
	        );
		send(Q,append("~t", bold,  center,colour := white, background := gray))
	    ),
	    send(Q,append("s", bold, center, colour := white, background := white)),
	    send(Q,append("b", bold, center, colour := white, background := white)),
	    send(Q,next_row),
	    (
		(
		     not(not(sureAscenseur([Xb,Yb]))),
		     send(Q,append(".a", bold, center, colour := black, background := orange))
	        );
		(
		     not(not(sureNotAscenseur([Xb,Yb]))),
		     send(Q,append("!a ", bold, center, colour := white, background := red))
	        );
		(
		     not(not(maybeAscenseur([Xb,Yb]))),
		     send(Q,append("?a", bold, center, colour := white, background := orange))
	        );
		send(Q,append("~a", bold,  center,colour := white, background := gray))
	    ),

	    (
		(
		     not(not(sureTresor([Xb,Yb]))),
		     send(Q,append(".t", bold, center, colour := black, background := yellow))
	        );
		(
		     not(not(sureNotTresor([Xb,Yb]))),
		     send(Q,append("!t ", bold, center, colour := white, background := red))
	        );
		send(Q,append("~t", bold,  center,colour := white, background := gray))
	    ),
	    send(Q,append("o", bold, center, colour := white, background := white)),
	    (
		(
		     not(not(visite([Xb,Yb]))),
		     send(Q,append("v", bold, center,colour := black, background := beige))
	        );
		(
		     not(not(safe([Xb,Yb]))),
		     send(Q,append("s", bold, center,colour := black, background := green))
	        );
		send(Q,append("v", bold, center,colour := white, background := white))
	    ),
	    send(Q,append("t", bold,  center,colour := white, background := white)),

	    Xc is Xb + 1,
	    afficherElements(T,Xc,Yb)
	);
	!.
