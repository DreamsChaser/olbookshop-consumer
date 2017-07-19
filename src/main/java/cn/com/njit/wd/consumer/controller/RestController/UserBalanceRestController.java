package cn.com.njit.wd.consumer.controller.RestController;

import cn.com.njit.wd.api.dto.TradeInfoDTO;
import cn.com.njit.wd.api.dto.UserDTO;
import cn.com.njit.wd.api.enums.TradeTypeEnum;
import cn.com.njit.wd.api.enums.UserEnum;
import cn.com.njit.wd.api.service.IBookManage;
import cn.com.njit.wd.api.service.ITradeManage;
import cn.com.njit.wd.api.service.IUserManage;
import cn.com.njit.wd.consumer.vo.AjaxVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by wangdi on 2017/5/16.
 */
@Controller
@RequestMapping("/userBalance")
public class UserBalanceRestController {

    @Autowired
    IUserManage userManage;
    @Autowired
    ITradeManage tradeManage;

    @RequestMapping("/add")
    @ResponseBody
    public AjaxVO add(UserDTO userDTO, HttpServletRequest request, @RequestParam(required = false)String tradeMoney){
        AjaxVO ajaxVO = new AjaxVO();
        userManage.updateUserBalance(userDTO);
        TradeInfoDTO tradeInfoDTO = new TradeInfoDTO();
        tradeInfoDTO.setTradeType(TradeTypeEnum.RECHARGE.getKey());
        tradeInfoDTO.setTradeMoney(tradeMoney);
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formatDate = sdf.format(new Date());
        tradeInfoDTO.setTradeTime(formatDate);
        tradeInfoDTO.setUserId(userDTO.getUserId());
        tradeManage.addTradeInfo(tradeInfoDTO);
        ajaxVO.setMsg("充值成功");
        UserDTO userNewDTO = userManage.queryById(userDTO);
        attributesMap(userNewDTO);
        request.getSession().setAttribute("user",userNewDTO);
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
