/**
 * メッセージの「確認した」ボタン押下時の処理
 */
$("#client_id").change(function() {
  var clientId = $("#client_id").val();
  // ajaxで対象のmessage_journal_idのレコード削除フラグ更新処理を実行
    $.ajax({
      url: '/csv/export/getPeriod',
      type:'GET',
      data:{
        // 押下されたボタンのjournal_mesasge_idを取得する
        'client_id':clientId
      }
    })
    .done(function() {
      // 取得した期間情報で期間セレクトボックスの値を更新
    })
    .fail(function() {
      // 意図しないエラーが発生した旨のメッセージを表示
      alert("エラーが発生しました。F5ボタンなどを押して画面を再ロードし、やりなおしてしてください。\n それでも直らない場合は担当者にお問い合わせください。");
    });
});

/**
 * セレクトボックスの連動処理
 */
$('select[name="period-from"]').change(function() {
  var periodFrom = $('select[name="period-from"]').val();
  alert(periodFrom);
});