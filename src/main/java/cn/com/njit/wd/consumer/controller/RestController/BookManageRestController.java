package cn.com.njit.wd.consumer.controller.RestController;

import cn.com.njit.wd.api.dto.BookDTO;
import cn.com.njit.wd.api.dto.BookResDTO;
import cn.com.njit.wd.api.enums.BookActEnum;
import cn.com.njit.wd.api.enums.FlagEnum;
import cn.com.njit.wd.api.service.IBookManage;
import cn.com.njit.wd.consumer.vo.AjaxVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.awt.print.Book;
import java.io.*;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by wangdi on 2017/5/3.
 */
@Controller
@RequestMapping("/book")
public class BookManageRestController {

    @Autowired
    IBookManage bookManage;

    private static final String PHOTO_SUFFIX="JPG_JPEG_GIF_PNG_BMP";

    private static final String UPLOAD_PATH = "\\resources\\static\\upload\\";
    private static final String UPLOAD_PATH2 = "static/upload/";



    @RequestMapping("/addBook")
    public String addBook(@RequestParam MultipartFile bookImg, @RequestParam String bookName,
                          @RequestParam String bookPrice, @RequestParam String bookNum,
                          @RequestParam String bookSpePrice, @RequestParam String bookAct,
                          @RequestParam String bookDesc, @RequestParam String bookMoreDesc,
                          @RequestParam(required = false)String bookId, HttpServletRequest request, Model model){

        AjaxVO ajaxVO = new AjaxVO();
        BookDTO bookDTO = new BookDTO();
        InputStream in = null;
        String savePath = "";
        if(bookImg!=null&&bookImg.getSize()!=0){
            if(bookImg.getSize()/1024/1024>=2){
                ajaxVO.setMsg("上传照片不能大于2M");
                ajaxVO.setFlag(FlagEnum.FAIL.getKey());
            }
            //文件原名称
            String fileName=bookImg.getOriginalFilename();
            //扩展名
            String extensionName=fileName.substring(fileName.lastIndexOf(".")+1);
            if(PHOTO_SUFFIX.indexOf(extensionName.toUpperCase())<0){
                ajaxVO.setMsg("上传文件只能支持.jpg .jpeg .gif .png .bmp图片格式");
                ajaxVO.setFlag(FlagEnum.FAIL.getKey());
            }
            try {
                bookDTO.setBookImg(bookImg.getBytes());
                bookDTO.setBookAct(bookAct);
                bookDTO.setBookName(bookName);
                bookDTO.setBookNum(bookNum);
                bookDTO.setBookPrice(bookPrice);
                bookDTO.setBookSpePrice(bookSpePrice);
                bookDTO.setBookDesc(bookDesc);
                bookDTO.setBookMoreDesc(bookMoreDesc);
                if (StringUtils.isEmpty(bookId)) {
                    bookManage.addBook(bookDTO);
                }else {
                    bookDTO.setBookId(bookId);
                    bookManage.updateBook(bookDTO);
                }
                ajaxVO.setMsg("保存成功");
                ajaxVO.setFlag(FlagEnum.SUCCESS.getKey());
            } catch (IOException e) {
                ajaxVO.setMsg(e.getMessage());
                ajaxVO.setFlag(FlagEnum.FAIL.getKey());
            }
        }else {
            ajaxVO.setMsg("上传文件不能为空");
            ajaxVO.setFlag(FlagEnum.FAIL.getKey());
        }
        model.addAttribute("ajaxVO",ajaxVO);
        model.addAttribute("imgPath",savePath);
        mapModel(model);
        return "bookManage";
    }

    @RequestMapping("/list")
    @ResponseBody
    public AjaxVO list(BookDTO bookDTO,Model model){
        AjaxVO ajaxVO = new AjaxVO();
        if (bookDTO.getPageSize() == 0){
            bookDTO.setPageSize(9);
        }
        if (bookDTO.getCurPage() == 0){
            bookDTO.setCurPage(1);
        }
        List<BookDTO> bookDTOList = new ArrayList<BookDTO>();
        int count = 0;
        BookResDTO bookResDTO = bookManage.listAllBook(bookDTO);
        if (bookResDTO != null) {
            bookDTOList = bookResDTO.getBookDTOList();
            count = bookResDTO.getCount();
        }
        ajaxVO.setData(bookDTOList);
        ajaxVO.setMsg(String.valueOf(count));
        return ajaxVO;
    }

    @RequestMapping("/bookImage")
    public void bookImage(HttpServletRequest request, HttpServletResponse response, BookDTO bookDTO){
        InputStream in = null;
        OutputStream outputStream= null;
        try {
            outputStream = response.getOutputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            BookDTO dto = bookManage.getById(bookDTO);
            byte[] buf = dto.getBookImg();
            outputStream.write(buf);
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            try {
                outputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    @RequestMapping("/deleteBook")
    @ResponseBody
    public AjaxVO deleteBook(BookDTO bookDTO){
        AjaxVO ajaxVO = new AjaxVO();
        bookManage.deleteBook(bookDTO);
        ajaxVO.setMsg("删除成功");
        ajaxVO.setFlag("success");
        return ajaxVO;
    }

    @RequestMapping("/queryBook")
    @ResponseBody
    public AjaxVO queryBook(BookDTO bookDTO){
        AjaxVO ajaxVO = new AjaxVO();
        BookDTO bookResDTO = bookManage.getById(bookDTO);
        ajaxVO.setObj(bookResDTO);
        return ajaxVO;
    }

    @RequestMapping("/queryByName")
    @ResponseBody
    public AjaxVO queryByName(BookDTO bookDTO){
        AjaxVO ajaxVO = new AjaxVO();
        List<BookDTO> bookDTOList = bookManage.queryByName(bookDTO);
        if (CollectionUtils.isEmpty(bookDTOList)){
            ajaxVO.setFlag("error");
            ajaxVO.setMsg("未搜索到相关书籍，请重新输入");
        }else {
            ajaxVO.setFlag("success");
            ajaxVO.setData(bookDTOList);
        }
        return ajaxVO;
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
