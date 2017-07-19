/**
 * Created by Administrator on 2017/5/15.
 */
function showNewBookInfo(response) {
    var bookArr = response.data;
    var totalHtml = "";
    // var host = document.location.host;
    for(var i = 0;i<bookArr.length;i++){
        var showHtml = '<div class="new_prod_box">' +
            '<a href="/bookCategory/details?bookId='+bookArr[i].bookId+'">'+bookArr[i].bookName+'</a>'+
            '<div class="new_prod_bg">'+
            '<span class="new_icon">' +
            '<img src="../static/images/new_icon.gif"/>' +
            '</span>'+
            '<a href="/bookCategory/details?bookId='+bookArr[i].bookId+'">' +
            '<img src="/book/bookImage?bookId='+bookArr[i].bookId+'" class="thumb" border="0" />' +
            '</a>'+
            '</div>'+
            '</div>';
        totalHtml = totalHtml+showHtml;
    }
    $("#hot_prod_box_head").html(totalHtml);
}