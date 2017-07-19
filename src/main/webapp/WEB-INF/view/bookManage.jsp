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
        #passwordAlarm{
            color: red;
        }
        #menu ul li a span{
            color: rgb(236, 118, 90);
        }
        #select_act{
            height:0px;
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
    <script src="${ctx}/static/js/sweetalert2.min.js"></script>
    <script>
        $(document).ready(function(){

            if(${ajaxVO.flag=='00'}){
                swal({
                    text:'${ajaxVO.msg}',
                    type:'success'
                })
            }else if (${ajaxVO.flag=='-1'}){
                swal({
                    text:'${ajaxVO.msg}',
                    type:'error'
                })
            }
            if (${sessionScope.user.userType=='管理员'}){
                $(".manage_book").show();
                $(".manage_user").show();
            }else {
                $(".manage_book").hide();
                $(".manage_user").hide();
            }
            //编辑书本
            if ('${type}'=='modify'){
                $.ajax({
                    url:"/book/queryBook",
                    data:{bookId:'${bookId}'},
                    type:"POST",
                    success:function (response) {
                        $("#bookId").val(response.obj.bookId);
                        $("#bookName").val(response.obj.bookName);
                        $("#bookNum").val(response.obj.bookNum);
                        $("#bookPrice").val(response.obj.bookPrice);
                        $("#bookAct").val(response.obj.bookAct);
                        $("#bookDesc").val(response.obj.bookDesc);
                        $("#bookMoreDesc").val(response.obj.bookMoreDesc);
                        $("#bookSpePrice").val(response.obj.bookSpePrice);
                        if (response.obj.bookAct == '02') {
                            $("#spe_price_div").show();
                        }
                    }
                })
            }
            //选择促销活动的书
            $("#bookAct").change(function () {
                if($("#bookAct option:selected").val() == 02){
                    $("#spe_price_div").show();
                }else {
                    $("#spe_price_div").hide();
                }
            })
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
            $("#addBookButton").click(function () {
                if ($("#bookName").val()===""){
                    swal("","书名不能为空","error");
                    return false;
                }
                if ($("#bookPrice").val()===""){
                    swal("","价格不能为空","error");
                    return false;
                }
                if(isNaN($("#bookPrice").val())){
                    swal("","价格必须为数字","error");
                    return false;
                }
                var ex = /^\d+$/;
                if (!ex.test($("#bookPrice").val())) {
                    swal("","价格必须为整数","error")
                    return false;
                    // 则为整数
                }
                if($("#bookAct option:selected").val() == 02) {
                    if (!ex.test($("#bookSpePrice").val())) {
                        swal("", "惊爆价必须为整数", "error")
                        return false;
                        // 则为整数
                    }
                }
                if ($("#bookNum").val()===""){
                    swal("","数量不能为空","error");
                    return false;
                }
                if(isNaN($("#bookNum").val())){
                    swal("","数量必须为数字","error");
                    return false;
                }
                if ($("#bookDesc").val()===""){
                    swal("","图书描述不能为空","error");
                    return false;
                }
                if ($("#bookMoreDesc").val()===""){
                    swal("","详尽描述不能为空","error");
                    return false;
                }
                if ($("#bookImg").val()===""){
                    swal("","上传图片不能为空","error");
                    return false;
                }
                $("#add_book_form").submit();
            })
        });

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
                <li><a href="/account/myAccount?userId=${user.userId}">我的账户</a></li>
                <li><a href="/toRegister">注册</a></li>
                <li class="manage_user"><a href="/noticeManage">管理公告</a></li>
                <li class="manage_book selected"><a href="/bookCategory/bookManage">管理图书</a></li>
            </ul>
        </div>
    </div>
    <div class="center_content">
        <div class="left_content">
            <div class="title"><span class="title_icon"><img src="${ctx}/static/images/bullet1.gif" /></span>管理</div>
            <div class="feat_prod_box_details">
                <p class="details"> </p>
                <div class="contact_form">
                    <div class="form_subtitle">添加书本</div>
                    <form name="addBook" id="add_book_form" enctype="multipart/form-data" method="post" action="/book/addBook">
                        <div class="form_row" style="display:none;">
                            <label class="contact"><strong>书号:</strong></label>
                            <input type="text" class="contact_input" name="bookId" id="bookId"/>
                        </div>
                        <div class="form_row">
                            <label class="contact"><strong>书名:</strong></label>
                            <input type="text" class="contact_input" name="bookName" id="bookName"/>
                        </div>
                        <div class="form_row">
                            <label class="contact"><strong>价格:</strong></label>
                            <input type="text" class="contact_input" name="bookPrice" id="bookPrice"/>
                        </div>
                        <div class="form_row">
                            <label class="contact"><strong>数量:</strong></label>
                            <input type="text" class="contact_input" name="bookNum" id="bookNum"/>
                        </div>
                        <div class="form_row" id="select_act">
                            <label class="contact"><strong>活动类型:</strong></label>
                            <select name="bookAct" id="bookAct">
                                <%--jsp 获取map值('${freePriceFlagMap['Y']}');--%>
                                <c:forEach items="${actMap}" var="act">
                                    <option value="${act['key']}">${act['value']}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form_row" style="display: none" id="spe_price_div">
                            <label class="contact"><strong>惊爆价:</strong></label>
                            <input type="text"  class="contact_input" name="bookSpePrice" id="bookSpePrice"/>
                        </div>
                        <div class="form_row">
                            <label class="contact"><strong>图书描述:</strong></label>
                            <input type="text"  class="contact_input" name="bookDesc" id="bookDesc"/>
                        </div>
                        <div class="form_row">
                            <label class="contact"><strong>详尽描述:</strong></label>
                            <input type="text"  class="contact_input" name="bookMoreDesc" id="bookMoreDesc"/>
                        </div>
                        <div class="form_row">
                            <label class="contact"><strong>上传图片:</strong></label>
                            <input type="file" class="" name="bookImg" id="bookImg"/>
                        </div>
                        <div class="form_row">
                            <input type="button" class="register" value="保存" name="addBookButton" id="addBookButton"/>
                        </div>
                    </form>
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
</html>
