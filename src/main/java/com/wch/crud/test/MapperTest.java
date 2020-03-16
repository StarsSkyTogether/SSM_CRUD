package com.wch.crud.test;

import com.wch.crud.bean.Department;
import com.wch.crud.bean.Employee;
import com.wch.crud.dao.DepartmentMapper;
import com.wch.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.UUID;

/**
 * 推荐Spring的项目就可以使用Spring的单元测试，可以自动注入我们需要的组件
 * @ContextConfiguration指定Spring配置文件的位置
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    EmployeeMapper employeeMapper;
    @Autowired
    SqlSession sqlSession;
    @Test
    public void testCRUD(){
        System.out.println(departmentMapper+"/////////////////////////////////////////////////");
        //departmentMapper.insertSelective(new Department(null,"工程部"));
       // employeeMapper.insertSelective(new Employee(null,"小明","m","111@qq.com",1));
        EmployeeMapper employeeMapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i=0;i<1; i++){
            String uid = UUID.randomUUID().toString().substring(0,5)+i;
            employeeMapper.insertSelective(new Employee(null,uid,"m",uid+"@qq.com",2));
        }
        System.out.println("批量完成。。。。。。。。。。。。。。。");
    }

    @Test
    public void testService(){
        List<Employee> list = employeeMapper.selectByExample(null);
        list.forEach(System.out::println);
    }
}
