package com.wch.crud.controller;

import com.wch.crud.bean.Department;
import com.wch.crud.bean.Msg;
import com.wch.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DepartmentController {
    @Autowired
    DepartmentService departmentService;

    @ResponseBody
    @RequestMapping("/getDept")
    public Msg getDept(){
        List<Department> depts = departmentService.getDepartment();


        return  Msg.success().add("depts",depts);
    }


}
