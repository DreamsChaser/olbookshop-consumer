function queryNotice() {
    show();
    $("#notice_last_page").hide();
    $("#notice_last_page").click(function () {
        $("#notice_next_page").show();
        var currPage = $("#notice_span").text();
        $("#notice_span").text(parseInt(currPage)-1);
        show();
        if ($("#notice_span").text()=='1'){
            $("#notice_last_page").hide();
        }
    })
    $("#notice_next_page").click(function () {
        $("#notice_last_page").show();
        var currPage = $("#notice_span").text();
        $("#notice_span").text(parseInt(currPage)+1);
        show();
        if ($("#notice_span").text()==$("#notice_pageSize").text()){
            $("#notice_next_page").hide();
        }
    })
}

function show() {
    $.ajax({
        url:"/notice/findAll",
        data:{currPage:$("#notice_span").text()},
        type:"POST",
        success:function (response) {
            $("#notice_pageSize").text(response.msg);
            var noticeArr = response.data;
            var html="";
            for(var i = 0;i<noticeArr.length;i++){
                var showHtml = '<li><a href="/noticeDetail?noticeId='+noticeArr[i].noticeId+'" id="notice">'+noticeArr[i].noticeTitle+':'+noticeArr[i].noticeTime+'</a></li>';
                html+=showHtml;
            }
            $(".list").html(html);
        }
    })
}