#! /bin/bash

source testing_utilities.sh
source library.sh

function test_case_picture_block_bulbasaur() {
  local expected_output="<div class=\"pokemon-picture\"><div class=\"picture-container\"><img src=\"../resources/images/bulbasaur.png\" alt=\"bulbasaur\" title=\"bulbasaur\" /></div></div>"
  local message="should generate picture block for bulbasaur"

  local poke_name="bulbasaur"
  local IMAGES_DIR=../resources/images

  local actual_output="$(generate_picture_block "${poke_name}" "${IMAGES_DIR}" )"

  assert_result  "${expected_output}" "${actual_output}" "${message}"
}
function test_case_picture_block_pikachu() {
  local expected_output="<div class=\"pokemon-picture\"><div class=\"picture-container\"><img src=\"../resources/images/pikachu.png\" alt=\"pikachu\" title=\"pikachu\" /></div></div>"
  local message="should generate picture block for pikachu"
  
  local poke_name="pikachu"
  local IMAGES_DIR=../resources/images

  local actual_output="$(generate_picture_block "${poke_name}" "${IMAGES_DIR}")"

  assert_result  "${expected_output}" "${actual_output}" "${message}"
}
function test_picture_block() {
  test_case_picture_block_bulbasaur
  test_case_picture_block_pikachu
}

function test_case_type_block_for_multiple_types() {
  local expected_output="<div class=\"pokemon-type\"><div class=\"grass\">grass</div><div class=\"poison\">poison</div></div>"
  local message="should generate type block for for multiple types"

  local types=( grass poison )
  local actual_output="$(generate_type_block "${types[*]}" )"
  
  assert_result  "${expected_output}" "${actual_output}" "${message}"
}
function test_case_type_block_for_single_type() {
  local expected_output="<div class=\"pokemon-type\"><div class=\"electric\">electric</div></div>"
  local message="should generate type block for for single type"

  local types=( electric )
  local actual_output="$(generate_type_block "${types[*]}" )"

  assert_result  "${expected_output}" "${actual_output}" "${message}"
}
function test_type_block() {
  test_case_type_block_for_multiple_types
  test_case_type_block_for_single_type
}

function test_case_table_block_bulbasaur() {
  local expected_output="<table class=\"stats\"><tbody><tr><th>Weight</th><td>69</td></tr><tr><th>Base XP</th><td>64</td></tr><tr><th>HP</th><td>45</td></tr><tr><th>Attack</th><td>49</td></tr><tr><th>Defence</th><td>49</td></tr><tr><th>Speed</th><td>45</td></tr></tbody></table>"
  local message="should generate table block for bulbasaur"

  local weight=69 base_xp=64 hp=45 attack=49 defence=49 speed=45
  local actual_output="$(generate_table_block ${weight} ${base_xp} ${hp} ${attack} ${defence} ${speed} )"
  
  assert_result  "${expected_output}" "${actual_output}" "${message}"
}
function test_case_table_block_pikachu() {
  local expected_output="<table class=\"stats\"><tbody><tr><th>Weight</th><td>60</td></tr><tr><th>Base XP</th><td>112</td></tr><tr><th>HP</th><td>35</td></tr><tr><th>Attack</th><td>55</td></tr><tr><th>Defence</th><td>40</td></tr><tr><th>Speed</th><td>90</td></tr></tbody></table>"
  local message="should generate table block for pikachu"

  local weight=60 base_xp=112 hp=35 attack=55 defence=40 speed=90
  local actual_output="$(generate_table_block ${weight} ${base_xp} ${hp} ${attack} ${defence} ${speed} )"
  
  assert_result  "${expected_output}" "${actual_output}" "${message}"
}
function test_table_block() {
  test_case_table_block_bulbasaur
  test_case_table_block_pikachu
}

function test_case_card_single_type() {
  local expected_output="<article id=\"10\" class=\"pokemon-card\"><div class=\"pokemon-picture\"><div class=\"picture-container\"><img src=\"../resources/images/pikachu.png\" alt=\"pikachu\" title=\"pikachu\" /></div></div><div class=\"pokemon-details\"><header><h2 class=\"pokemon-name\">pikachu</h2><div class=\"pokemon-type\"><div class=\"electric\">electric</div></div></header><table class=\"stats\"><tbody><tr><th>Weight</th><td>98</td></tr><tr><th>Base XP</th><td>47</td></tr><tr><th>HP</th><td>45</td></tr><tr><th>Attack</th><td>57</td></tr><tr><th>Defence</th><td>67</td></tr><tr><th>Speed</th><td>45</td></tr></tbody></table></div></article>"
  local message="should generate card for single type"

  local data="10|pikachu|electric|45|45|47|57|67|98"
  local IMAGES_DIR=../resources/images

  local actual_output="$( generate_card "${data}" "${IMAGES_DIR}")"
  assert_result  "${expected_output}" "${actual_output}" "${message}"
}
function test_case_card_multiple_types() {
  local expected_output="<article id=\"10\" class=\"pokemon-card\"><div class=\"pokemon-picture\"><div class=\"picture-container\"><img src=\"../resources/images/pikachu.png\" alt=\"pikachu\" title=\"pikachu\" /></div></div><div class=\"pokemon-details\"><header><h2 class=\"pokemon-name\">pikachu</h2><div class=\"pokemon-type\"><div class=\"electric\">electric</div><div class=\"grass\">grass</div><div class=\"poison\">poison</div></div></header><table class=\"stats\"><tbody><tr><th>Weight</th><td>98</td></tr><tr><th>Base XP</th><td>47</td></tr><tr><th>HP</th><td>45</td></tr><tr><th>Attack</th><td>57</td></tr><tr><th>Defence</th><td>67</td></tr><tr><th>Speed</th><td>45</td></tr></tbody></table></div></article>"
  local message="should generate card for multiple types"

  local data="10|pikachu|electric,grass,poison|45|45|47|57|67|98"
  local IMAGES_DIR=../resources/images

  local actual_output="$( generate_card "${data}" "${IMAGES_DIR}")"
  assert_result  "${expected_output}" "${actual_output}" "${message}"
}
function test_generate_card() {
  test_case_card_single_type
  test_case_card_multiple_types
}

function test_case_get_multiple_catagories(){
  local pokemon_records="10|pikachu|electric,grass,poison|45|45|47|57|67|98"
  local expected_output="`echo -e "electric\ngrass\npoison"`"
  local message="should get all the catagories from the given record"
  local actual_output="$(get_catagories "${pokemon_records}")"

  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_get_single_catagory(){
  local pokemon_records="10|pikachu|electric|45|45|47|57|67|98"
  local expected_output="electric"
  local message="should get the catagory from the given record"
  local actual_output="$(get_catagories "${pokemon_records}" )"

  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_get_multiple_catagories_from_multiline_record(){
  local pokemon_records="`echo -e "10|pikachu|electric|45|45|47|57|67|98\n1|bulbasaur|grass,poison|45|45|47|57|67|98"`"
  local expected_output="`echo -e "electric\ngrass\npoison"`"
  local message="should get all the catagories from the given multi line record"
  local actual_output="$(get_catagories "${pokemon_records}" )"

  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_get_catagories() {
  test_case_get_single_catagory
  test_case_get_multiple_catagories
  test_case_get_multiple_catagories_from_multiline_record
}

function test_generate_sidebar() {
  local types=(all grass poison)
  local expected_output='<div class="sidebar"><nav class="pokemon-types"><ul><li><a href="all.html">all</a></li><li><a href="grass.html" class="selected grass">grass</a></li><li><a href="poison.html">poison</a></li></ul></nav></div>'
  local message="should generate sidebar for the given types"

  local actual_output="$(generate_sidebar "grass" "${types[*]}" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}

function test_select_sidebar_type() {
  local expected_output='<div class="sidebar"><nav class="pokemon-types"><ul><li class="all"><a href="all.html" class="selected">all</a></li><li class="__grass__"><a href="grass.html" class="__grass_not_selected__">grass</a></li><li class="__poison__"><a href="poison.html" class="__poison_not_selected__">poison</a></li></ul></nav></div>'
  local message="should add classes select and type to the given sidebar for the given type"

  local sidebar='<div class="sidebar"><nav class="pokemon-types"><ul><li class="__all__"><a href="all.html" class="__all_not_selected__">all</a></li><li class="__grass__"><a href="grass.html" class="__grass_not_selected__">grass</a></li><li class="__poison__"><a href="poison.html" class="__poison_not_selected__">poison</a></li></ul></nav></div>'

  local actual_output="$(select_sidebar_type "all" "${sidebar}" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}

function test_generate_page_content() {
  local expected_output='<div class="page-content"><article id="197" class="pokemon-card"><div class="pokemon-picture"><div class="picture-container"><img src="../resources/images/umbreon.png" alt="umbreon" title="umbreon" /></div></div><div class="pokemon-details"><header><h2 class="pokemon-name">umbreon</h2><div class="pokemon-type"><div class="dark">dark</div></div></header><table class="stats"><tbody><tr><th>Weight</th><td>270</td></tr><tr><th>Base XP</th><td>184</td></tr><tr><th>HP</th><td>95</td></tr><tr><th>Attack</th><td>65</td></tr><tr><th>Defence</th><td>110</td></tr><tr><th>Speed</th><td>65</td></tr></tbody></table></div></article><article id="198" class="pokemon-card"><div class="pokemon-picture"><div class="picture-container"><img src="../resources/images/murkrow.png" alt="murkrow" title="murkrow" /></div></div><div class="pokemon-details"><header><h2 class="pokemon-name">murkrow</h2><div class="pokemon-type"><div class="dark">dark</div><div class="flying">flying</div></div></header><table class="stats"><tbody><tr><th>Weight</th><td>21</td></tr><tr><th>Base XP</th><td>81</td></tr><tr><th>HP</th><td>60</td></tr><tr><th>Attack</th><td>85</td></tr><tr><th>Defence</th><td>42</td></tr><tr><th>Speed</th><td>91</td></tr></tbody></table></div></article></div>'
  local message="should generate page containing multiple cards from given record"
  local records=( "197|umbreon|dark|65|95|184|65|110|270" "198|murkrow|dark,flying|91|60|81|85|42|21" )

  local IMAGES_DIR=../resources/images 
  local actual_output="$( generate_page_content "${records[*]}" "${IMAGES_DIR}" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}

function test_generate_head_tag() {
  local expected_output='<head><title>Pokemon</title><link rel="stylesheet" href="./css/css1" /><link rel="stylesheet" href="./css/css2" /></head>'
  local message="should generate the head tag with title and links"
  local CSS_DIR=./css
  mkdir -p ${CSS_DIR}
  touch ${CSS_DIR}/css1 ${CSS_DIR}/css2
  local actual_output="$( generate_head_tag "${CSS_DIR}" "." )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
  rm -rf ${CSS_DIR}
}

function test_case_filter_records_for_type() {
  local expected_output="`echo -e "197|umbreon|dark|65|95|184|65|110|270\n198|murkrow|dark,flying|91|60|81|85|42|21"`"
  local message="should filter the records of the selected type from the given records"

  local pokemon_records="`echo -e "196|espeon|psychic|110|65|184|65|60|265\n197|umbreon|dark|65|95|184|65|110|270\n198|murkrow|dark,flying|91|60|81|85|42|21\n199|slowking|water,psychic|30|95|172|75|80|795"`"

  local actual_output="$( filter_records "dark" "${pokemon_records[*]}" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_filter_records_for_all() {
  local expected_output="`echo -e "196|espeon|psychic|110|65|184|65|60|265\n197|umbreon|dark|65|95|184|65|110|270\n198|murkrow|dark,flying|91|60|81|85|42|21\n199|slowking|water,psychic|30|95|172|75|80|795"`"
  local message="should return the records of all the types from the given records"

  local pokemon_records="`echo -e "196|espeon|psychic|110|65|184|65|60|265\n197|umbreon|dark|65|95|184|65|110|270\n198|murkrow|dark,flying|91|60|81|85|42|21\n199|slowking|water,psychic|30|95|172|75|80|795"`"

  local actual_output="$( filter_records "all" "${pokemon_records[*]}" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_filter_records() {
  test_case_filter_records_for_all
  test_case_filter_records_for_type
}

function test_case_generate_tag_with_class() {
  local expected_output='<div class="class">content</div>'
  local message="should create the provided tag with the given class and content"
  local actual_output="$( generate_tag "div" "class" "content" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_generate_tag_without_class() {
  local expected_output='<div>content</div>'
  local message="should create the provided tag with empty class when only tag and content are provided"
  local actual_output="$( generate_tag "div" "" "content" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_generate_tag() {
  test_case_generate_tag_with_class
  test_case_generate_tag_without_class
}

function test_case_generate_tag_with_id() {
  local expected_output="<div id=\"id\" class=\"class\">content</div>"
  local message="should create the provided tag with the given id, class and content"
  local actual_output="$( generate_tag_with_id "div" "class" "id" "content" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_generate_tag_with_id_empty_class() {
  local expected_output="<div id=\"id\" class=\"\">content</div>"
  local message="should create the provided tag with empty class when only tag, id and content are provided"
  local actual_output="$( generate_tag_with_id "div" "" "id" "content" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_generate_tag_with_id_empty_class_empty_id() {
  local expected_output="<div id=\"\" class=\"\">content</div>"
  local message="should create the provided tag with empty class and id when only tag and content are provided"
  local actual_output="$( generate_tag_with_id "div" "" "" "content" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_generate_tag_with_id_with_class_empty_id() {
  local expected_output="<div id=\"\" class=\"class\">content</div>"
  local message="should create the provided tag with empty id when only tag, class and content are provided"
  local actual_output="$( generate_tag_with_id "div" "class" "" "content" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_generate_tag_with_id() {
  test_case_generate_tag_with_id
  test_case_generate_tag_with_id_empty_class
  test_case_generate_tag_with_id_empty_class_empty_id
  test_case_generate_tag_with_id_with_class_empty_id
}

function test_case_generate_anchor() {
  local expected_output='<a href="link" class="class">content</a>'
  local message="should create an anchor tag with provided link, class and content"
  local actual_output="$( generate_anchor "class" "link" "content" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_generate_anchor_without_link() {
  local expected_output='<a href="#" class="class">content</a>'
  local message="should create an anchor tag with provided class and content and link as # when link is not provided"
  local actual_output="$( generate_anchor "class" "" "content" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_generate_anchor_without_class() {
  local expected_output='<a href="link">content</a>'
  local message="should create an anchor tag with provided link and content when class is not provided"
  local actual_output="$( generate_anchor "" "link" "content" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_generate_anchor() {
  test_case_generate_anchor
  test_case_generate_anchor_without_link
  test_case_generate_anchor_without_class
}

function test_case_get_field_name() {
  local expected_output="name"
  local message="should get the info of the given field from the given data when that field has single info"
  local data="id|name|types|1|2|3|4|5|6"
  local actual_output="$( get_field 2 "${data}" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_case_get_field_types() {
  local expected_output="type1,type2"
  local message="should get the info of the given field from the given data when that field has multiple info"
  local data="id|name|type1,type2|1|2|3|4|5|6"
  local actual_output="$( get_field 3 "${data}" )"
  assert_result "${expected_output}" "${actual_output}" "${message}"
}
function test_get_field() {
  test_case_get_field_name
  test_case_get_field_types
}


function all_tests() {
  sub_function="generate_picture_block"
  test_picture_block

  sub_function="generate_type_block"
  test_type_block
  
  sub_function="generate_table_block"
  test_table_block

  sub_function="generate_card"
  test_generate_card

  sub_function="get_catagories"
  test_get_catagories

  sub_function="generate_sidebar"
  test_generate_sidebar

  # sub_function="select_sidebar_type"
  # test_select_sidebar_type
  
  sub_function="generate_page_content"
  test_generate_page_content

  sub_function="filter_records"
  test_filter_records
  
  sub_function="generate_tag"
  test_generate_tag

  sub_function="generate_tag_with_id"
  test_generate_tag_with_id
  
  sub_function="generate_anchor"
  test_generate_anchor

  sub_function="get_field"
  test_get_field

  sub_function="generate_head_tag"
  test_generate_head_tag

  generate_report
}

all_tests

# assert_result "${expected_output}" "${actual_output}" "${message}"
# generate_report
# get_info