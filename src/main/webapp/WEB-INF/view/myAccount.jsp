<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>网上书店：读书使人进步</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/css/style.css" />
    <link rel="stylesheet" type="text/css" href="${ctx}/static/css/sweetalert2.min.css"/>
    <style>
        /*固定图片大小 使之与文字并排*/
        .feat_prod_box .prod_img img{
            width: 120px;
        }
        .new_prod_bg a img{
            width: 120px;
            height: 120px;
        }
        #menu ul li a span{
            color: rgb(236, 118, 90);
        }
        td{
            width: 75px;
            height: 20px;
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }
        table{
            table-layout: fixed;
            word-wrap: break-word;
        }
        .list li{
            width: 500px;
            height: 25px;
        }
        .right_box .pagination{
            width: 300px;
        }
    </style>
    <script src="${ctx}/static/js/showNotice.js"></script>
    <script src="${ctx}/static/js/jquery.min.js"></script>
    <script src="${ctx}/static/js/sweetalert2.min.js"></script>
    <script src="${ctx}/static/js/showTradeInfo.js"></script>
    <script>
        $(document).ready(function(){

            //分页ajax查询交易信息
            if ('${sessionScope.user}'!=''){
                $("#tradeInfoTitle").show();
                $("#tradeInfoTable").show();
                queryTradeInfo('${user.userId}');
                $("#lastPage").hide();
            }
            $("#nextPage").click(function () {
                $("#lastPage").show();
                var curPage = $("#trade_info_span").text()
                $("#trade_info_span").text(parseInt(curPage)+1);
                queryTradeInfo('${user.userId}');
                if ($("#trade_info_span").text()==$("#pageSize").text()){
                    $("#nextPage").hide();
                }
            })
            $("#lastPage").click(function () {
                $("#nextPage").show();
                var curPage = $("#trade_info_span").text()
                $("#trade_info_span").text(parseInt(curPage)-1);
                queryTradeInfo('${user.userId}');
                if ($("#trade_info_span").text()=='1'){
                    $("#lastPage").hide();
                }
            })
            //公告查询ajax
            queryNotice();
            //升级会员ajax
            $("#upgrade").click(function () {
                if (${sessionScope.user.userType=='管理员'}){
                    sweetAlert("","您是管理员无需升级","error");
                }else if(${sessionScope.user.userType=='普通会员'}){
                    swal({
                        text:"您确定花费100书币升级为VIP会员吗？",
                        showCancelButton: "true",
                        type: "info"
                    }).then(function(isConfirm){
                        if(isConfirm==true){
                            $.ajax({
                                url:"/user/userTypeUpdate",
                                data:{
                                    userId:$("#userId").val(),
                                    userType:"02",
                                    userBalance:"100",
                                },
                                type:"POST",
                                success:function (response) {
                                    swal({
                                        text: response.msg,
                                        type: response.flag,
                                        allowOutSideClick:"false"
                                    }).then(function (isConfirm) {
                                        if (isConfirm==true){
                                            window.location.href="/account/myAccount";
                                        }
                                    });
                                }
                            })
                        }
                    })
                }else if(${sessionScope.user.userType=='VIP会员'}){
                    swal({
                        text:"您确定花费10000书币升级为VIP会员吗？",
                        showCancelButton: "true",
                        type: "info"
                    }).then(function(isConfirm){
                        if(isConfirm==true){
                            $.ajax({
                                url:"/user/userTypeUpdate",
                                data:{
                                    userId:$("#userId").val(),
                                    userType:"00",
                                    userBalance:"10000"
                                },
                                type:"POST",
                                success:function (response) {
                                    swal({
                                        text: response.msg,
                                        type: response.flag,
                                        allowOutSideClick:"false"
                                    }).then(function (isConfirm) {
                                        if (isConfirm==true){
                                            window.location.href="/account/myAccount";
                                        }
                                    });
                                }
                            })
                        }
                    })
                }
            })
            //点击购物车校验
            $(".view_cart").click(function () {
                if (${empty sessionScope.user}){
                    swal({
                        text:"您尚未登录,请先登录",
                        type:"error"
                    });
                    return false;
                }else {
                    window.location.href = "/account/cart?userId=${sessionScope.user.userId}";
                }
            })
            $("#login").click(function () {
                var userName = $("#userName").val();
                var password = $("#password").val();
                if (userName === ""){
                    swal("","用户名不能为空","error");
                    return false;
                }
                if (password === ""){
                    swal("","密码不能为空","error");
                    return false;
                }
                var data = {"userName":userName,
                    "userPassword":password
                }
                $.ajax({
                    url:"/user/userLogin",
                    data:data,
                    type:"POST",
                    success:function (response) {
                        if(response.flag == '00'){
                            swal({
                                text:response.msg,
                                type:'success',
                                showConfirmButton:false,
                                allowOutsideClick:false
                            })
                            setTimeout("document.getElementById('goToHome').click()",2000);
                        }else if (response.flag == '-1'){
                            swal({
                                text:response.msg,
                                type:'error'
                            })
                            return false;
                        }
                    }
                })
            })
            $("#logout").click(function () {
                $.ajax({
                    url:"/user/userLogout",
                    success:function (response) {
                        if(response.flag == '00'){
                            swal({
                                text:response.msg,
                                type:'success',
                                showConfirmButton:false,
                                allowOutsideClick:false
                            })
                            setTimeout("document.getElementById('goToHome').click()",2000);
                        }
                    }
                })
            });
            if (${sessionScope.user.userType=='管理员'}){
                $(".manage_book").show();
                $(".manage_user").show();
            }else {
                $(".manage_book").hide();
                $(".manage_user").hide();
            }
            $("#recharge").click(function () {
                swal({
                    title:"请输入你要充值的书币<br/>(1书币=1人民币)",
                    html:"<span style='font-size: larger'>充值金额</span><input type='text'id='recharge_money'/>",
                    showCancelButton: "true",
                    type: "info",
                }).then(function(isConfirm){
                    var userBalance = parseInt($("#recharge_money").val())+parseInt(${user.userBalance});
                    var tradeMoney = $("#recharge_money").val();
                    if(isConfirm==true){
                        if ($("#recharge_money").val()===""){
                            swal("","充值金额不能为空","error");
                            return false;
                        }
                        var ex = /^\d+$/;
                        if (!ex.test($("#recharge_money").val())) {
                            swal("", "充值金额必须为整数", "error")
                            return false;
                            // 则为整数
                        }
                        $.ajax({
                            url:"/userBalance/add",
                            type:"POST",
                            data:{userId:'${user.userId}',userBalance:userBalance,tradeMoney:tradeMoney},
                            success:function (response) {
                                swal({
                                    text:response.msg,
                                    type:'success',
                                    showConfirmButton:false,
                                    allowOutsideClick:false
                                })
                                setTimeout("document.getElementById('goToMyAccount').click()",2000);
                            }
                        })
                    }
                })
            })
        })
    </script>
</head>
<body>
<div id="wrap">
    <div class="header">
        <div class="logo"><img src="${ctx}/static/images/logo.gif" border="0" /></div>
        <div id="menu">
            <ul>
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <li><a href="/account/myAccount"><span>亲，请登陆</span></a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a>欢迎${user.userName}登陆网上书店</a></li>
                    </c:otherwise>
                </c:choose>
                <li><a href="/home" id="goToHome">主页</a></li>
                <li><a href="/bookCategory/list">图书</a></li>
                <li><a href="/specialBook/list">促销书</a></li>
                <li class="selected"><a href="/account/myAccount?userId=${user.userId}" id="goToMyAccount">我的账户</a></li>
                <li><a href="/toRegister">注册</a></li>
                <li class="manage_user"><a href="/noticeManage">管理公告</a></li>
                <li class="manage_book"><a href="/bookCategory/bookManage">管理图书</a></li>
            </ul>
        </div>
    </div>
    <div class="center_content">
        <div class="left_content">
            <div class="title"><span class="title_icon"><img src="${ctx}/static/images/bullet1.gif"/></span>我的账户</div>
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <div class="feat_prod_box_details">
                        <p class="details"> </p>
                        <div class="contact_form">
                            <div class="form_subtitle">登录我的账户</div>
                            <form id="login_form">
                                <div class="form_row">
                                    <label class="contact"><strong>用户名:</strong></label>
                                    <input type="text" class="contact_input" id="userName"/>
                                </div>
                                <div class="form_row">
                                    <label class="contact"><strong>密码:</strong></label>
                                    <input type="password" class="contact_input" id="password"/>
                                </div>
                                <div class="form_row">
                                    <input type="button" class="register" value="登录" id="login"/>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="feat_prod_box_details">
                        <p class="details"> </p>
                        <div class="contact_form">
                            <div class="form_subtitle">我的账户</div>
                            <form action="#" id="myAccount">
                                <div class="form_row" style="display: none">
                                    <label class="contact"><strong>用户ID:</strong></label>
                                    <input type="text" class="contact_input" value="${user.userId}" readonly="readonly" id="userId"/>
                                </div>
                                <div class="form_row">
                                    <label class="contact"><strong>用户名:</strong></label>
                                    <input type="text" class="contact_input" value="${user.userName}" readonly="readonly"/>
                                </div>
                                <div class="form_row">
                                    <label class="contact"><strong>密码:</strong></label>
                                    <input type="text" class="contact_input" value="${user.userPassword}" readonly="readonly"/>
                                </div>
                                <div class="form_row">
                                    <label class="contact"><strong>会员类型:</strong></label>
                                    <input type="text" class="contact_input" value="${user.userType}" readonly="readonly"/>
                                    <a href="javascript:void(0)" id="upgrade">升级</a>
                                </div>
                                <div class="form_row">
                                    <label class="contact"><strong>账户余额:</strong></label>
                                    <input type="text" class="contact_input" value="${user.userBalance}" id="user_balance" readonly="readonly"/>
                                    <a href="javascript:void(0)" id="recharge">充值</a>
                                </div>
                                <div class="form_row">
                                    <label class="contact"><strong>手机:</strong></label>
                                    <input type="text" class="contact_input" value="${user.userMobile}" readonly="readonly"/>
                                </div>
                                <div class="form_row">
                                    <label class="contact"><strong>地址:</strong></label>
                                    <input type="text" class="contact_input" value="${user.userAddr}" readonly="readonly"/>
                                </div>
                                <div class="form_row">
                                    <label class="contact"><strong>邮箱:</strong></label>
                                    <input type="text" class="contact_input" value="${user.userEmail}" readonly="readonly"/>
                                </div>
                                <div class="form_row">
                                    <input type="button" class="register" value="注销" id="logout"/>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
            <div class="title" style="display:none" id="tradeInfoTitle">
                <span class="title_icon"><img src="${ctx}/static/images/bullet1.gif"/></span>交易记录
            </div>
            <div class="feat_prod_box_details" style="display:none" id="tradeInfoTable">
                <table class="cart_table">
                    <tr class="cart_title">
                        <td>交易单号</td>
                        <td>用户昵称</td>
                        <td>交易时间</td>
                        <td>交易金额</td>
                        <td>交易类型</td>
                        <td style="display: none" id="pageSize"></td>
                    </tr>

                </table>
                <div class="pagination">
                    <a id="lastPage"><</a>
                    <span class="current" id="trade_info_span">1</span>
                    <a id="nextPage">></a>
                </div>
            </div>
            <div class="clear"></div>
            <div class="clear"></div>
        </div>
        <!--end of left content-->
        <div class="right_content">
            <div class="languages_box">
            </div>
            <div class="currency"></div>
            <div class="cart">
                <div class="title"><span class="title_icon"><img src="${ctx}/static/images/cart.gif" /></span>购物车</div>
                <a href="#" class="view_cart">进入购物车</a> </div>
            <div class="title"><span class="title_icon"><img src="${ctx}/static/images/bullet3.gif" /></span>关于我们商店</div>
            <div class="about">
                <p> <img src="${ctx}/static/images/about.gif" class="right" />顾名思义，网站式的书店。是一种高质量，更快捷，更方便的购书方式。网上书店不仅可用于图书的在线销售，也有音碟、影碟的在线销售。而且网站式的书店对图书的管理更加合理化，信息化。售书的同时还具有书籍类商品管理、购物车、订单管理、会员管理等功能，非常灵活的网站内容和文章管理功能。</p>
            </div>
            <div class="right_box">
                <div class="title"><span class="title_icon"><img src="${ctx}/static/images/bullet5.gif"  /></span>公告栏</div>
                <ul class="list">
                </ul>
                <div class="pagination">
                    <a id="notice_last_page"><</a>
                    <span class="current" id="notice_span">1</span>
                    <span id="notice_pageSize" style="display: none"></span>
                    <a id="notice_next_page">></a>
                </div>
            </div>
        </div>
        <!--end of right content-->
        <div class="clear"></div>
    </div>
    <!--end of center content-->
    <div class="footer">
        <div class="left_footer"><img src="${ctx}/static/images/footer_logo.gif" /><br />
        </div>
        <div class="right_footer"> <a href="#">主页</a> <a href="#">关于我们</a> <a href="#">售后服务</a> <a href="#">隐私政策</a> <a href="#">联系我们</a> </div>
    </div>
</div>
<script>
    function queryTradeInfo(userId) {
        $.ajax({
            url:"/tradeInfo/queryList",
            data:{userId:userId,currPage:$("#trade_info_span").text()},
            type:"POST",
            success:function (response) {
                $("#pageSize").text(response.msg);
                $(".book_content").remove();
                showTradeInfo(response);
            }
        })
    }
</script>
</body>
</html>
