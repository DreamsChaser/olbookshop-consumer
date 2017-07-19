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
        .list li{
            width: 500px;
            height: 25px;
        }
        .right_box .pagination{
            width: 300px;
        }
    </style>
    <script src="${ctx}/static/js/jquery.min.js"></script>
    <script src="${ctx}/static/js/showNotice.js"></script>
    <script src="${ctx}/static/js/showBookInfo.js"></script>
    <script src="${ctx}/static/js/sweetalert2.min.js"></script>
    <script>
        $(document).ready(function(){
            if (${sessionScope.user.userType=='管理员'}){
                $(".manage_book").show();
                $(".manage_user").show();
            }else {
                $(".manage_book").hide();
                $(".manage_user").hide();
            }
            //公告查询ajax
            queryNotice();
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
            //分页查询促销书
            var curPage = $("#spe_span").text();
            $("#lastPage").hide();
            $.ajax({
                url:"/actBooks/list?bookAct=02&curPage="+curPage,
                success:function (response) {
                    showBookInfo(response);
                }
            });
            $("#nextPage").click(function () {
                $("#lastPage").show();
                var curPage = parseInt($("#spe_span").text())+1;
                $("#spe_span").text(curPage);
                $.ajax({
                    url:"/actBooks/list?bookAct=02&curPage="+curPage,
                    success:function (response) {
                        $(".feat_prod_box").remove();
                        showBookInfo(response);
                        if ($("#spe_span").text() == response.msg){
                            $("#nextPage").hide();
                        }
                    }
                })
            })
            $("#lastPage").click(function () {
                var curPage = parseInt($("#spe_span").text())-1;
                $("#spe_span").text(curPage);
                $("#nextPage").show();
                $.ajax({
                    url:"/actBooks/list?bookAct=02&curPage="+curPage,
                    success:function (response) {
                        $(".feat_prod_box").remove();
                        showBookInfo(response);
                        if ($("#spe_span").text() == 1){
                            $("#lastPage").hide();
                        }
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
                <li><a href="/home">主页</a></li>
                <li><a href="/bookCategory/list">图书</a></li>
                <li class="selected"><a href="/specialBook/list">促销书</a></li>
                <li><a href="/account/myAccount?userId=${user.userId}">我的账户</a></li>
                <li><a href="/toRegister">注册</a></li>
                <li class="manage_user"><a href="/noticeManage">管理公告</a></li>
                <li class="manage_book"><a href="/bookCategory/bookManage">管理图书</a></li>
            </ul>
        </div>
    </div>
    <div class="center_content">
        <div class="left_content">
            <div class="title" id="feat_prod_box_head">
                <span class="title_icon">
                    <img src="${ctx}/static/images/bullet1.gif"/>
                </span>促销书
            </div>
            <div class="pagination">
                <a href="#" id="lastPage"><</a>
                <span class="current" id="spe_span">1</span>
                <a href="#" id="nextPage">></a>
            </div>
            <div class="clear"></div>
        </div>
        <!--end of left content-->
        <!--end of left content-->
        <div class="right_content">
            <div class="languages_box">
            </div>
            <div class="currency"></div>
            <div class="cart">
                <div class="title"><span class="title_icon"><img src="${ctx}/static/images/cart.gif" /></span>购物车</div>
                <%--<div class="home_cart_content"> 数量: 3  | <span class="red">总价: ￥100</span> </div>--%>
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
</body>
</html>

