
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
       souffle/1,
       odeur/1,
       bruit/1,
       /*********PERCEPTS********/
       maybeAscenseur/1,
       maybeMonstre/1,
       maybeTrou/1,
       sureAscenseur/1,
       sureMonstre/1,
       sureMonstreMort/1,
       sureTrou/1,
       /*****DONNEES DE JEU******/
       direction/1,		  % 1=Nord; 2=Est; 3=Sud; 4=Ouest;
       fleche/0
   ]).

start :-
	initialise,
        new(P, auto_sized_picture('Wumpus World')),
	afficherJeu(P),
	afficherJeu(P).

initialise :-
	initialisation,
	initialiserJoueur,
	initialiserMur,
	initialiserMonstre,
	initialiserTresor,
	initialiserAscenseur,
	initialiserTrous(3).

initialisation :-
	retractall(joueur([_,_])),
	retractall(mur([_,_])),
	retractall(monstre([_,_])),
	retractall(trou([_,_])),
	retractall(souffle([_,_])),
	retractall(tresor([_,_])),
	retractall(ascenseur([_,_])),
	retractall(bruit([_,_])),
	retractall(odeur([_,_])),
	retractall(maybeAscenseur([_,_])),
	retractall(maybeMonstre([_,_])),
	retractall(maybeTrou([_,_])),
	retractall(sureAscenseur([_,_])),
	retractall(sureMonstre([_,_])),
	retractall(sureMonstreMort([_,_])),
	retractall(sureTrou([_,_])),
	retractall(direction(_)),
	assert(fleche),
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
	    assert(tresor([X,Y]))
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
	assignerTrous(Nb),
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
	    assert(souffle([X,Ym])),
	    assert(souffle([X,Yp])),
	    assert(souffle([Xm,Y])),
	    assert(souffle([Xp,Y])),
	    Nbb is Nb - 1,
	    (
			    Nbb =< 0;
			    assignerTrous(Nbb)
	    )
	);
	assignerTrous(Nb),
	!.

estVide([X,Y]) :-
	not(monstre([X,Y])),
	not(mur([X,Y])),
	not(trou([X,Y])),
	not(joueur([X,Y])),
	not(ascenseur([X,Y])),
	not(tresor([X,Y])),
	!.

afficherJeu(P) :-
        send(P, display, new(T, tabular)),
        send(T, border, 1),
        send(T, cell_spacing, -1),
        send(T, rules, all),
	afficherElements(T,0,0),
	send(P, open).

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
			Yb is Y+1,
		        send(T,next_row)
		)
        ),
	(
	    Yb < 6,
	    send(T,append(new(Q, tabular))),
	    (
		(
		     not(souffle([Xb,Yb])),
		     send(Q,append("c",colour := white, background := white))
	        );
		send(Q,append("s",colour := white, background := red))
	    ),
	    send(Q,append("c",colour := white, background := white)),
	    (
		(
		     not(bruit([Xb,Yb])),
		     send(Q,append("b",colour := white, background := white))
	        );
		send(Q,append("b",colour := white, background := purple))
	    ),
	    send(Q,next_row),
	    send(Q,append("c",colour := white, background := white)),
	    (
		(
		     not(not(monstre([Xb,Yb]))),
		     send(Q,append("m",colour := black, background := green))
	        );
		(
		     not(not(tresor([Xb,Yb]))),
		     send(Q,append("t",colour := black, background := yellow))
	        );
		(
		     not(not(ascenseur([Xb,Yb]))),
		     send(Q,append("a",colour := black, background := orange))
	        );
		(
		     not(not(joueur([Xb,Yb]))),
		     send(Q,append("j",colour := white, background := brown))
	        );
		(
		     not(not(trou([Xb,Yb]))),
		     send(Q,append("t",colour := white, background := black))
	        );
		(
		     not(not(mur([Xb,Yb]))),
		     send(Q,append("m",colour := black, background := gray))
	        );
		send(Q,append("c",colour := white, background := white))
	    ),

	    send(Q,append("c",colour := white, background := white)),
	    send(Q,next_row),
	    (
		(
		     not(odeur([Xb,Yb])),
		     send(Q,append("c",colour := white, background := white))
	        );
		send(Q,append("o",colour := white, background := blue))
	    ),
	    send(Q,append("c",colour := white, background := white)),
	    (
		(
		     not(bruit([Xb,Yb])),
		     send(Q,append("c",colour := white, background := white))
	        );
		send(Q,append("c",colour := white, background := white))
	    ),
	    Xc is Xb + 1,
	    afficherElements(T,Xc,Yb)
	);
	!.