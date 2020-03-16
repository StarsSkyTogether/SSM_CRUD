package com.wch.crud.service;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.wch.crud.bean.Employee;
import com.wch.crud.bean.EmployeeExample;
import com.wch.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@JsonIgnoreProperties(value = {"handler"})
@Service
public class EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    public void save(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    public List<Employee> getAll(){
        List<Employee> employees = employeeMapper.selectByExampleWithDept(null);
        return employees;
    }
    public Employee getById(Integer id){
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    public List<Employee> findSelectAll(){
        List<Employee> employees = employeeMapper.selectByWithDept();
        return employees;
    }

    public boolean selectEmpName(String empName) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        return employeeMapper.countByExample(example)==0;
    }

    public void update(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    public void deleteById(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    public void deleteBacth(List<Integer> list) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(list);
        employeeMapper.deleteByExample(example);

    }
}
