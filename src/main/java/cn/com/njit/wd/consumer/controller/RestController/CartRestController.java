package cn.com.njit.wd.consumer.controller.RestController;

import cn.com.njit.wd.api.dto.BookDTO;
import cn.com.njit.wd.api.dto.CartDTO;
import cn.com.njit.wd.api.dto.TradeInfoDTO;
import cn.com.njit.wd.api.dto.UserDTO;
import cn.com.njit.wd.api.enums.TradeTypeEnum;
import cn.com.njit.wd.api.enums.UserEnum;
import cn.com.njit.wd.api.service.IBookManage;
import cn.com.njit.wd.api.service.ICartManage;
import cn.com.njit.wd.api.service.ITradeManage;
import cn.com.njit.wd.api.service.IUserManage;
import cn.com.njit.wd.consumer.vo.AjaxVO;
import com.alibaba.fastjson.JSONArray;
import com.sun.tracing.dtrace.ArgsAttributes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;


/**
 * Created by wangdi on 2017/5/15.
 */
@Controller
@RequestMapping("/cart")
public class CartRestController {

    @Autowired
    ICartManage iCartManage;
    @Autowired
    IBookManage bookManage;
    @Autowired
    IUserManage userManage;
    @Autowired
    ITradeManage tradeManage;

    @RequestMapping("/addToCart")
    @ResponseBody
    public AjaxVO addToCart(CartDTO cartDTO){
        AjaxVO ajaxVO = new AjaxVO();
        iCartManage.addToCart(cartDTO);
        ajaxVO.setMsg("成功加入购物车");
        return ajaxVO;
    }

    @RequestMapping("/checkout")
    @ResponseBody
    public AjaxVO checkout(CartDTO cartDTO, @RequestParam(required = false)String totalPrice, @RequestParam(required = false)String tradeMoney, HttpServletRequest request){
        List<String> bookIdList =  JSONArray.parseArray(cartDTO.getBookId(),String.class);
        List<String> cartIdList = JSONArray.parseArray(cartDTO.getCartId(),String.class);
        List<String> bookNumList = JSONArray.parseArray(cartDTO.getBookNum(),String.class);
        AjaxVO ajaxVO = new AjaxVO();
        for (int i = 0;i<cartIdList.size();i++){
            BookDTO bookReqDTO = new BookDTO();
            bookReqDTO.setBookId(bookIdList.get(i));
            BookDTO bookResDTO = bookManage.getById(bookReqDTO);
            if (Integer.parseInt(bookResDTO.getBookNum())<Integer.parseInt(bookNumList.get(i))){
                ajaxVO.setFlag("error");
                ajaxVO.setMsg(bookResDTO.getBookName()+"库存不足，请联系管理员进货");
                continue;
            }else {
                //1对账户余额进行扣款
                UserDTO userReqDTO = new UserDTO();
                userReqDTO.setUserId(cartDTO.getUserId());
                userReqDTO.setUserBalance(totalPrice);
                userManage.updateUserBalance(userReqDTO);
                UserDTO userNewDTO = userManage.queryById(userReqDTO);
                attributesMap(userNewDTO);
                request.getSession().setAttribute("user",userNewDTO);
                //2生成交易流水信息
                TradeInfoDTO tradeInfoDTO = new TradeInfoDTO();
                tradeInfoDTO.setUserId(cartDTO.getUserId());
                tradeInfoDTO.setTradeMoney(tradeMoney);
                SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String formatDate = sdf.format(new Date());
                tradeInfoDTO.setTradeTime(formatDate);
                tradeInfoDTO.setTradeType(TradeTypeEnum.DECREASE.getKey());
                tradeManage.addTradeInfo(tradeInfoDTO);
                //3删除对应购物车选项
                CartDTO cartResDTO = new CartDTO();
                cartResDTO.setCartId(cartIdList.get(i));
                iCartManage.deleteCart(cartResDTO);
                ajaxVO.setMsg("支付成功");
                ajaxVO.setFlag("success");
                //4删除该数量的书本
                bookReqDTO.setBookNum(String.valueOf(Integer.parseInt(bookResDTO.getBookNum())-Integer.parseInt(bookNumList.get(i))));
                bookManage.decodeNumById(bookReqDTO);
            }
        }
        return ajaxVO;
    }

    @RequestMapping("/deleteFromCart")
    @ResponseBody
    public AjaxVO deleteFromCart(CartDTO cartDTO){
        AjaxVO ajaxVO = new AjaxVO();
        iCartManage.deleteCart(cartDTO);
        ajaxVO.setFlag("success");
        ajaxVO.setMsg("删除成功");
        return ajaxVO;
    }

    /**
     * 用户属性标识与中文转化
     * @param userDTO
     */
    private void attributesMap(UserDTO userDTO){
        userDTO.setUserType(UserEnum.getValueByKey(userDTO.getUserType()));
    }
}
