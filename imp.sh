#!/bin/bash

# Auteur : Anisa Skenderovic (000457599)
nouveauNom()
{
  local CIBLE=$1
  local FILE=$2
  local SOURCEFILE=$2
  local NAME=$3
  local DATE=$5
  local ROUND=$6
  local RESULT=$7
  local ConflitFile=$8
  local POUBELLE=$9
  echo "OOO $4"

  if [ "${4}" != "1" ]
  then
    echo "blancs"
    COLOR="blancs"
  else
    echo "noirs"
    COLOR="noirs"
  fi

  if [ -f "${CIBLE}.pgn" ]; then
    poubelle "${CIBLE}.pgn" "${POUBELLE}"
  fi

  mkdir -p "${CIBLE}"
  if [ ! -f "${CIBLE}"/$COLOR"_""${NAME}""_"$DATE"_"$ROUND"_"$RESULT.pgn ]; then

    cp $FILE "${CIBLE}"
    local NEWFILE=${FILE##*/} #Retrait du chemin
    mv "${CIBLE}"/$NEWFILE "${CIBLE}"/$COLOR"_""${NAME}""_"$DATE"_"$ROUND"_"$RESULT.pgn

  else
    conflit $ConflitFile $SOURCEFILE "${CIBLE}"/$COLOR"_""${NAME}""_"$DATE"_"$ROUND"_"$RESULT.pgn
  fi
}

poubelle()
{
  mv "${1}" ${2}
}

conflit()
{
  echo "COnflit"
  CONFFILE=$1
  SOURCEFILE=$2
  CIBLEFILE=$3
  echo "${SOURCEFILE} ${CIBLEFILE}" >> $CONFFILE
}


migration()
{
  CibleRep=$2
  ConflitFile=$3
  POUBELLE=$4

  if [ -f $1 ] && [[ $1 == *.pgn ]]    # Le paramètre donné est un fichier
  	then
    FILE=$1
    while  read LIGNE && [ "$LIGNE" != "" ]; do
      if [[ $LIGNE =~ Black ]]
      then
        Elo=`echo ${LIGNE} | grep "BlackElo" | wc -l`
        if [[ ${Elo} == 0 ]] # Vérifie que ce ne soit pas le classement ELo mais le nom
        then
          local BLACK=${LIGNE:8:-2}
        fi
      fi

      if [[ $LIGNE =~ White ]]
      then
        Elo=`echo ${LIGNE} | grep "WhiteElo" | wc -l`
        if [[ ${Elo} == 0 ]] # Vérifie que ce ne soit pas le classement ELo mais le nom
        then
          local WHITE=${LIGNE:8:-2}
        fi
      fi

      if [[ $LIGNE =~ Date ]]
      then
        local DATE=${LIGNE:7:-2}
        echo $DATE
      fi

      if [[ $LIGNE =~ Round ]]
      then
        local ROUND=${LIGNE:8:-2}
        echo $ROUND
      fi

      if [[ $LIGNE =~ Result ]]
      then
        VAR=${LIGNE:9:-2}
        if [ $VAR == "0-1" ]; then # 0 pour les blancs

          RESULTB="D"
          RESULTN="G"

        elif [ $VAR == "1-0" ]; then
          RESULTB="G"
          RESULTN="D"

        else
          RESULTB="N"
          RESULTN="N"
        fi
        echo $RESULTB
      fi
    done <"$FILE"

    nouveauNom $CibleRep/"${BLACK}" "${FILE}" "${WHITE}" 1 $DATE $ROUND $RESULTN $ConflitFile $POUBELLE # Fichier pour les noirs
    nouveauNom $CibleRep/"${WHITE}" "${FILE}" "${BLACK}" 0 $DATE $ROUND $RESULTB $ConflitFile $POUBELLE # Fichier pour les blancs
  fi

  if [ -d $1 ] # C'est un répertoire
  then
    ALLREP=$(ls $1)
  	for REP in $ALLREP   # Parcours de chaque répertoire
  	do
  	   migration $1/$REP $CibleRep $ConflitFile $POUBELLE # Appel récursif sur chaque répertoire
  	done

  fi
  return 0

}



SourceRep=$1 # chemin vers le répertoire source des fichiers PGN
CibleRep=$2 # chemin vers le répertoire cible qui contiendra la nouvelle arborescence
POUBELLE=$3 # chemin vers le répertoire poubelle qui contiendra les fichiers posant problème
ConflitFile=$4 # chemin vers le fichier de conflits

mkdir -p $CibleRep
mkdir -p $POUBELLE
cat /dev/null > $ConflitFile
migration $SourceRep $CibleRep $ConflitFile $POUBELLE

exit 0
