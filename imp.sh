#!/bin/bash

# Auteur : Anisa Skenderovic (000457599)
nouveauNom()
{
  local CIBLE=$1
  echo $CIBLE
  local FILE=$2
  echo $FILE
  local LIGNE=$4
  echo $LIGNE
  local NAME=${LIGNE:1:-2} # Garde que le nom
  mkdir -p $CIBLE/$NAME
  cp $FILE $CIBLE/$NAME
  local NEWFILE=${FILE##*/} #Retrait du chemin
  mv $CIBLE/$NAME/$NEWFILE $CIBLE/$NAME/$NAME.pgn
}


migration()
{
  CibleRep=$2
  if [ -f $1 ]    # Le paramètre donné est un fichier
  	then
    local FILE=$1
    local newNameBlacks=""
    cat $FILE | while  read LIGNE ; do
      echo "$LIGNE hors if"
      if [[ $LIGNE =~ Black ]]
      then
        echo "here $LIGNE"
        Elo=`echo ${LIGNE} | grep "BlackElo" | wc -l`
        if [[ ${Elo} == 0 ]] # Vérifie que ce ne soit pas le classement ELo mais le nom
        then
          nouveauNom $CibleRep $FILE $LIGNE
        fi
      fi
      if [[ $LIGNE =~ White ]]
      then
        echo "here $LIGNE"
        Elo=`echo ${LIGNE} | grep "WhiteElo" | wc -l`
        if [[ ${Elo} == 0 ]] # Vérifie que ce ne soit pas le classement ELo mais le nom
        then
          nouveauNom $CibleRep $FILE $LIGNE
        fi
      fi
    done

  else
    ALLREP=$(ls $1)
  	for REP in $ALLREP   # Parcours de chaque répertoire
  	do
  	   migration $1/$REP $CibleRep # Appel récursif sur chaque répertoire
  	done

  fi
  return 0

}



SourceRep=$1 # chemin vers le répertoire source des fichiers PGN
CibleRep=$2 # chemin vers le répertoire cible qui contiendra la nouvelle arborescence
PoubelleRep=$3 # chemin vers le répertoire poubelle qui contiendra les fichiers posant problème
ConflitFile=$4 # chemin vers le fichier de conflits

mkdir -p $CibleRep
migration $SourceRep $CibleRep

exit 0
