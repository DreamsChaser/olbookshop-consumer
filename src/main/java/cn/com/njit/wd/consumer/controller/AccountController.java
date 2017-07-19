package cn.com.njit.wd.consumer.controller;

import cn.com.njit.wd.api.dto.CartDTO;
import cn.com.njit.wd.api.dto.CartResDTO;
import cn.com.njit.wd.api.dto.UserDTO;
import cn.com.njit.wd.api.service.ICartManage;
import cn.com.njit.wd.api.service.IUserManage;
import org.apache.catalina.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.jws.WebParam;
import javax.servlet.http.HttpServletRequest;

/**
 * Created by wangdi on 2017/4/13.
 */
@Controller
@RequestMapping("/account")
public class AccountController {

    @Autowired
    ICartManage cartManage;
    @Autowired
    IUserManage userManage;

    @RequestMapping("/myAccount")
    public String myAccount(){
        return "myAccount";
    }

    @RequestMapping("/cart")
    public String cart(@RequestParam("userId")String userId, Model model){
        CartDTO cartDTO = new CartDTO();
        cartDTO.setUserId(userId);
        CartResDTO resDTO = cartManage.queryByUserId(cartDTO);
        model.addAttribute("cartList",resDTO.getCartDTOS());
        return "cart";
    }
}
