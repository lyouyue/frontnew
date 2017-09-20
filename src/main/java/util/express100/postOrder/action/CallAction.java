package util.express100.postOrder.action;

import java.util.HashMap;

import org.apache.log4j.Logger;
import util.action.BaseAction;
import util.express100.bean.TaskRequest;
import util.express100.bean.TaskResponse;
import util.express100.postOrder.demo.HttpRequest;
import util.express100.postOrder.demo.JacksonHelper;
/**
 * 请求Action
 */
public class CallAction extends BaseAction{
	private static final long serialVersionUID = -575766593712269425L;
	Logger logger = Logger.getLogger(this.getClass());
	private TaskRequest req;
	private TaskResponse resp;
	
	public String askFor(){
		/*req.setFrom("上海浦东新区");
		req.setTo("广东深圳南山区");*/
		String path = request.getContextPath();
		String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
//		req.getParameters().put("callbackurl","http://122.114.34.91:8861/express100/callBack/backMessage.do");//回调地址
		req.getParameters().put("callbackurl",basePath+"callBack/backMessage.do");//回调地址
		req.setKey("mHdSlmlZ4073");

		HashMap<String, String> p = new HashMap<String, String>(); 
		p.put("schema", "json");
		p.put("param", JacksonHelper.toJSON(req));
		System.out.println("发送信息："+JacksonHelper.toJSON(req));
		try {
			String ret = HttpRequest.postData("http://www.kuaidi100.com/poll", p, "UTF-8");
			resp = JacksonHelper.fromJSON(ret, TaskResponse.class);
			if(resp.getResult()==true){
				System.out.println("订阅成功");
				return SUCCESS;
			}else{
				System.out.println("订阅失败");
				return ERROR;
			}
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			return ERROR;
		}
	}
	public TaskRequest getReq() {
		return req;
	}
	public void setReq(TaskRequest req) {
		this.req = req;
	}
	public TaskResponse getResp() {
		return resp;
	}
	public void setResp(TaskResponse resp) {
		this.resp = resp;
	}
	
}
