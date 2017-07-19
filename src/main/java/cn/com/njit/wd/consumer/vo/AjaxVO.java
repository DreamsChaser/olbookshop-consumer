package cn.com.njit.wd.consumer.vo;

import java.util.List;

/**
 * Created by wangdi on 2017/3/29.
 */
public class AjaxVO {
    private String msg;
    private String flag;
    private List data;
    private Object obj;

    public List getData() {
        return data;
    }

    public void setData(List data) {
        this.data = data;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }

    public Object getObj() {
        return obj;
    }

    public void setObj(Object obj) {
        this.obj = obj;
    }
}
