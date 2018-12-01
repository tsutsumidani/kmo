/**
 * メッセージの「確認した」ボタン押下時の処理
 */
$(".confirm").click(function() {
  var message_id = $(this).parents(".modal-content").attr("id");
  var journal_message_id = $(this).next("input").val();
  // ajaxで対象のmessage_journal_idのレコード削除フラグ更新処理を実行
    $.ajax({
      url: '/client/message_confirm',
      type:'POST',
      data:{
        // 押下されたボタンのjournal_mesasge_idを取得する
        'journal_message_id':journal_message_id
      }
    })
    .done(function() {
      if ($("#" + message_id).find(".result-record").length === 1) {
        $(".result-table").remove();
        // モーダルにメッセージを表示
        $("#" + message_id).prepend("<ul><li class='list-group-item list-group-item-info'>修正が必要なデータはありません。</li></ul>");
      }
      // 押下されたボタンの行を画面から削除する
      $("#jm-"+journal_message_id).remove();
    })
    .fail(function() {
      // 意図しないエラーが発生した旨のメッセージを表示
      alert("エラーが発生しました。F5ボタンなどを押して画面を再ロードし、やりなおしてしてください。\n それでも直らない場合は担当者にお問い合わせください。");
    });
});

/**
 * 各メッセージクリック時のモーダルフェードイン/フェードアウトに関するロジック
 */
$(".modal-open").click(function() {
  //キーボード操作などにより、オーバーレイが多重起動するのを防止する
  //ボタンからフォーカスを外す
  $(this).blur();

  //新しくモーダルウィンドウを起動しない
  if($("#modal-overlay")[0]) {
    return false;
  }

  //オーバーレイ用のHTMLコードを、[body]内の最後に生成する
  $("body").append('<div id="modal-overlay"></div>');

  //コンテンツをセンタリング
  centeringModalSyncer();

  //[$modal-overlay]をフェードイン
  $("#modal-overlay").fadeIn("slow");

  // 表示対象のモーダルID
  var targetModal = $(this).attr('id');
  // モーダルをフェードイン
  $("#mc-" + targetModal).fadeIn("slow");

  // [#modal-overlay]、または[#modal-close]をクリックした時にオーバーレイをフェードアウト
  $( "#modal-overlay, #modal-close" ).unbind().click( function(){
    // オーバーレイはフェードアウト後に削除
    $(".modal-content, #modal-overlay").fadeOut("slow", function() {
      $('#modal-overlay').remove() ;
    });
  });
});

/**
 * リサイズされたら、センタリングをする関数[centeringModalSyncer()]を再実行する
 */
//
$(window).resize(centeringModalSyncer);

/**
 * センタリングを実行する関数
 */
function centeringModalSyncer() {
  //画面(ウィンドウ)の幅、高さを取得
  var w = $( window ).width() ;
  var h = $( window ).height() ;

  // コンテンツ(.modal-content)の幅、高さを取得
  var cw = $(".modal-content").outerWidth();
  var ch = $(".modal-content").outerHeight();

  //センタリングを実行する
  $(".modal-content").css({"left": ((w - cw)/2) + "px","top": ((h - ch)/2) + "px"});
}

