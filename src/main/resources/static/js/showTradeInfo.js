/**
 * Created by Administrator on 2017/5/16.
 */
function showTradeInfo(response) {
    var tradeInfoArr = response.data;
    for(var i = 0;i<tradeInfoArr.length;i++){
        var showHtml = '<tr class="book_content">' +
            '<td title="'+tradeInfoArr[i].tradeId+'">'+tradeInfoArr[i].tradeId+'</td>'+
            '<td title="'+tradeInfoArr[i].userId+'">'+tradeInfoArr[i].userId+'</td>'+
            '<td title="'+tradeInfoArr[i].tradeTime+'">'+tradeInfoArr[i].tradeTime+'</td>'+
            '<td title="'+tradeInfoArr[i].tradeMoney+'">'+tradeInfoArr[i].tradeMoney+'</td>'+
            '<td title="'+tradeInfoArr[i].tradeType+'">'+tradeInfoArr[i].tradeType+'</td>'+
            '</tr>';
        $(".cart_title").after(showHtml);
    }
}