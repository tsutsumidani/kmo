/**
 * CSVファイルを読み込んだ時にCSVファイル名を画面表示するためのロジック
 */
(function() {
  // クライアントリスト
  gon.client_list.forEach(function(client) {
    var clientsJournalList = getClientsJournalList(client.client_id, gon.journal_list);
    var labelList = getClientsLabelList(clientsJournalList);
    var debitAmountList = getDebitAmountList(clientsJournalList);
    var creditAmountList = getCreditAmountList(clientsJournalList);

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
  });
}());

/**
 * クライアント別仕訳データ.
 *
 * @param {int} clientId クライアントID.
 * @param {array} journalList 仕訳データリスト.
 * @return {array} クライアント別仕訳データ.
 */
function getClientsJournalList(clientId, journalList) {
  var clientJournalList = [];
  journalList.forEach(function (journal) {
    if (clientId !== journal.client_id) {
      return;
    }
    clientJournalList.push(journal);
  });
  return clientJournalList;
}

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
