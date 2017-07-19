package cn.com.njit.wd.consumer.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by wangdi on 2017/4/12.
 */
@Controller
public class UserManageController {

    @RequestMapping("/toRegister")
    public String register(){
        return "register";
    }

}
