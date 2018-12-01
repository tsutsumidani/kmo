/**
 * ツールチップ有効化
 */
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

/**
 * CSVファイルを読み込んだ時にCSVファイル名を画面表示するためのロジック
 */
function file_selected(file_field){
  var filename = $(file_field)[0].files[0].name;
  $("#filename").val(filename);
}
