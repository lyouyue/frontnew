package shop.customer.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;

import shop.customer.pojo.CusService;
import shop.customer.pojo.ShopCustomerService;
import shop.customer.service.ICustomerServiceService;
import shop.customer.service.ISelfSupportCustomerServiceService;
import util.action.BaseAction;


/**   
 * @作用：自营店铺客服Action
 * @功能：
 * @作者: wyc
 * @日期：2016年5月19日 下午2:46:52 
 * @版本：V1.0   
 */
@SuppressWarnings("serial")
public class SelfSupportCustomerServiceAction extends BaseAction {
	/**客服信息表service**/
	private ICustomerServiceService customerServiceService;
	/**自营店铺客服service**/
	private ISelfSupportCustomerServiceService selfSupportCustomerServiceService;
	private String ids;
	private String ccsId;
	
	/** 
	 * 页面跳转 
	 */
	public String gotoShopCustomerServicePage(){
		//获取标签名称 
		String shopName = request.getParameter("shopName");
		//将标签名称存储到request域中
		request.setAttribute("shopName", shopName);
		return SUCCESS;
	}
	
	/**查看已关联的标签
	 * @throws IOException 
	 */
	@SuppressWarnings("rawtypes")
	public void listShopCustomerService() throws IOException{
		String trueName = request.getParameter("trueName");
		String nikeName = request.getParameter("nikeName");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		String hql="select a.customerId as customerId,b.customerServiceId as customerServiceId,b.trueName as trueName,b.nikeName as nikeName,b.qq as qq,b.useState as useState,c.ccsId as ccsId from Customer a ,CusService b ,ShopCustomerService c where a.customerId=c.customerId and c.customerServiceId=b.customerServiceId and a.customerId="+ids;
		String hqlCount="select count(b.customerServiceId) from Customer a ,CusService b ,ShopCustomerService c where a.customerId=c.customerId and c.customerServiceId=b.customerServiceId and a.customerId="+ids;
		if(trueName!=null&&!"".equals(trueName.trim())){
			hql+=" and b.trueName like'%"+trueName+"%'";
			hqlCount+=" and b.trueName like'%"+trueName+"%'";
		}
		if(nikeName!=null&&!"".equals(nikeName.trim())){
			hql+=" and b.nikeName like'%"+nikeName+"%'";
			hqlCount+=" and b.nikeName like'%"+nikeName+"%'";
		}
		int totalRecordCount=selfSupportCustomerServiceService.getMultilistCount(hqlCount);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<Map> listMap=selfSupportCustomerServiceService.findListMapPage(hql+" order by b.customerServiceId desc", pageHelper);
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", listMap);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8"); 
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 查看未关联标签
	 */
	@SuppressWarnings("unchecked")
	public void listUnShopCustomerService() throws IOException{
		String trueName = request.getParameter("trueName");
		String nikeName = request.getParameter("nikeName");
		String where="where 1=1 and o.useState=1 ";
		//查看已经关联的中间表id
		List<ShopCustomerService> ststList = selfSupportCustomerServiceService.findObjects(new String[]{"ccsId","customerServiceId"}, " where o.customerId="+ids);
		String sbHasStId="";//声明已有使用行业标签id
		if(ststList!=null&&ststList.size()>0){
			for(ShopCustomerService stst:ststList){
				sbHasStId+=stst.getCustomerServiceId()+",";
			}
			if(StringUtils.isNotEmpty(sbHasStId)){
				sbHasStId=sbHasStId.substring(0, sbHasStId.lastIndexOf(","));
				where+=" and o.customerServiceId not in("+sbHasStId+")";
			}
		}
		if(trueName!=null&&!"".equals(trueName.trim())){
			where+=" and o.trueName like'%"+trueName+"%'";
		}
		if(nikeName!=null&&!"".equals(nikeName)){
			where+=" and o.nikeName like'%"+nikeName+"%'";
		}
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		int totalRecordCount=customerServiceService.getCount(where);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<CusService> list=customerServiceService.findListByPageHelper(null, pageHelper, where);
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", list);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	
	/**保存新的记录**/
	public void savaOrUpdateShopCustomerService() throws Exception{
		JSONObject jo = new JSONObject();
		//获取ttid
		String shopInfoId = request.getParameter("shopInfoId");
		String[] split = ids.split(",");
		for(String s:split){
			ShopCustomerService shopCustomerService=new ShopCustomerService();
			shopCustomerService.setCustomerId(Integer.parseInt(shopInfoId));
			shopCustomerService.setCustomerServiceId(Integer.parseInt(s));
			selfSupportCustomerServiceService.saveOrUpdateObject(shopCustomerService);
		}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**删除记录**/
	public void deleteShopCustomerService() throws IOException{
		Boolean isSuccess = selfSupportCustomerServiceService.deleteObjectsByIds("ccsId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	
	public ICustomerServiceService getCustomerServiceService() {
		return customerServiceService;
	}
	public void setCustomerServiceService(
			ICustomerServiceService customerServiceService) {
		this.customerServiceService = customerServiceService;
	}
	public ISelfSupportCustomerServiceService getSelfSupportCustomerServiceService() {
		return selfSupportCustomerServiceService;
	}
	public void setSelfSupportCustomerServiceService(
			ISelfSupportCustomerServiceService selfSupportCustomerServiceService) {
		this.selfSupportCustomerServiceService = selfSupportCustomerServiceService;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getCcsId() {
		return ccsId;
	}
	public void setCcsId(String ccsId) {
		this.ccsId = ccsId;
	} 
	
}
