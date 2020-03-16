<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<html>
<head>
    <title>员工列表</title>
    <!--
        不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
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

    <script type="text/javascript">

        var totalRecord ;
        var toPageNum;
        var pageSize;
        $(function () {
            to_page(1)
            //新增
            $("#add_input").click(function () {
                //清空表单
                $("#emp_add_form>form")[0].reset();
                //清空表单样式
                $("#emp_add_form>form").find("*").removeClass("has-error has-success");


                //查询出所有部门并显示在下拉列表
               getDept('#select_add_input')
                $("#table_add_emp").modal(function () {
                    backdrop:"static"
                });

            })



            //新增
            $("#save_add").click(function(){
                //先校验表单
                if(!validate_add_form()){

                    return false;
                }
                if($("#save_add").attr("vi-ajax")=="error"){
                    return false;
                }



                $.post(
                    "${APP_PATH}"+ "/emp",
                    $('#table_add_emp form').serialize(),
                    function (result) {

                        //关闭模态框
                        $("#table_add_emp").modal('hide');

                        //去最后一页
                        to_page(totalRecord)

                    }

                )

            })

            //后端校验
            $("#empName_add_input").change(function () {
                var empName = $("#empName_add_input").val();
                $.getJSON(
                    "${APP_PATH}/validateName",
                    "empName="+empName,
                    function (result) {
                        if(result.code==100){
                            validate_add_msg("#empName_add_input","success",result.extend.vi)
                            $("#save_add").attr("vi-ajax","success")
                        }else{
                            validate_add_msg("#empName_add_input","error",result.extend.vi)
                            $("#save_add").attr("vi-ajax","error")
                        }

                    }
                )
            })
            editEmp();
            deleteEmp ();
            deleteAll()
        })

        //单个删除
        function deleteEmp () {
            $(document).on("click","button.delete_btn",function () {
                var empName = $(this).parent().parent().find("td:eq(2)").text();
                var id = $(this).attr("emp_id")
                if(confirm("确认删除【"+empName+"】")){
                    $.ajax({
                        url: "${APP_PATH}/emp/"+ id,
                        type:"DELETE",
                        success:function (result) {
                            to_page(toPageNum)
                        }

                    })



                }
            })

        }

        //批量删除
        function deleteAll() {
            //全选/全不选
            $("#checkAll").click(function () {
                //prop修改和读取dom原生属性的值
              $(".check_item").prop("checked",$(this).prop("checked"))
            })
            $(document).on("click",".check_item",function () {
                /*
                if($(".check_item:checked").length == $(".check_item").length){
                    $("#checkAll").prop("checked",true);
                }else{
                    $("#checkAll").prop("checked",false);
                }*/
                var flag = $(".check_item:checked").length == $(".check_item").length
                $("#checkAll").prop("checked",flag)
            })
            $("#delete_input").click(function () {
                var empNames = "";
                var ids = "";
                $.each($(".check_item:checked"),function () {
                    empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
                    ids += $(this).parents("tr").find("td:eq(1)").text() + "-";
                })
                empNames = empNames.substr(0,empNames.length-1);
                ids = ids.substr(0,ids.length-1);
                if(confirm("您要删除【"+empNames+"】")){
                    $.ajax({
                        url:"${APP_PATH}/emp/"+ids,
                        type:"DELETE",
                        success:function (result) {
                            to_page(toPageNum);
                        }
                    })
                }

            })

        }









        //修改
        function editEmp(){
            //记录id
            var id;

            //1.给按钮加点击事件
           $(document).on('click','button.edit_btn',function () {
                    //2、显示下拉列表
                    $("#select_edit_input").empty();
                    getDept('#select_edit_input')
                    //3、回显数据
                    id = $(this).attr("emp_id")
                    getEmp(id)
                    //4、显示模态框
                    $('#table_edit_emp').modal(function () {
                        backdrop:"static"
                    });
            })
            $("#email_edit_input").change(function () {
                var email = $("#email_edit_input").val();
                var regEmail = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/
                if(!regEmail.test(email)){
                    validate_add_msg("#email_edit_input","error","请输入合法的邮箱地址!")
                    $("#save_edit").attr("edit-vi","error")
                }else {
                    validate_add_msg("#email_edit_input", "success", "")
                    $("#save_edit").attr("edit-vi","success")
                }
            })
            $("#save_edit").click(function () {
                var vi = $("#save_edit").attr("edit-vi")
                if(vi=="success")
                    $.ajax({
                            url : "${APP_PATH}/emp/"+id,
                            type : 'PUT',
                            data : $('#table_edit_emp form').serialize(),
                            success : function (result) {

                                //关闭模态框
                                $("#table_edit_emp").modal('hide');

                                //去最后一页
                                to_page(toPageNum)
                            }

                        }

                    )



            })









        }
        //回显数据
        function getEmp(id) {
            $.getJSON(
                "${APP_PATH}/emp/"+id,
                function (result) {
                    var employee = result.extend.employee;
                    $('#empName_edit_input').text(employee.empName);
                    $('#email_edit_input').val(employee.email);
                    $('#table_edit_emp input[type="radio"]').val([employee.gender]);
                    $('#table_edit_emp select').val([employee.dId])

                }
            )
        }

        //查询出所有部门并显示在下拉列表
        function getDept(ele) {
            $.getJSON(
                "${APP_PATH}"+"/getDept",
                function (result) {
                    $.each(result.extend.depts,function () {
                     //  $('#select_add_input').append($('<option></option>').attr("value",dept.deptId).append(dept.deptName))
                        $(ele).append($('<option></option>').attr("value",this.deptId).append(this.deptName))
                    })
                }
            )


        }

        //前端校验校验方法
        function validate_add_form(){
              //校验用户名
              var empName = $("#empName_add_input").val();
              var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/
             if(!regName.test(empName)){
                 validate_add_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文和数字的组合!")
                 return false;
             }else {
                 validate_add_msg("#empName_add_input","success","")

             }

             //校验邮箱信息
              var email = $("#email_add_input").val();
             var regEmail = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/
              if(!regEmail.test(email)){
                  validate_add_msg("#email_add_input","error","请输入合法的邮箱地址!")

                  return false;
              }else {
                  validate_add_msg("#email_add_input","success","")
              }
              return true;
        }

        //校验信息
        function validate_add_msg(ele,status,msg) {
            if("error"==status){
                $(ele+"+span").remove()
                $(ele).parent().removeClass("has-success")
                $(ele).parent().addClass("has-error");
                $(ele).after($("<span></span>").addClass("help-block").text(msg))


            }else if("success"==status){
                $(ele+"+span").remove()
                $(ele).parent().removeClass("has-error")
                $(ele).parent().addClass("has-success")
                $(ele).after($("<span></span>").addClass("help-block").text(msg))


            }

        }







        function to_page(pn) {
                $.getJSON(
                    "${APP_PATH}"+"/emps",
                    {pn:pn},
                    function (result) {
                        //1.解析并显示员工数据
                        build_emps_table(result)

                        //2.解析并显示分页信息
                        build_page_info(result)

                        //3.解析显示分页条数据
                        build_page_nav(result);

                        //4.清空多选框
                        $("#checkAll").prop("checked","")

                    },JSON

                )

            }




            function build_emps_table(result) {
                $('#emps_table>tbody').empty();
                var emps = result.extend.pageInfo.list
                $.each(emps,function (index,item) {
                    var checkTd =$("<td><input type='checkbox' class='check_item'></td>")
                    var empIdTd = $('<td></td>').append(item.empId)
                    var empNameTd = $('<td></td>').append(item.empName)
                    var genderTd = $('<td></td>').append(item.gender=='m'?"男":"女")
                    var emailTd = $('<td></td>').append(item.email)
                    var depatNameTd = $('<td></td>').append(item.department.deptName)

                    var editBtn =$('<button></button>').addClass("btn btn-primary btn-sm ").append($("<span></span>").addClass( 'glyphicon glyphicon-pencil').append("编辑")).addClass("edit_btn").attr("emp_id",item.empId)
                    var deleteBtn = $('<button></button>').addClass("btn btn-danger btn-sm ").append($("<span></span>").addClass( 'glyphicon glyphicon-trash').append("删除")).addClass("delete_btn").attr("emp_id",item.empId)
                    var tdBtn = $("<td></td>")
                    tdBtn.append(editBtn).append(" ").append(deleteBtn)
                    $('<tr></tr>').append(checkTd).append(empIdTd)
                        .append(empNameTd).append(emailTd).append(genderTd).append(depatNameTd)
                        .append(tdBtn)
                        .appendTo('#emps_table>tbody')
                })
            }


            function build_page_info(result) {

                    var pageInfo = result.extend.pageInfo;
                    var $area = $('#page_info_area');
                    $area.empty().append('<br>').append("<h4></h4>").append("当前第 "+ pageInfo.pageNum +" 页   总 "+pageInfo.pages+" 页    总记录数 " + pageInfo.total + " 条")

                    totalRecord = pageInfo.total
                    toPageNum = pageInfo.pageNum



            }

            function   build_page_nav(result){
                $('#page_info_artice').empty();
                var firstPage = $('<li></li>').append($('<a></a>').append("首页"));
                var previous = $('<li></li>').append($("<a></a>").attr("aria-label","Previous").append($("<span></span>").append("&laquo;")))
                var next = $('<li></li>').append($("<a></a>").attr("aria-label","Previous").append($("<span></span>").append("&raquo;")))
                var lastPage = $('<li></li>').append($('<a></a>').append("末页"));




                if(result.extend.pageInfo.pageNum===1){
                        firstPage.addClass("disabled")
                        previous.addClass("disabled")
                }else{
                    firstPage.click(function () {
                        to_page(1)
                    })
                    previous.click(function () {
                        to_page(result.extend.pageInfo.pageNum-1)
                    })
                }

                if(result.extend.pageInfo.pageNum===result.extend.pageInfo.pages){
                    next.addClass("disabled")
                    lastPage.addClass("disabled")
                }else{
                    lastPage.click(function () {
                        to_page(result.extend.pageInfo.pages)
                    })
                    next.click(function () {
                        to_page(result.extend.pageInfo.pageNum+1)
                    })
                }


                var $ul = $('#page_info_artice')


                $ul.append(firstPage).append(previous)
                $.each(result.extend.pageInfo.navigatepageNums,function(index,value){

                var numLi = $('<li></li>').append($('<a></a>').append(value));
                 if(result.extend.pageInfo.pageNum===value){
                     numLi.addClass("active")
                 }
                 numLi.click(function () {
                        to_page(value)
                    })
                 numLi.appendTo("#page_info_artice")

                })
                $ul.append(next).append(lastPage)
            }










    </script>




</head>
<body>
<!-- 修改模态框 -->
<div class="modal fade" id="table_edit_emp" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="edit_title">员工编辑</h4>
            </div>
            <div class="modal-body" id="emp_edit_form">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_edit_input" ></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_edit_input" placeholder="email">
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-4">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_edit_input"  value="m"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_edit_input" value="n"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <select class="form-control" id="select_edit_input" name="dId">
                            </select>
                        </div>

                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="save_edit">更新</button>
            </div>
        </div>
    </div>
</div>
<!-- 搭建显示页面  -->
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>

    <div class="row">
        <div class="col-md-2 col-md-offset-10">
            <button type="button" class="btn btn-primary" id="add_input">新增</button>
            <button type="button" class="btn btn-danger" id="delete_input">删除</button>
        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="table_add_emp" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">员工新增</h4>
                </div>
                <div class="modal-body" id="emp_add_form">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            </div>
                        </div>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email">
                            </div>
                        </div>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-4">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_add_input" checked="checked" value="m"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_add_input" value="n"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">部门</label>
                            <div class="col-sm-4">
                                <select class="form-control" id="select_add_input" name="dId">
                            </select>
                            </div>

                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="save_add">保存</button>
                </div>
            </div>
        </div>
    </div>
    <br>
    <div class="row">
        <table class="table" id="emps_table">
            <thead>
            <tr>
                <th><input type="checkbox"  id="checkAll"> </th>
                <th>empId</th>
                <th>lastName</th>
                <th>email</th>
                <th>gender</th>
                <th>deptName</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>

            </tbody>

        </table>
    </div>
    <!-- 分页-->
    <div class="row">
        <div class="col-md-6" id="page_info_area"></div>
        <div class="col-md-5 col-md-offset-1">
            <nav aria-label="Page navigation">
                <ul class="pagination" id="page_info_artice"> </ul>
            </nav>
        </div>

    </div>
</div>
</body>
</html>
