package cn.com.njit.wd.consumer.controller.RestController;

import cn.com.njit.wd.api.dto.TradeInfoDTO;
import cn.com.njit.wd.api.dto.UserDTO;
import cn.com.njit.wd.api.enums.FlagEnum;
import cn.com.njit.wd.api.enums.TradeTypeEnum;
import cn.com.njit.wd.api.enums.UserEnum;
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
 * Created by wangDi on 2017/4/16.
 */
@Controller
@RequestMapping("/user")
public class UserManageRestController {

    @Autowired
    IUserManage userManage;
    @Autowired
    ITradeManage tradeManage;

    @RequestMapping("/userRegister")
    @ResponseBody
    public AjaxVO userRegister(UserDTO dto, HttpServletRequest request) throws Exception{
        AjaxVO ajaxVO = new AjaxVO();
        if(userManage.queryByName(dto)){
            ajaxVO.setFlag(FlagEnum.FAIL.getKey());
            ajaxVO.setMsg("注册失败，用户名已存在");
        }else {
            try {
                dto.setUserBalance("0");
                UserDTO userDTO = userManage.insert(dto);
                ajaxVO.setFlag(FlagEnum.SUCCESS.getKey());
                ajaxVO.setMsg("注册成功,2秒后进入主页面");
                attributesMap(userDTO);
                request.getSession().setAttribute("user",userDTO);
            } catch (Exception e) {
                ajaxVO.setFlag(FlagEnum.FAIL.getKey());
                ajaxVO.setMsg("注册失败");
            }
        }
        return ajaxVO;
    }

    @RequestMapping("/userLogin")
    @ResponseBody
    public AjaxVO userLogin(UserDTO userDTO,HttpServletRequest request){
        AjaxVO ajaxVO = new AjaxVO();
        if (!userManage.queryByName(userDTO)){
            ajaxVO.setFlag(FlagEnum.FAIL.getKey());
            ajaxVO.setMsg("该用户不存在，请先注册");
        }else {
            UserDTO userResDTO = userManage.queryOne(userDTO);
            if (userResDTO == null){
                ajaxVO.setFlag(FlagEnum.FAIL.getKey());
                ajaxVO.setMsg("用户名或密码错误，请重新输入");
            }else {
                ajaxVO.setFlag(FlagEnum.SUCCESS.getKey());
                ajaxVO.setMsg("登录成功,2秒后进入主页");
                attributesMap(userResDTO);
                request.getSession().setAttribute("user",userResDTO);
            }
        }
        return ajaxVO;
    }

    @RequestMapping("/userLogout")
    @ResponseBody
    public AjaxVO logout(HttpServletRequest request){
        AjaxVO ajaxVO = new AjaxVO();
        request.getSession().removeAttribute("user");
        ajaxVO.setMsg("注销成功");
        ajaxVO.setFlag(FlagEnum.SUCCESS.getKey());
        return ajaxVO;
    }

    @RequestMapping("/userTypeUpdate")
    @ResponseBody
    public AjaxVO update(UserDTO userDTO,HttpServletRequest request){
        AjaxVO ajaxVO = new AjaxVO();
        String tradeMoney = userDTO.getUserBalance();
        String userBalance = userManage.queryById(userDTO).getUserBalance();
        if (Integer.parseInt(userBalance)-Integer.parseInt(userDTO.getUserBalance())<0){
            ajaxVO.setFlag("error");
            ajaxVO.setMsg("升级失败用户余额不足");
        }else {
            //1扣款
            userDTO.setUserBalance(String.valueOf(Integer.parseInt(userBalance)-Integer.parseInt(userDTO.getUserBalance())));
            userManage.updateUserBalance(userDTO);
            //2生成交易信息
            TradeInfoDTO tradeInfoDTO = new TradeInfoDTO();
            tradeInfoDTO.setUserId(userDTO.getUserId());
            tradeInfoDTO.setTradeType(TradeTypeEnum.DECREASE.getKey());
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String formatDate = sdf.format(new Date());
            tradeInfoDTO.setTradeTime(formatDate);
            tradeInfoDTO.setTradeMoney(tradeMoney);
            tradeManage.addTradeInfo(tradeInfoDTO);
            userManage.updateUserTypeById(userDTO);
            ajaxVO.setMsg("升级成功,请重新登录");
            ajaxVO.setFlag("success");
            request.getSession().removeAttribute("user");
        }
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
