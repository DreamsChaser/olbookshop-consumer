package cn.com.njit.wd.consumer.controller;

import cn.com.njit.wd.api.dto.NoticeDTO;
import cn.com.njit.wd.api.dto.UserDTO;
import cn.com.njit.wd.api.service.INoticeManage;
import cn.com.njit.wd.api.service.IUserManage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by wangdi on 2017/5/17.
 */
@Controller
public class NoticeController {

    @Autowired
    INoticeManage noticeManage;
    @Autowired
    IUserManage userManage;

    @RequestMapping("/noticeManage")
    public String notice(){
        return "noticeManage";
    }

    @RequestMapping("/modifyNotice")
    public String modifyNotice(NoticeDTO noticeDTO,Model model){
        NoticeDTO noticeResDTO = noticeManage.queryById(noticeDTO);
        model.addAttribute("notice",noticeResDTO);
        return "noticeManage";
    }

    @RequestMapping("/noticeDetail")
    public String noticeDetail(NoticeDTO noticeDTO, Model model){
        NoticeDTO dto = noticeManage.queryById(noticeDTO);
        UserDTO userDTO = new UserDTO();
        userDTO.setUserId(dto.getUserId());
        dto.setUserId(userManage.queryById(userDTO).getUserName());
        model.addAttribute("notice",dto);
        return "noticeDetail";
    }
}
