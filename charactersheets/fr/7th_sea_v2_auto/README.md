#Fiche automatisée pour 7th sea v2

authors: Knil  
contact: Knil sur le Discord de Rolisteam  
instructions:  
Version: Rolisteam 1.9, RCSE 1.9.2  
License: GPL v3  
Status: Completed  

##Utilisation  
	
###1) Saisie des données du personnage:  
-La saisie des statistiques du personnage se fait en page 3, à l'exception des "consommables" (points d'héroïsme, réputations, richesse) et des arcanes et historiques.  
-Les valeurs de caractéristiques et de compétences saisies en page 3 sont automatiquement converties en "points" sur la premère page.  
-La rubrique "Avantages" de la première page liste les noms des avantages saisis dans la même rubrique de la page 3. Les descriptions ne sont pas reprises, il s'agit juste d'un aide-mémoire.
Les avantages Sorcellerie et Académie de duelliste n'ont pas à être saisis en page 3, il suffit de remplir les sorcelleries choisies et/ou le style de duel pour qu'ils soient affichés en page 1.  

###2) Gestion des blessures:
-Le bouton "+" coche une nouvelle case à chaque appui. Il coche une nouvelle blessure dramatique à chaque fois qu'il arrive sur une étoile (cochée ou non). C'est ainsi que j'ai compris les règles de gestion des blessures. Ce fonctionnement peut-être modifié facilement dans la fonction increaseWounds (l.49) si vous jouez différemment.  
-Le bouton "-" décoche seulement les blessures simples mais laisse les blessures dramatiques.  
-Le bouton "0" remet à zéro les blessures simples mais pas les dramatiques (fin de scène).  
-Le bouton "heal" retire 1 blessure dramatique.  

###3) Jets de dés:
-L'appui sur le bouton "Roll" lance un jet de dé prenant en compte tous les paramètres présents dans le panneau. Le jet est effectué par les fonctions contenues dans la fiche et transmets à DiceParser le texte à afficher dans le chat. Le texte affiché indique le nombre de mises obtenues, les groupes réalisés et les dés non utilisés.  
-Les bonus liés au niveaux 3 à 5 des compétences et aux blessures dramatiques 1 et 3 sont automatiquement pris en compte.  
-La relance n'est effectuée que sur le plus petit des dés non utilisés s'il y en a. Pour l'instant, cette fonction est totalement silencieuse. Elle ne précise ni le dé relancé ni son ancienne valeur.  
-La double réussite obtenue sur un groupement de 15 + avec une compétence de rang 4 est prise en compte dans le résultat.

