package com.wch.crud.controller;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wch.crud.bean.Employee;
import com.wch.crud.bean.Msg;
import com.wch.crud.service.EmployeeService;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

/**
 * 处理员工CRUD请求
 */

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    //单个删除
    @ResponseBody
    @RequestMapping(value="/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteById(@PathVariable("ids") String ids){
        if(ids.contains("-")){
            List<Integer> list = new ArrayList<>();
            String[] idstrs = ids.split("-");
            for(String idstr : idstrs) {
                list.add(Integer.parseInt(idstr));
            }
            employeeService.deleteBacth(list);
        }else {
            Integer id = Integer.parseInt(ids);
            employeeService.deleteById(id);
        }

        return Msg.success();
    }

    //回显数据
    @ResponseBody
    @RequestMapping(value="/emp/{id}",method = RequestMethod.GET)
    public Msg echo(@PathVariable("id") Integer id){
        Employee employee = employeeService.getById(id);
        return Msg.success().add("employee",employee);
    }

    /**
     * 修改employee
     * @param employee
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    public Msg updateEmployee(Employee employee){
        System.out.println("......../////////////////............"+employee);
        employeeService.update(employee);
        return Msg.success();
    }

    /**
     * 后端验证
     * @param empName
     * @return
     */
    @ResponseBody
    @RequestMapping("/validateName")
    public Msg validateName(@RequestParam("empName") String empName){
        boolean bool = employeeService.selectEmpName(empName);
        String regName = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        if(!empName.matches(regName)){
            return Msg.fail().add("vi","用户名可以是2-5位中文或者6-16位英文和数字的组合!");
        }

        if(bool){

            return Msg.success().add("vi","该用户名可用");
        }else{
            return Msg.fail().add("vi","该用户名已存在！");
        }

    }



    @RequestMapping(value="/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg save(@Valid  Employee employee){

        employeeService.save(employee);

        return Msg.success();
    }

   @ResponseBody
    @RequestMapping("/emps")
    public Msg getJsonEmps(@RequestParam(value = "pn",required = false,defaultValue = "1") Integer pn){
        //这不是一个分页查询
        //引入PageHelper分页插件
        //在查询之前只需调用，传入页码，以及每页的大小
       PageHelper.startPage(pn,5);
        //startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
       System.out.println(emps);
        //使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
        //封装了详细的分页信息，包括有我们查询出来的数据，传入连续显示的页数。
       PageInfo page = new PageInfo(emps,5);


        return Msg.success().add("pageInfo",page);
    }

    @Test
    public void testService(){
        List<Employee> employees = employeeService.getAll();
        employees.forEach(System.out::println);


    }

}
