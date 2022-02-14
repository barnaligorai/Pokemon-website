#! /bin/bash

source scripts/library.sh

RESOURCES_DIR=./resources
RECORDS_FILE=./${RESOURCES_DIR}/data/pokemon.csv # 800 pokemon

number_of_pokemons=$1
if [[ ! -z ${number_of_pokemons} ]]
then
  number_of_pokemons=$(( ${number_of_pokemons} + 1 ))
  head -n ${number_of_pokemons} $RECORDS_FILE > ${RESOURCES_DIR}/temp_records
  RECORDS_FILE=./$RESOURCES_DIR/temp_records
fi

WEBSITE_DIR=./pokemon_website
mkdir -p ./${WEBSITE_DIR}
rm -r ./${WEBSITE_DIR}/*

cp -r ./${RESOURCES_DIR}/css ${WEBSITE_DIR}
CSS_DIR=./css

IMAGES_DIR=./images
( cd ${WEBSITE_DIR} ; tar xvfz ../${RESOURCES_DIR}/images.tar.gz &> /dev/null ) # 800 pokemon

main ${RECORDS_FILE} ${WEBSITE_DIR} ${IMAGES_DIR} ${CSS_DIR}

rm ${RECORDS_FILE}