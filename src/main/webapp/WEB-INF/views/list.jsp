

<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>员工列表</title>
    <!-- 不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
        以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306),需要加上项目名
        http://localhost:3306/crud
    -->
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <!--  jQuery -->
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.0.0.min.js" charset="UTF-8"></script>

    <!--  引入样式  -->
    <!-- 最新版本的 Bootstrap 核心 CSS 文件   -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">


    <!-- 可选的 Bootstrap 主题文件（一般不用引入）-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

    <script type="text/javascript" src="${APP_PATH}/js/app.js"></script>


</head>
<body>
    <!-- 搭建显示页面  -->
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h1>SSM-CRUD</h1>
            </div>
        </div>

        <div class="row">
            <div class="col-md-2 col-md-offset-10">
                <button type="button" class="btn btn-primary">新增</button>
                <button type="button" class="btn btn-danger">删除</button>
            </div>
        </div>
        <br>
        <div class="row">
            <table class="table">
                <thead>
                    <tr>
                        <th><input type="checkbox"> </th>
                        <th>lastName</th>
                        <th>email</th>
                        <th>gender</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>

            </table>
        </div>
        <!-- 分页-->
        <div class="row">
            <div class="col-md-6"></div>
            <div class="col-md-5 col-md-offset-1">
                <nav aria-label="Page navigation">
                    <ul class="pagination"> </ul>
                </nav>
            </div>

        </div>
    </div>
</body>
</html>
