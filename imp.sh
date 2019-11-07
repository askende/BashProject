#!/bin/bash

# Auteur : Anisa Skenderovic (000457599)

migration()
{
  if [ -f $1 ]    # Le paramètre donné est un fichier
  	then
    local FILE=$1

  else
    ALLREP=$(ls $1)
  	for REP in $ALLREP   # Parcours de chaque répertoire
  	do
  	   migration $1/$REP # Appel récursif sur chaque répertoire
  	done

  fi
  return 0

}


SourceRep=$1 # chemin vers le répertoire source des fichiers PGN
CibleRep=$2 # chemin vers le répertoire cible qui contiendra la nouvelle arborescence
PoubelleRep=$3 # chemin vers le répertoire poubelle qui contiendra les fichiers posant problème
ConflitFile=$4 # chemin vers le fichier de conflits

mkdir -p $CibleRep
migration $SourceRep

exit 0
