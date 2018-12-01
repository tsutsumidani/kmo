/**
 * 会計グラフ作成処理
 */
(function() {
    var client = gon.client;
    var journalList = gon.journal_list;
    var labelList = getClientsLabelList(journalList);
    var debitAmountList = getDebitAmountList(journalList);
    var creditAmountList = getCreditAmountList(journalList);

    var elementClass = '#client_' + client.id;
    var gragh = new Chart($(elementClass), {
      type: 'line',
      data: {
        labels: labelList,
        datasets: [
          {
            label: '貸方',
            data: debitAmountList,
            borderColor: "rgba(255,0,0,1)",
            backgroundColor: "rgba(0,0,0,0)"
          },
          {
            label: '借方',
            data: creditAmountList,
            borderColor: "rgba(0,0,255,1)",
            backgroundColor: "rgba(0,0,0,0)"
          }
        ],
      },
    });
}());

/**
 * ラベルリスト.
 * @param {array} clientsJournalList クライアント別仕訳データ.
 * @return {array} クライアント別仕訳データ.
 */
function getClientsLabelList(clientsJournalList) {
  var clientsLabelList = [];
  clientsJournalList.forEach(function (clientsJournal) {
    clientsLabelList.push(clientsJournal.f_record_dt);
  });
  return clientsLabelList;
}

/**
 * 貸方リスト.
 * @param {array} journalList
 * @return {array} 貸方リスト
 */
function getDebitAmountList(journalList) {
  var debitAmountList = [];
  journalList.forEach(function (journal) {
    debitAmountList.push(journal.debit_amount);
  });
  return debitAmountList;
}

/**
 * 借方リスト.
 * @param {array} journalList
 * @return {array} 借方リスト
 */
function getCreditAmountList(journalList) {
  var creditAmountList = [];
  journalList.forEach(function (journal) {
    creditAmountList.push(journal.credit_amount);
  });
  return creditAmountList;
}
