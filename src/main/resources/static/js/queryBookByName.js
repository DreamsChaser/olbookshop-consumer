function queryBookByName(response) {
    var bookArr = response.data;
    var totalHtml = "";
    for(var i = 0;i<bookArr.length;i++){
        var showHtml = '<div class="new_prod_box">' +
            '<a href="/bookCategory/details?bookId='+bookArr[i].bookId+'">'+bookArr[i].bookName+'</a>'+
            '<div class="new_prod_bg">'+
            '<a href="/bookCategory/details?bookId='+bookArr[i].bookId+'">' +
            '<img src="/book/bookImage?bookId='+bookArr[i].bookId+'" class="thumb" border="0" />' +
            '</a>'+
            '</div>'+
            '</div>';
        totalHtml = totalHtml+showHtml;
    }
    $(".new_products").html(totalHtml);
}