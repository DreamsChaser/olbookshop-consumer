package cn.com.njit.wd.consumer.controller;

import cn.com.njit.wd.api.dto.BookDTO;
import cn.com.njit.wd.api.dto.BookResDTO;
import cn.com.njit.wd.api.dto.UserDTO;
import cn.com.njit.wd.api.enums.BookActEnum;
import cn.com.njit.wd.api.service.IBookManage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wangdi on 2017/4/13.
 */
@Controller
@RequestMapping("/bookCategory")
public class BookCategoryController {

    @Autowired
    IBookManage bookManage;

    @RequestMapping("/list")
    public String bookCategoryList(BookDTO bookDTO, Model model, @RequestParam(required = false) String currPage){
        if (bookDTO.getPageSize() == 0){
            bookDTO.setPageSize(9);
        }
        if (StringUtils.isEmpty(currPage)){
            bookDTO.setCurPage(1);
        }else {
            bookDTO.setCurPage(Integer.parseInt(currPage));
        }
        List<BookDTO> bookDTOList = new ArrayList<BookDTO>();
        int count = 0;
        BookResDTO bookResDTO = bookManage.listAllBook(bookDTO);
        if (bookResDTO != null) {
            bookDTOList = bookResDTO.getBookDTOList();
            count = bookResDTO.getCount();
        }
        model.addAttribute("bookList",bookDTOList);
        model.addAttribute("count",count);
        model.addAttribute("currPage",bookDTO.getCurPage());
        return "bookList";
    }

    @RequestMapping("/details")
    public String bookDetail(BookDTO bookDTO,Model model){
        BookDTO dto = bookManage.getById(bookDTO);
        model.addAttribute("book",dto);
        return "details";
    }

    @RequestMapping("/bookManage")
    public String addBook(Model model){
        mapModel(model);
        return "bookManage";
    }

    @RequestMapping("/modify")
    public String modifyBook(Model model,@RequestParam String bookId){
        model.addAttribute("type","modify");
        model.addAttribute("bookId",bookId);
        mapModel(model);
        return "bookManage";
    }

    /**
     * 属性转化
     * @param model
     * @return
     */
    private Model mapModel(Model model){
        Map actMap = new HashMap();
        for(BookActEnum bookActEnum : BookActEnum.values()){
            actMap.put(bookActEnum.getKey(),bookActEnum.getValue());
        }
        model.addAttribute("actMap",actMap);
        return model;
    }
}
