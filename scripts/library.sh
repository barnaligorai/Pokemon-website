#! /bin/bash

#---------HELPER FUNCTIONS----------

function get_field() {
  local field=$1
  local data="$2"
  local info=$( cut -d"|" -f${field} <<< "${data}" )
  echo "${info}"
}

function get_catagories(){
  local pokemon_records="$1"
  local types=$(cut -d"|" -f3 <<< "${pokemon_records}" | tr "," "\n" | sort | uniq -i)
  echo "${types}"
}

function get_id() {
  local data="$1"
  get_field 1 "${data}"
}

function get_poke_name() {
  local data="$1"
  get_field 2 "${data}"
}

function get_types() {
  local data="$1"
  get_field 3 "${data}" | tr "," " "
}

function get_weight() {
  local data="$1"
  get_field 9 "${data}"
}

function get_base_xp() {
  local data="$1"
  get_field 6 "${data}"
}

function get_hp() {
  local data="$1"
  get_field 5 "${data}"
}

function get_attack() {
  local data="$1"
  get_field 7 "${data}"
}

function get_speed() {
  local data="$1"
  get_field 4 "${data}"
}

function get_defence() {
  local data="$1"
  get_field 8 "${data}"
}

function get_stats() {
  local data="$1"
  get_field 4 "${data}"-
}

#--------GENERATING FUNCTIONS------

function generate_tag() {
  local tag=$1
  local class=$2
  local content="$3"

  local html="<$tag class=\"${class}\">${content}</${tag}>"
  if [[ -z ${class} ]]
  then
    html="<$tag>${content}</${tag}>"
  fi
  echo "${html}"
}

function generate_anchor() {
  local class="$1"
  local link="$2"
  local content="$3"
  [[ -z ${link} ]] && link="#"

  local anchor="<a href=\"${link}\" class=\"${class}\">${content}</a>"
  if [[ -z ${class} ]]
  then
    anchor="<a href=\"${link}\">${content}</a>"
  fi
  echo "${anchor}"
}

function generate_table_block() {
  local weight=$1
  local base_xp=$2
  local hp=$3
  local attack=$4
  local defence=$5
  local speed=$6
  local th_elements=( Weight "Base XP" HP Attack Defence Speed )
  local td_elements=( ${weight} ${base_xp} ${hp} ${attack} ${defence} ${speed} )

  local TABLE_BLOCK="" th="" td="" tr=""
  for index in $( seq 0 $(( ${#th_elements[@]} - 1)) )
  do
    th="$( generate_tag "th" "" "${th_elements[${index}]}" )"
    td="$( generate_tag "td" "" "${td_elements[${index}]}" )"
    tr="$( generate_tag "tr" "" "${th}${td}" )"
    TABLE_BLOCK+="${tr}"
  done
  
  TABLE_BLOCK="$( generate_tag "tbody" "" "${TABLE_BLOCK}" )"
  TABLE_BLOCK="$( generate_tag "table" "stats" "${TABLE_BLOCK}" )"
  echo ${TABLE_BLOCK}
}

function generate_type_block() {
  local types=( $1 )
  local type_block=""
  for type in ${types[@]}
  do
    type_block+="<div class=\"${type}\">${type}</div>"
  done

  type_block="<div class=\"pokemon-type\">${type_block}</div>"
  echo "${type_block}"
}

function generate_picture_block() {
  local poke_name="$1"
  local IMAGES_DIR=$2
  local content="<img src=\"${IMAGES_DIR}/${poke_name}.png\" alt=\"${poke_name}\" title=\"${poke_name}\" />"

  content="$( generate_tag "div" "picture-container" "${content}" )"
  local PICTURE_BLOCK="$( generate_tag "div" "pokemon-picture" "${content}" )"
  echo "${PICTURE_BLOCK}"
}

function generate_tag_with_id() {
  local tag=$1
  local class=$2
  local id="$3"
  local content="$4"

  echo "<$tag id=\"${id}\" class=\"${class}\">${content}</${tag}>"
}

function generate_card() {
  local data="$1"
  local IMAGES_DIR=$2

  local id=$( get_id "${data}" )
  local poke_name=$( get_poke_name "${data}" )
  local types=($( get_types "${data}" ))
  local weight=$( get_weight "${data}" )
  local base_xp=$( get_base_xp "${data}" )
  local hp=$( get_hp "${data}" )
  local attack=$( get_attack "${data}" )
  local defence=$( get_defence "${data}" )
  local speed=$( get_speed "${data}" )

  local TYPE_BLOCK="$( generate_type_block "${types[*]}" )"
  local PICTURE_BLOCK="$( generate_picture_block "${poke_name}" "${IMAGES_DIR}" )"
  local TABLE_BLOCK="$( generate_table_block "${weight}" "${base_xp}" "${hp}" "${attack}" "${defence}" "${speed}" )"

  local heading="$( generate_tag "h2" "pokemon-name" "${poke_name}" )"
  local HEADER_BLOCK="$( generate_tag "header" "" "${heading}${TYPE_BLOCK}" )"
  local DETAILS_BLOCK="$( generate_tag "div" "pokemon-details" "${HEADER_BLOCK}${TABLE_BLOCK}" )"
  local ARTICLE_BLOCK="$( generate_tag_with_id "article" "pokemon-card" "${id}" "${PICTURE_BLOCK}${DETAILS_BLOCK}" )"

  echo "${ARTICLE_BLOCK}"
}

function generate_sidebar() {
  local selected_type=$1
  local types=( $2 )
  local anchor="" sidebar_data="" li=""

  for type in ${types[@]}
  do
    anchor="$( generate_anchor "" "${type}.html" "${type}" )"
    if [[ ${selected_type} == ${type} ]]
    then
      anchor="$( generate_anchor "selected ${type}" "${type}.html" "${type}" )"
    fi
      li="$( generate_tag "li" "" "${anchor}" )"
      sidebar_data+="${li}"
  done
  sidebar_data="$( generate_tag "ul" "" "${sidebar_data}" )" 
  sidebar_data="$( generate_tag "nav" "pokemon-types" "${sidebar_data}" )" 
  sidebar_data="$( generate_tag "div" "sidebar" "${sidebar_data}" )" 
  echo "${sidebar_data}"
}

function generate_page_content() {
  local records=( $1 )
  local IMAGES_DIR=$2
  local data="" CARD="" page_content=""

  for data in ${records[@]}
  do
    CARD="$( generate_card "${data}" "${IMAGES_DIR}" )"
    page_content+="${CARD}"
  done

  page_content="$( generate_tag "div" "page-content" "${page_content}" )"
  echo "${page_content}"
}

function generate_head_tag() {
  local CSS_DIR=$1
  local WEBSITE_DIR=$2
  local title="$( generate_tag "title" "" "Pokemon" )"
  local links=""
  local files=( $(ls ${WEBSITE_DIR}/${CSS_DIR}) )

  for file in ${files[@]}
  do
    links+="<link rel=\"stylesheet\" href=\"${CSS_DIR}/${file}\" />"
  done
  local head="$( generate_tag "head" "" "${title}${links}" )"
  echo "${head}"
}

function filter_records() {
  local type="$1"
  local pokemon_records="$2"

  if [[ ${type} == "all" ]]
  then
    echo "${pokemon_records}"
    return 0
  fi
  grep "^.*|.*|.*${type}.*|" <<< "${pokemon_records}" 
}

function generate_body_content() {
  local type="$1"
  local pokemon_records="$2"
  local types=( $3 )
  local IMAGES_DIR=$4

  local records="" page_content="" body_content=""

  local sidebar="$( generate_sidebar "${type}" "${types[*]}")"

  records=( $(filter_records "${type}" "${pokemon_records}" ) )
  page_content="$(generate_page_content "${records[*]}" "${IMAGES_DIR}" )"
  body_content="$( generate_tag "div" "page-wrapper" "${sidebar}${page_content}" )"
  body_content="$( generate_tag "body" "" "${body_content}" )"
  echo "${body_content}"
}

function generate_files() {
  local RECORDS_FILE=$1
  local WEBSITE_DIR=$2
  local CSS_DIR=$3
  local IMAGES_DIR=$4

  echo "Process of creating HTML files is started"

  local pokemon_records=`tail -n +2 ${RECORDS_FILE}`
  local types=( all $(get_catagories "${pokemon_records}"))
  local head_content="$( generate_head_tag "${CSS_DIR}" "${WEBSITE_DIR}" )"
  local body_content="" page=""
  for type in ${types[@]}
  do
    echo "${type}.html is being created"
    body_content="$( generate_body_content "${type}" "${pokemon_records}" "${types[*]}" "${IMAGES_DIR}" )"
    page="$( generate_tag "html" "" "${head_content}${body_content}")"
    echo "${page}" > ${WEBSITE_DIR}/${type}.html
  done
}

function main() {
  local RECORDS_FILE=$1
  local WEBSITE_DIR=$2
  local IMAGES_DIR=$3
  local CSS_DIR=$4


  if [[ -f ${RECORDS_FILE} ]]
  then
    generate_files "${RECORDS_FILE}" "${WEBSITE_DIR}" "${CSS_DIR}" "${IMAGES_DIR}"
  return 0
  fi
  
  echo "Provide the resource file"
  return 1
}