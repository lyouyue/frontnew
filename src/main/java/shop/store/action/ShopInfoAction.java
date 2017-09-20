package shop.store.action;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts2.ServletActionContext;

import shop.common.pojo.DistrictInfo;
import shop.customer.pojo.Customer;
import shop.customer.service.ICustomerService;
import shop.store.pojo.ShopCategory;
import shop.store.pojo.ShopInfo;
import shop.store.service.IShopCategoryService;
import shop.store.service.IShopInfoService;
import util.action.BaseAction;
import util.other.JSONFormatDate;
import util.other.QRCode;
import util.other.Utils;
import basic.pojo.Users;
import basic.service.IAreaService;
import basic.service.IKeyBookService;
/**
 * ShopInfoAction - 店铺action基本信息
 * @Author §j*fm§
 */
@SuppressWarnings("serial")
public class ShopInfoAction extends BaseAction {
	private IShopInfoService shopInfoService;//店铺基本信息Service
	private List<ShopInfo> shopInfoList = new ArrayList<ShopInfo>();//店铺信息列表
	private List<Map> shopInfoListMap = new ArrayList<Map>();//店铺信息列表
	private List<ShopCategory> shopCategoryList = null;//店铺分类信息列表
	private List<Customer> customerList = null;//客户信息列表
	private IShopCategoryService shopCategoryService;//店铺分类Service
	private ICustomerService customerService;//客户信息Service
	private List<DistrictInfo> districtInfoList = null;//国家信息列表
	private List<DistrictInfo> regionLocationList = null;//各州信息列表
	private String ids;
	private ShopInfo shopInfo;//店铺基本信息实体
	/**区域Service**/
	private IAreaService areaService;
	// 上传文件路径
	private File imagePath;
	// 上传文件名称
	private String imagePathFileName;
	/**查询数字字典公司认证**/
	private IKeyBookService keyBookService;
	private Integer saveIsPass;
	private Integer savePhoneShowStatus;
	private Integer saveShopInfoCheckSatus;
	
	public String gotoShopInfoPage() throws Exception {
		//初始化加载的数据getName
		shopCategoryList = shopCategoryService.findObjects("where o.shopCategoryId >1)");
		customerList = customerService.findObjects(null);
//		businessTypeList = (List<KeyBook>) ((Map) ActionContext.getContext().getApplication().get("keybook")).get("businessType");
		return SUCCESS;
	}
	//店铺基本信息查询列表
	public void listShopInfo() throws IOException {
		String sql="SELECT a.shopInfoId as shopInfoId,a.logoUrl as logoUrl,a.companyName as companyName,a.customerName as customerName ,a.shopName as shopName,b.shopCategoryName as shopCategoryName,a.mainProduct as mainProduct ,a.isPass as isPass ,a.isClose as isClose ,a.isVip as isVip ,a.verifier as verifier from ShopInfo a , ShopCategory b,Customer c where a.shopCategoryId=b.shopCategoryId  and a.customerId=c.customerId and a.shopInfoType=2";
		String sqlCount="SELECT count(a.shopInfoId) from ShopInfo a , ShopCategory b,Customer c where a.shopCategoryId=b.shopCategoryId and a.customerId=c.customerId and a.shopInfoType=2";
		String selectFlag=request.getParameter("selectFlag");
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String shopName = request.getParameter("shopName");
			String isClose = request.getParameter("isClose");
			String custName = request.getParameter("custName");
			String shopCategoryId = request.getParameter("shopCategoryId");
			String isPass = request.getParameter("isPass");
			String isVip = request.getParameter("isVip");
			String registerDate = request.getParameter("registerDate");
			String registerDate2 = request.getParameter("registerDate2");
			if(registerDate!=null&&!"".equals(registerDate)){
				sql+= " and c.registerDate>= '"+registerDate.trim()+" 00:00:00"+"'";
				sqlCount+= " and  c.registerDate >= '"+registerDate.trim()+" 00:00:00"+"'";
			}
			if(registerDate2!=null&&!"".equals(registerDate2)){
				sql+= " and c.registerDate < '"+registerDate2.trim()+" 23:59:59"+"'";
				sqlCount+= " and  c.registerDate < '"+registerDate2.trim()+" 23:59:59"+"'";
			}
			if(shopName!=null&&StringUtils.isNotEmpty(shopName)){
				shopName = shopName.trim();
				sql+=" and a.shopName like '%"+shopName+"%'";
				sqlCount+=" and a.shopName like '%"+shopName+"%'";
			}
			if(custName!=null&&StringUtils.isNotEmpty(custName)){
				custName = custName.trim();
				sql+=" and a.customerName like '%"+custName+"%'";
				sqlCount+=" and a.customerName like '%"+custName+"%'";
			}
			if(!"-1".equals(isClose)){
				sql+=" and a.isClose="+isClose;
				sqlCount+=" and a.isClose="+isClose;
			}
			/*if(!"-1".equals(isVip)){
				sql+=" and a.isVip="+isVip;
				sqlCount+=" and a.isVip="+isVip;
			}*/
			if(!"-1".equals(isPass)){
				sql+=" and a.isPass="+isPass;
				sqlCount+=" and a.isPass="+isPass;
			}
			if(!"-1".equals(shopCategoryId)){
				sql+=" and a.shopCategoryId="+shopCategoryId;
				sqlCount+=" and a.shopCategoryId="+shopCategoryId;
			}
		}
		sql+=" order by a.shopInfoId desc";
		int totalRecordCount = shopInfoService.getMoreTableCount(sqlCount);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		shopInfoListMap = shopInfoService.findListMapPage(sql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", shopInfoListMap);
		JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	// 异步ajax 图片上传
	public void uploadImage() throws Exception {
		JSONObject jo = new JSONObject();
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		// 1图片上传
		if (imagePath != null) {
			// 1上传文件的类型
			String typeStr = imagePathFileName.substring(imagePathFileName.lastIndexOf(".") + 1);
			if ("jpg".equals(typeStr) || "JPG".equals(typeStr) || "png".equals(typeStr) || "PNG".equals(typeStr) || "GIF".equals(typeStr) ||"gif".equals(typeStr) || "".equals(typeStr)) {
				// 需要修改图片的存放地址
				String newName = imagePathFileName.substring(imagePathFileName.lastIndexOf("."));
				newName = UUID.randomUUID() + newName;
				File savefile = new File(new File(String.valueOf(getFileUrlConfig().get("fileUploadRoot")) + "/"+ String.valueOf(getFileUrlConfig().get("shop")) + "/image/shopInfo"), newName);
				if (!savefile.getParentFile().exists()) {
					savefile.getParentFile().mkdirs();
				}
				FileUtils.copyFile(imagePath, savefile);
				imagePathFileName = String.valueOf(getFileUrlConfig().get("shop")) + "/image/shopInfo/" + newName;
				jo.accumulate("photoUrl", imagePathFileName);
				jo.accumulate("visitFileUploadRoot", String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot")));
			} else {
				jo.accumulate("photoUrl", "false2");
			}
		} else {
			jo.accumulate("photoUrl", "false1");
		}
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//根据id删除就条或批量删除店铺
	public void deleteShopInfo() throws IOException{
		Boolean isSuccess = shopInfoService.deleteObjectsByIds("shopInfoId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//获取一条记录
	@SuppressWarnings("rawtypes")
	public void getShopInfoById() throws IOException{
		shopInfo = (ShopInfo) shopInfoService.getObjectByParams(" where o.shopInfoId='"+ids+"'");
		Map<String,Object> jsonMap = new HashMap<String,Object>();
		if(shopInfo!=null && shopInfo.getShopCategoryId()!=null){
			ShopCategory shopCategory = (ShopCategory) shopCategoryService.getObjectByParams("where o.shopCategoryId="+shopInfo.getShopCategoryId());
			if(shopCategory!=null&&shopCategory.getShopCategoryName()!=null){
				jsonMap.put("categoryName", shopCategory.getShopCategoryName());
			}
		}
//		if(shopInfo!=null && Utils.objectIsNotEmpty(shopInfo.getCompanyCertification())){
//			String company ="";
//			String companyCertification = shopInfo.getCompanyCertification();
//			String [] keyCompany =companyCertification.split("_");
//			String keyBookHql="select a.name as name from KeyBook a where a.type='companyCertification' and a.value in ("+keyCompany[0]+")";
//			List<Map> listCompany = keyBookService.findListMapByHql(keyBookHql);
//			for(Map map :listCompany){
//				if(company==""){
//					company =map.get("name").toString();
//				}else{
//					company = company +","+map.get("name").toString();
//				}
//			}
//			if(keyCompany.length>1){
//				company = company +","+keyCompany;
//			}
//			shopInfo.setCompanyCertification(company);
//		}
		jsonMap.put("shopInfo", shopInfo);
		if(shopInfo!=null && StringUtils.isNotEmpty(shopInfo.getRegionLocation())){
			List<Map> list1= areaService.findListMapByHql("select a.name as name from BasicArea a where a.areaId="+shopInfo.getRegionLocation());
			if(list1!=null&&list1.size()>0){
				jsonMap.put("regionLocation", list1.get(0).get("name"));
			}
		}
		if(shopInfo!=null&&StringUtils.isNotEmpty(shopInfo.getCity())){
			List<Map> list1= areaService.findListMapByHql("select a.name as name from BasicArea a where a.areaId="+shopInfo.getCity());
			if(list1!=null&&list1.size()>0){
				jsonMap.put("city", list1.get(0).get("name"));
			}
		}
		if(shopInfo!=null&&StringUtils.isNotEmpty(shopInfo.getAreaCounty())){
			List<Map> list1= areaService.findListMapByHql("select a.name as name from BasicArea a where a.areaId="+shopInfo.getAreaCounty());
			if(list1!=null&&list1.size()>0){
				jsonMap.put("areaCounty", list1.get(0).get("name"));
			}
		}
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		JSONObject json =JSONObject.fromObject(jsonMap, jsonConfig); 
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(json.toString());
		out.flush();
		out.close();
	}
	//保存或修改店铺基本信息
	public void saveOrUpdateShopInfo() throws IOException, ParseException{
		Users users = (Users)request.getSession().getAttribute("users");
		shopInfo = (ShopInfo) shopInfoService.getObjectByParams(" where o.shopInfoId="+ids);
		shopInfo.setIsPass(saveIsPass);//店铺审核状态
		shopInfo.setPhoneShowStatus(savePhoneShowStatus);//是否展示联系电话
	/*	if(Utils.objectIsNotEmpty(saveShopInfoCheckSatus)){
			shopInfo.setShopInfoCheckSatus(saveShopInfoCheckSatus);//企业审核状态
			shopInfo.setVerifier(users.getUserName());
			shopInfo.setPassTime(new Date());
			shopInfo.setPassUserName(users.getUserName());
		}*/
		shopInfo.setVerifier(users.getUserName());
		if(saveIsPass.compareTo(3)==0){//审核通过 
			shopInfo.setPassTime(new Date());
			shopInfo.setShopInfoCheckSatus(2);//审核通过
			shopInfo.setVerifier(users.getUserName());
			shopInfo.setPassTime(new Date());
			shopInfo.setPassUserName(users.getUserName());
			String url = request.getContextPath();
			//String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+url+"/";
			String basePath = String.valueOf(getFileUrlConfig().get("phoneBasePath"));
			String addUrl = basePath+"/phone/shopInfo/phoneGotoShopInfoPage.action?shopInfoId="+shopInfo.getShopInfoId()+"&orderBy=normal";
			String codeUrl = QRCode.createQRPng(addUrl, null, getFileUrlConfig(), "shop" ,"image_shopInfo");
			shopInfo.setQrCode(codeUrl);
		}
		//处理佣金抽成
		String commission = request.getParameter("commission");
		if(commission!=null && !"".equals(commission)){//使用管理员录入的抽成比例
			shopInfo.setCommission(commission);
		}else{//使用程序设置的默认抽成比例（配置在systemConfig.properties文件中）
			String commissionProportion = String.valueOf(getFileUrlConfig().get("commissionProportion"));
			shopInfo.setCommission(commissionProportion);
		}
		shopInfo = (ShopInfo) shopInfoService.saveOrUpdateObject(shopInfo);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", "true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public void selectCountry() throws IOException{
		JSONArray jo = JSONArray.fromObject(regionLocationList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 批量开启或关闭
	 * @throws Exception
	 */
	public void saveOrUpdateIsCloss() throws Exception{
		boolean flag= shopInfoService.saveOrUpdateIsCloss(saveIsPass, ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", flag );
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 批量设置VIP（特定）店铺
	 * @throws Exception
	 */
	public void saveOrUpdateIsVip() throws Exception{
		//将字符串转换为字符串数组
		String[] shopInfoIds = ids.split(",");
		boolean flag= shopInfoService.saveOrUpdateIsVip(saveIsPass, shopInfoIds);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", flag );
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	//批量生成二维码
	public void shopInfoGeneratedQrCode() throws IOException{
		boolean isSuccess=false;
		String failureLog1=""; 
		String failureLog2=""; 
		if(Utils.objectIsNotEmpty(ids)){
			String basePath = String.valueOf(getFileUrlConfig().get("phoneBasePath"));
			String sql="select shopInfoId as shopInfoId, shopName as shopName from shop_shopinfo where shopInfoId in ("+ids+") ";
			List<Map<String,Object>> shopInfoList=shopInfoService.findListMapBySql(sql);
			if(Utils.objectIsNotEmpty(shopInfoList)&&shopInfoList.size()>0){
				int size=shopInfoList.size();
				for(int i=0;i<size;i++){
					if(Utils.objectIsNotEmpty(shopInfoList.get(i).get("shopInfoId"))){
						String addUrl = basePath+"/phone/shopInfo/phoneGotoShopInfoPage.action?shopInfoId="+shopInfoList.get(i).get("shopInfoId")+"&orderBy=normal";
						String codeUrl = QRCode.createQRPng(addUrl, null, getFileUrlConfig(), "shop" ,"image_shopInfo");
						isSuccess=shopInfoService.updateBySQL("update shop_shopinfo set qrCode='"+codeUrl+"' where shopInfoId="+shopInfoList.get(i).get("shopInfoId"));
						if(!isSuccess){
							if(i==size-1){
								failureLog2+=shopInfoList.get(i).get("shopName");
							}else{
								failureLog2+=shopInfoList.get(i).get("shopName")+",";
							}
						}
					}
				}
			}else{
				failureLog1="生成失败！";
			}
		}
		JSONObject jo=new JSONObject();
		jo.accumulate("failureLog1", failureLog1);
		if(Utils.objectIsNotEmpty(failureLog2)){
			jo.accumulate("failureLog2", "店铺名称为："+failureLog2+"的记录生成失败！");
		}else{
			jo.accumulate("failureLog2", failureLog2);
		}
		if(Utils.objectIsEmpty(failureLog1)&&Utils.objectIsEmpty(failureLog2)){
			isSuccess=true;
		}else{
			isSuccess=false;
		}
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter pw=response.getWriter();
		pw.print(jo.toString());
		pw.flush();
		pw.close();
	}
	
	
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public List<ShopInfo> getShopInfoList() {
		return shopInfoList;
	}
	public void setShopInfoList(List<ShopInfo> shopInfoList) {
		this.shopInfoList = shopInfoList;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public ShopInfo getShopInfo() {
		return shopInfo;
	}
	public void setShopInfo(ShopInfo shopInfo) {
		this.shopInfo = shopInfo;
	}
	public List<ShopCategory> getShopCategoryList() {
		return shopCategoryList;
	}
	public List<Map> getShopInfoListMap() {
		return shopInfoListMap;
	}
	public void setShopInfoListMap(List<Map> shopInfoListMap) {
		this.shopInfoListMap = shopInfoListMap;
	}
	public void setShopCategoryList(List<ShopCategory> shopCategoryList) {
		this.shopCategoryList = shopCategoryList;
	}
	public List<Customer> getCustomerList() {
		return customerList;
	}
	public void setCustomerList(List<Customer> customerList) {
		this.customerList = customerList;
	}
	public void setShopCategoryService(IShopCategoryService shopCategoryService) {
		this.shopCategoryService = shopCategoryService;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
	public File getImagePath() {
		return imagePath;
	}
	public void setImagePath(File imagePath) {
		this.imagePath = imagePath;
	}
	public String getImagePathFileName() {
		return imagePathFileName;
	}
	public void setImagePathFileName(String imagePathFileName) {
		this.imagePathFileName = imagePathFileName;
	}
	public List<DistrictInfo> getDistrictInfoList() {
		return districtInfoList;
	}
	public void setDistrictInfoList(List<DistrictInfo> districtInfoList) {
		this.districtInfoList = districtInfoList;
	}
	public List<DistrictInfo> getRegionLocationList() {
		return regionLocationList;
	}
	public void setRegionLocationList(List<DistrictInfo> regionLocationList) {
		this.regionLocationList = regionLocationList;
	}
	public void setAreaService(IAreaService areaService) {
		this.areaService = areaService;
	}
	public IAreaService getAreaService() {
		return areaService;
	}
	public void setKeyBookService(IKeyBookService keyBookService) {
		this.keyBookService = keyBookService;
	}
	public Integer getSaveIsPass() {
		return saveIsPass;
	}
	public void setSaveIsPass(Integer saveIsPass) {
		this.saveIsPass = saveIsPass;
	}
	public Integer getSavePhoneShowStatus() {
		return savePhoneShowStatus;
	}
	public void setSavePhoneShowStatus(Integer savePhoneShowStatus) {
		this.savePhoneShowStatus = savePhoneShowStatus;
	}
	public Integer getSaveShopInfoCheckSatus() {
		return saveShopInfoCheckSatus;
	}
	public void setSaveShopInfoCheckSatus(Integer saveShopInfoCheckSatus) {
		this.saveShopInfoCheckSatus = saveShopInfoCheckSatus;
	}
	
}
