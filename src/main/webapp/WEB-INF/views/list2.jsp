

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
                <tr>
                    <th>#</th>
                    <th>lastName</th>
                    <th>email</th>
                    <th>gender</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr>
                        <th>${emp.empId}</th>
                        <th>${emp.empName}</th>
                        <th>${emp.gender=="m"?"男":"女"}</th>
                        <th>${emp.email}</th>
                        <th>${emp.department.deptName}</th>
                        <th>
                            <button type="button" class="btn btn-primary btn-sm" aria-label="Left Align">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true">编辑</span>
                            </button>
                            <button type="button" class="btn btn-danger btn-sm" aria-label="Left Align">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true">删除</span>
                            </button>
                        </th>
                    </tr>
                </c:forEach>
            </table>
        </div>
        <!-- 分页-->
        <div class="row">
            <div class="col-md-6">
                <br>
                <h4>
                当前第&nbsp;${pageInfo.pageNum}&nbsp;页&nbsp;&nbsp;&nbsp;
                总&nbsp;${pageInfo.pages}&nbsp;页&nbsp;&nbsp;&nbsp;
                总记录&nbsp;${pageInfo.total}&nbsp;条
                </h4>
            </div>
            <div class="col-md-5 col-md-offset-1">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <c:if test="${pageInfo.pageNum!=1}">
                            <li><a href="${APP_PATH}/emps?pn=1">首页</a> </li>
                        </c:if>
                        <c:if test="${pageInfo.pageNum!=1}">
                            <li>
                                <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${pageInfo.pageNum==1}">
                            <li class="disabled">
                                <a href="${APP_PATH}/emps?pn=1" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                            <c:if test="${page_Num==pageInfo.pageNum}">
                                <li class="active"><a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a></li>
                            </c:if>
                            <c:if test="${page_Num!=pageInfo.pageNum}">
                                <li><a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a></li>
                            </c:if>
                        </c:forEach>

                        <c:if test="${pageInfo.pageNum!=pageInfo.pages}">
                            <li>
                                <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${pageInfo.pageNum==pageInfo.pages}">
                            <li class="disabled">
                                <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <c:if test="${pageInfo.pageNum!=pageInfo.pages}">
                            <li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a> </li>
                        </c:if>

                    </ul>
                </nav>
            </div>

        </div>
    </div>
</body>
</html>
