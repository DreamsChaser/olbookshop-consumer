package cn.com.njit.wd.consumer.controller.RestController;

import cn.com.njit.wd.api.dto.TradeInfoDTO;
import cn.com.njit.wd.api.dto.TradeInfoResDTO;
import cn.com.njit.wd.api.dto.UserDTO;
import cn.com.njit.wd.api.enums.TradeTypeEnum;
import cn.com.njit.wd.api.service.ITradeManage;
import cn.com.njit.wd.api.service.IUserManage;
import cn.com.njit.wd.consumer.vo.AjaxVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Created by wangdi on 2017/5/16.
 */
@Controller
@RequestMapping("/tradeInfo")
public class TradeInfoRestController {

    @Autowired
    ITradeManage tradeManage;
    @Autowired
    IUserManage userManage;

    @RequestMapping("/queryList")
    @ResponseBody
    public AjaxVO queryTradeInfo(TradeInfoDTO tradeInfoDTO){
        AjaxVO ajaxVO = new AjaxVO();
        tradeInfoDTO.setPageSize(5);
        if (tradeInfoDTO.getCurrPage() == 0){
            tradeInfoDTO.setCurrPage(1);
        }else {
            tradeInfoDTO.setCurrPage(tradeInfoDTO.getCurrPage());
        }
        TradeInfoResDTO resDTO = tradeManage.queryByPage(tradeInfoDTO);
        List<TradeInfoDTO> tradeInfoDTOList = resDTO.getTradeInfoDTOList();
        for (TradeInfoDTO tradeInfo : tradeInfoDTOList){
            UserDTO userDTO = new UserDTO();
            userDTO.setUserId(tradeInfo.getUserId());
            UserDTO userResDTO = userManage.queryById(userDTO);
            tradeInfo.setUserId(userResDTO.getUserName());
            tradeInfo.setTradeType(TradeTypeEnum.getValueByKey(tradeInfo.getTradeType()));
        }
        ajaxVO.setData(resDTO.getTradeInfoDTOList());
        ajaxVO.setMsg(String.valueOf(resDTO.getCount()));
        return ajaxVO;
    }
}
