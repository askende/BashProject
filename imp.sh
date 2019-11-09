#!/bin/bash

# Auteur : Anisa Skenderovic (000457599)

migration()
{
  if [ -f $1 ]    # Le paramètre donné est un fichier
  	then
    local FILE=$1
    local newNameBlacks=""
    cat $FILE | while  read ligne ; do
      if [[ $ligne =~ Black ]]
      then
          queryValue $ligne
          echo $ligne
          #mv $newNameBlacks $newNameBlacks $name

      fi

    done

  else
    ALLREP=$(ls $1)
  	for REP in $ALLREP   # Parcours de chaque répertoire
  	do
  	   migration $1/$REP # Appel récursif sur chaque répertoire
  	done

  fi
  return 0

}

queryValue()
{
  #echo $1 | cut -d'"' -f1
  local name=$1
  name=${name:6}
  #$name=${$1%'"'*}
  echo $name
}

SourceRep=$1 # chemin vers le répertoire source des fichiers PGN
CibleRep=$2 # chemin vers le répertoire cible qui contiendra la nouvelle arborescence
PoubelleRep=$3 # chemin vers le répertoire poubelle qui contiendra les fichiers posant problème
ConflitFile=$4 # chemin vers le fichier de conflits

mkdir -p $CibleRep
migration $SourceRep

exit 0
