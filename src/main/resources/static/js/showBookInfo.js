/**
 * Created by Administrator on 2017/5/12.
 */
/**
 * 将ajax返回的json数据循环插入到表格中显示
 */
function showBookInfo(response) {
    var bookArr = response.data;
    // var host = document.location.host;
    for(var i = 0;i<bookArr.length;i++){
        var showHtml = '<div class="feat_prod_box">' +
            '<div class="prod_img">' +
            '<img src="/book/bookImage?bookId='+bookArr[i].bookId+'" border="0" />' +
            '</div>' +
            '<div class="prod_det_box">' +
            '<span class="special_icon">' +
            '<img src="../static/images/special_icon.gif" />' +
            '</span>' +
            '<div class="box_top"></div> ' +
            '<div class="box_center"> ' +
            '<div class="prod_title">'+bookArr[i].bookName+'</div> ' +
            '<p class="details">'+bookArr[i].bookDesc+'</p> ' +
            '<a href="/bookCategory/details?bookId='+bookArr[i].bookId+'" class="more">- 更多详情 -</a> ' +
            '<div class="clear"></div> ' +
            '</div> ' +
            '<div class="box_bottom"></div> ' +
            '</div> ' +
            '<div class="clear"></div> ' +
            '</div>';
        $("#feat_prod_box_head").after(showHtml);
    }
}