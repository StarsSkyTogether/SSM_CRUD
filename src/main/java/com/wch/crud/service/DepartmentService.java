package com.wch.crud.service;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.wch.crud.bean.Department;
import com.wch.crud.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> getDepartment(){
        List<Department> list = departmentMapper.selectByExample(null);
        return list;
    }

}
