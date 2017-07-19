package cn.com.njit.wd.consumer.controller.RestController;

import cn.com.njit.wd.api.dto.NoticeDTO;
import cn.com.njit.wd.api.dto.NoticeResDTO;
import cn.com.njit.wd.api.service.INoticeManage;
import cn.com.njit.wd.consumer.vo.AjaxVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Created by wangdi on 2017/5/17.
 */
@Controller
@RequestMapping("/notice")
public class NoticeRestController {

    @Autowired
    INoticeManage noticeManage;

    @RequestMapping("/add")
    @ResponseBody
    public AjaxVO addNotice(NoticeDTO noticeDTO){
        AjaxVO ajaxVO = new AjaxVO();
        noticeManage.addNotice(noticeDTO);
        ajaxVO.setMsg("保存成功,2秒后回到主页");
        ajaxVO.setFlag("success");
        return ajaxVO;
    }

    @RequestMapping("/findAll")
    @ResponseBody
    public AjaxVO findAll(NoticeDTO noticeDTO){
        noticeDTO.setPageSize(5);
        if (noticeDTO.getCurrPage()==0){
            noticeDTO.setCurrPage(1);
        }
        AjaxVO ajaxVO = new AjaxVO();
        NoticeResDTO noticeResDTO = noticeManage.queryAll(noticeDTO);
        List<NoticeDTO> noticeDTOS = noticeResDTO.getNoticeDTOList();
        ajaxVO.setData(noticeDTOS);
        ajaxVO.setMsg(String.valueOf(noticeResDTO.getCount()));
        return ajaxVO;
    }

    @RequestMapping("/modify")
    @ResponseBody
    public AjaxVO modifyNotice(NoticeDTO noticeDTO){
        AjaxVO ajaxVO = new AjaxVO();
        noticeManage.modifyNotice(noticeDTO);
        ajaxVO.setMsg("保存成功,2秒后回到主页");
        ajaxVO.setFlag("success");
        return ajaxVO;
    }

    @RequestMapping("/delete")
    @ResponseBody
    public AjaxVO deleteNotice(NoticeDTO noticeDTO){
        AjaxVO ajaxVO = new AjaxVO();
        noticeManage.deleteNotice(noticeDTO);
        ajaxVO.setMsg("删除成功");
        ajaxVO.setFlag("success");
        return ajaxVO;
    }
}
