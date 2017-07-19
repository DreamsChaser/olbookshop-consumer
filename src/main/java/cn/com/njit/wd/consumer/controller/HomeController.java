package cn.com.njit.wd.consumer.controller;

import cn.com.njit.wd.api.dto.BookDTO;
import cn.com.njit.wd.api.dto.BookResDTO;
import cn.com.njit.wd.api.service.IBookManage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wangdi on 2017/4/12.
 *
 */
@Controller
public class HomeController {

    @Autowired
    IBookManage bookManage;

    @RequestMapping("/home")
    public String home(BookDTO bookDTO, Model model, @RequestParam(required = false) String currPage){
        return "home";
    }
}
