<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>网上书店：读书使人进步</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/css/style.css" />
    <link rel="stylesheet" type="text/css" href="${ctx}/static/css/sweetalert2.min.css"/>
    <link rel="stylesheet" href="${ctx}/static/css/lightbox.css" type="text/css" media="screen" />
    <script type="text/javascript" src="${ctx}/static/js/java.js"></script>
    <script src="${ctx}/static/js/sweetalert2.min.js"></script>
    <script src="${ctx}/static/js/showNotice.js"></script>
    <style>
        /*固定图片大小 使之与文字并排*/
        .prod_img img{
            width: 120px;
        }
        .new_prod_bg a img{
            width: 120px;
            height: 120px;
        }
        #book_spe_price{
            color: red;
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
    <script>
        $(document).ready(function(){
            if (${sessionScope.user.userType=='管理员'}){
                $(".manage_book").show();
                $(".manage_user").show();
                $("#delete_book").show();
                $("#modify_book").show();
            }else {
                $(".manage_book").hide();
                $(".manage_user").hide();
                $("#delete_book").hide();
                $("#modify_book").hide();
            }
            //促销书显示特价
            if('${book.bookAct}'=='02'){
                $("#book_spe_price").show();
                $("#book_org_price").css("text-decoration","line-through");
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
            $(".more").click(function () {
                if (${empty sessionScope.user}) {
                    swal({
                        text: "您尚未登录,请先登录",
                        type: "error"
                    });
                    return false;
                }
                if ('${sessionScope.user.userType}'=='普通会员'&&'${book.bookAct}'=='02') {
                    swal({
                        text: "只有VIP会员才能购买特价书籍,请先升级为VIP会员",
                        type: "error"
                    });
                    return false;
                } else {
                    swal({
                        title:"是否加入购物车?",
                        html:"<span style='font-size: larger'>请输入你要购买的数量</span><input type='text'id='book_num'/>",
                        showCancelButton: "true",
                        type: "info",
                    }).then(function(isConfirm){
                        if(isConfirm==true){
                            var ex = /^\d+$/;
                            if (!ex.test($("#book_num").val())) {
                                swal("", "数量必须为整数", "error")
                                return false;
                                // 则为整数
                            }
                            if ($("#book_num").val()>${book.bookNum}){
                                swal({
                                    text: "库存不足，请联系管理员进货",
                                    type: "error"
                                })
                            }else {
                                $.ajax({
                                    url:"/cart/addToCart",
                                    data:{
                                        bookNum:$("#book_num").val(),
                                        bookId:'${book.bookId}',
                                        userId:'${user.userId}',
                                    },
                                    success:function (response) {
                                        swal({
                                            text:response.msg,
                                            type:'success'
                                        });
                                    }
                                })
                            }
                        }
                    })
                }
            })
            $("#delete_book").click(function () {
                swal({
                    text:"是否确定删除？",
                    type:"question",
                    showCancelButton:true
                }).then(function(isConfirm) {
                    if (isConfirm == true) {
                        $.ajax({
                            url:"/book/deleteBook",
                            data:{bookId:'${book.bookId}'},
                            type:"POST",
                            success:function (response) {
                                swal({
                                    text:response.msg,
                                    type:response.flag,
                                    showConfirmButton:false,
                                    allowOutsideClick:false
                                })
                                setTimeout("document.getElementById('goToHome').click()",2000);
                            }
                        })
                    }
                })
            })
            $("#modify_book").click(function () {
                window.location.href = "/bookCategory/modify?bookId=${book.bookId}";
            })
        })
    </script>
</head>
<body>
<div id="wrap">
    <div class="header">
        <div class="logo">
            <img src="${ctx}/static/images/logo.gif" border="0" />
        </div>
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
                <li class="selected"><a href="/home" id="goToHome">主页</a></li>
                <li><a href="/bookCategory/list">图书</a></li>
                <li><a href="/specialBook/list">促销书</a></li>
                <li><a href="/account/myAccount?userId=${user.userId}">我的账户</a></li>
                <li><a href="/toRegister">注册</a></li>
                <li class="manage_user"><a href="/noticeManage">管理公告</a></li>
                <li class="manage_book"><a href="/bookCategory/bookManage">管理图书</a></li>
            </ul>
        </div>
    </div>
    <div class="center_content">
        <div class="left_content">
            <div class="title">
                <span class="title_icon"><img src="${ctx}/static/images/bullet1.gif"/></span>${book.bookName}
            </div>
            <div class="feat_prod_box_details">
                <div class="prod_img"><img src="/book/bookImage?bookId=${book.bookId}" border="0" />
                    <br/>
                    <br/>
                    <input type="button" value="编辑" id="modify_book" style="display: none"/>
                    <input type="button" value="删除" id="delete_book" style="display: none"/>
                    <%--<a href="${ctx}images/big_pic.jpg" rel="lightbox"><img src="${ctx}/static/images/zoom.gif"  border="0" /></a>--%>
                    </div>
                <div class="prod_det_box">
                    <div class="box_top"></div>
                    <div class="box_center">
                        <div class="prod_title">详情</div>
                        <p class="details">${book.bookDesc}</p>
                        <div class="price"><strong >价格:</strong> <span class="red" id="book_org_price">${book.bookPrice}书币</span></div>
                        <div class="price" style="display: none" id="book_spe_price"><strong>惊爆价:</strong> <span class="red">${book.bookSpePrice}书币</span></div>
                        <div class="price"><strong>库存:</strong> <span class="red">${book.bookNum}本</span></div>
                        <a href="#" class="more"><img src="${ctx}/static/images/addCart.png" border="0" /></a>
                        <div class="clear"></div>
                    </div>
                    <div class="box_bottom"></div>
                </div>
                <div class="clear"></div>
            </div>
            <div id="demo" class="demol ayout">
                <ul id="demo-nav" class="demolayout">
                    <li><a class="active" href="#tab1">更多详情</a></li>
                    <%--<li><a class="" href="#tab2">相关书籍</a></li>--%>
                </ul>
                <div class="tabs-container">
                    <div style="display: block;" class="tab" id="tab1">
                        <p class="more_details">${book.bookDesc}</p>
                        <p class="more_details">${book.bookMoreDesc}</p>
                    </div>
                </div>
            </div>
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
</body>
<script type="text/javascript">

    var tabber1 = new Yetii({
        id: 'demo'
    });

</script>
</html>
