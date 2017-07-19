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

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by wangdi on 2017/5/4.
 */
@Controller
@RequestMapping("/specialBook")
public class SpecialBookController {

    @Autowired
    IBookManage bookManage;

    @RequestMapping("/list")
    public String list(HttpServletRequest request ,BookDTO bookDTO, Model model, @RequestParam(required = false) String currPage, @RequestParam(required = false) String bookAct){
        return "specials";
    }
}
