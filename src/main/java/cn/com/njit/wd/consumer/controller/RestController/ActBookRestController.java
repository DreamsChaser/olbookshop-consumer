package cn.com.njit.wd.consumer.controller.RestController;

import cn.com.njit.wd.api.dto.BookDTO;
import cn.com.njit.wd.api.dto.BookResDTO;
import cn.com.njit.wd.api.enums.BookActEnum;
import cn.com.njit.wd.api.service.IBookManage;
import cn.com.njit.wd.consumer.vo.AjaxVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wangdi on 2017/5/3.
 */
@Controller
@RequestMapping("/actBooks")
public class ActBookRestController {

    @Autowired
    IBookManage bookManage;

    @RequestMapping("/list")
    @ResponseBody
    public AjaxVO list(BookDTO bookDTO){
        AjaxVO ajaxVO = new AjaxVO();
        if (bookDTO.getBookAct().equals(BookActEnum.HOT.getKey())) {
            bookDTO.setPageSize(2);
        }else if (bookDTO.getBookAct().equals(BookActEnum.NEW.getKey())) {
            bookDTO.setPageSize(3);
        }else if (bookDTO.getBookAct().equals(BookActEnum.SPECIAL.getKey())) {
            bookDTO.setPageSize(4);
        }
        if (bookDTO.getCurPage() == 0){
            bookDTO.setCurPage(1);
        }else {
            bookDTO.setCurPage(bookDTO.getCurPage());
        }
        List<BookDTO> bookDTOList = new ArrayList<BookDTO>();
        int count = 0;
        BookResDTO bookResDTO = bookManage.findByAct(bookDTO);
            if (bookResDTO != null) {
            bookDTOList = bookResDTO.getBookDTOList();
            count = bookResDTO.getCount();
        }
        ajaxVO.setData(bookDTOList);
        ajaxVO.setMsg(String.valueOf(count));
        return ajaxVO;
    }
}
