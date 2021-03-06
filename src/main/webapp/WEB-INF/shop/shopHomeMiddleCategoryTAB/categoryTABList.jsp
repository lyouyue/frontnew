<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>首页中间部分tab维护</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"首页中间部分tab维护列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shopHomeMiddleCategoryTAB/listShopHomeMiddleCategoryTAB.action?categoryId="+'${categoryId}',
				queryParams:{pageSize:pageSize},
				idField:"categoryTabId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
					{field:"title",title:"标题",width:160,
						formatter:function(value,rowData,rowIndex){
							return "<a id='"+rowData.categoryTabId+"' onclick='showDetail(this.id);'>"+value+"</a>";
						}
					},
					{field:"synopsis",title:"描述",width:160},
					{field:"imageUrl",title:"图片",width:80,
						formatter:function(value,rowData,rowIndex){
							return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' width='60px' height='30px' />";
						}
					},
					{field:"link",title:"链接地址",width:160},
					{field:"imageType",title:"图片类型",width:160,
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							<s:iterator value="#application.homekeybook['middleTAB']" var="kb">
							     if(value==<s:property value="#kb.value"/>){
									return "<s:property value='#kb.name'/>";
								 }
							 </s:iterator>
		         	  	}
					},
					{field:"sortCode",title:"排序号",width:50},
					{field:"isShow",title:"是否显示",width:70, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
							if(value == 1){
								return "<font class='color_001'>是</font>";
							}else{
								return "<font class='color_002'>否</font>";
							}
		         	  	}
					}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[{//工具条
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						createWindow(800,450,"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#categoryTabId").val("");
						$("#fileId1").val("");
						$("#photo1").html("");
						$("#imageType_1").attr("checked","checked");
						$("#isShow_1").attr("checked","checked");
						var cid='${categoryId}';
						$("#categoryId").val(cid);
					}
				},"-",{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length==0){
							msgShow("系统提示", "<p class='tipInfo'>请选择修改项！</p>", "warning");  
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>只能修改一项！</p>", "warning");
						}else{
							$.ajax({
								   type: "POST", dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/shopHomeMiddleCategoryTAB/getShopHomeMiddleCategoryTABObj.action",
								   data: {id:rows[0].categoryTabId},
								   success: function(data){
									   $("#fileId1").val("");
									   createWindow(800,520,"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
										$("#photo1").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.imageUrl+"' width='120px' height='120px' />");
										$("#categoryTabId").val(data.categoryTabId);
										$("#imageType_"+data.imageType).attr("checked","checked");
										$("#isShow_"+data.isShow).attr("checked","checked");
										$("#categoryId").val(data.categoryId);
										$("#imageUrl1").val(data.imageUrl);
										$("#createTime").val(data.createTime);
										$("#publishUser").val(data.publishUser);
										$("#title").val(data.title);
										$("#synopsis").val(data.synopsis);
										$("#link").val(data.link);
										$("#sortCode").val(data.sortCode);
								   }
							});
						}
					}
				},"-",{
					text:"删除",
					iconCls:"icon-remove",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择删除项！</p>", "warning");
						}else{
							$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",function(data){
								if(data){//判断是否删除
									if (rows){//判断是否找到当前行，找到后异步形式从数据库中删除当前记录
										var ids="";
										for(i=0;i<rows.length;i++){
											if(i==rows.length-1)ids+=rows[i].categoryTabId;
											else ids+=rows[i].categoryTabId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/shopHomeMiddleCategoryTAB/deleteByIds.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   if(data.strFlag==true)$("#tt").datagrid("reload"); //删除后重新加载列表
										   }
										});
									}	
								}
							});
						}
					}
				},"-",{text:"刷新",
					iconCls:"icon-reload",
					handler:function(){
						$("#tt").datagrid("clearSelections");//删除后取消所有选项
						$("#tt").datagrid("reload");
					}
				}]
			});
			pageSplit(pageSize);//调用分页函数
		});
		$(function(){
		    $('#btn1').linkbutton({plain:true});   
		});
		function showDetail(id){
			$.ajax({
				   type: "POST", dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/shopHomeMiddleCategoryTAB/getShopHomeMiddleCategoryTABObj.action",
				   data: {id:id},
				   success: function(data){
						createWindow(800,400,"&nbsp;&nbsp;首页中间分类数据详情","icon-search",false,"detailWin");
						$("#dphoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.imageUrl+"' width='120px' height='120px' />");
						<s:iterator value="#application.homekeybook['middleTAB']" var="kb">
						   	if(data.imageType==<s:property value="#kb.value"/>){
						  		 $("#dimageType").html("<s:property value='#kb.name'/>");
						   	}
						</s:iterator>
						if(data.isShow==1){
							$("#disShow").html("<font class='color_001'>是</font>");
						}else{
							$("#disShow").html("<font class='color_002'>否</font>");
						}
						$("#dcreateTime").html(data.createTime);
						$("#dpublishUser").html(data.publishUser);
						$("#dupdateTime").html(data.updateTime);
						$("#dmodifyUser").html(data.modifyUser);
						$("#dtitle").html(data.title);
						$("#dsynopsis").html(data.synopsis);
						$("#dlink").html(data.link);
						$("#dsortCode").html(data.sortCode);
				   }
			});
		}
    	function query(){
    		queryParams={pageSize:pageSize,currentPage:currentPage,title:$("#title1").val(),isShow:$("#isShow").val(),imageType:$("#imageType").val()};
    	  	$("#tt").datagrid("load",queryParams); 
    	  	pageSplit(pageSize,queryParams);//调用分页函数
        }
    	function reset(){
    		$("#title1").val("");
    		$("#isShow").val("")
    		$("#imageType").val("");
        }
    </script>
  </head>
  <body>
		<table class="searchTab">
			<tr>
				<td class="search_toright_td" style="width:60px;">标题：</td>
				<td class="search_toleft_td" style="width:170px;"><input type="text" style="width: 160px;" id="title1" /></td>
				<td class="search_toright_td" style="width:80px;">图片类型：</td>
				<td class="search_toleft_td" style="width: 90px;">
					<select id="imageType" >
						<option value="">--请选择--</option>
						<s:iterator value="#application.homekeybook['middleTAB']" var="kb">
							<option value="<s:property value='#kb.value'/>" ><s:property value="#kb.name"/></option>
					 	</s:iterator>
					</select>
				</td>
				<td class="search_toright_td" style="width: 75px;">是否显示：</td>
				<td class="search_toleft_td" style="width:105px;">
					<select id="isShow" >
						<option value="">--请选择--</option>
						<option value="0" >否</option>
						<option value="1" >是</option>
					</select></td>
			   <td class="search_toleft_td">
				    <a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>&nbsp;&nbsp;
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
		    </tr>
  		</table>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		   <!-- 详情 -->
		  <jsp:include page="detail.jsp"/>
		</div>
  </body>
</html>
