<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>热销分类排行统计信息</title>
    <meta http-equiv="Cache-Control" content="no-cache"/>
  	<meta http-equiv="Expires" content="-1"/>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
    	$("#tt").datagrid({//数据表格
			/* title:"热门分类销售统计信息",
			iconCls:"icon-save",  */
			width:"auto",
			height:"auto",
			fitColumns: true,//宽度自适应
			align:"center",
			loadMsg:"正在处理，请等待......",
			//nowrap: false,//true是否将数据显示在一行
			striped: true,//true是否把一行条文化
			url:"${pageContext.request.contextPath}/back/hotCategoryStatistics/listHotCategoryStatistics.action", 
			idField:"productTypeId",//唯一性标示字段
			columns:[[//未冻结字段
	            {field:"sortName",title:"套餐分类名称",width:80},
	            {field:"count",title:"订单数量",width:80}
			]],
			pagination:true,//显示分页栏
			rownumbers:true,//显示行号   
			singleSelect:true,//true只可以选中一行
			toolbar:[//工具条
			<%
			if("export".equals((String)functionsMap.get(purviewId+"_export"))){
			%>     
			{
	 			text:"导出报表",
	 			iconCls:"icon-redo",
	 			handler:function(){
	 				window.location.href="${pageContext.request.contextPath}/back/hotCategoryStatistics/exportCountModFuleExcel.action?createTime="+$("#qcreateTime").val()+"&createTime2="+$("#qcreateTime2").val()+"&sortName="+$("#qsortName").val();
	 			}
			},"-",
			<% 
			}
			%>
			{text:"刷新",
				iconCls:"icon-reload",
				handler:function(){
					$("#tt").datagrid("clearSelections");//删除后取消所有选项
					$("#tt").datagrid("reload");
				}
			}],
		});
		pageSplit(pageSize);//调用分页函数
	});
	 
 	 	function query(){
 	  	  	queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,sortName:$("#qsortName").val(),createTime:$("#qcreateTime").val(),createTime2:$("#qcreateTime2").val()};
 	  	  	$("#tt").datagrid("load",queryParams); 
 	  	  	pageSplit(pageSize,queryParams);//调用分页函数
       	}

		function reset(){
			$("#qsortName").val("");
	       	$("#qcreateTime").val("");
	    	$("#qcreateTime2").val("");
		}
	</script>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<!-- 查询框  -->
	<div class="main">
		<form id="formShopPar" action="${pageContext.request.contextPath}/back/shopCustomerService/gotoShopCustomerServicePage.action" method="post">
			<input id="shopName"  type="hidden" name="shopName"/>
			<input id="ids"  type="hidden" name="ids"/>
		</form>
		<table   class="searchTab">
			<tr>
				<td class="toright_td" style="width: 105px;">套餐分类名称：</td>
				<td class="toleft_td" style="width:155px;">
					<input type="text" id="qsortName" name="sortName" class="searchTabinput"/>
				</td>
				<td class="toright_td" style="width:75px;">交易日期：</td>
				<td class="toleft_td" style="width:300px;">
					<input id="qcreateTime" style="width: 120px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qcreateTime2\')}'})"/>
					- <input id="qcreateTime2" style="width: 120px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qcreateTime\')}'})"/>
				</td>
				<td class="toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
					<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
			<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
				<form id="form1"></form>
			</div>
		</div>
	</body>
</html>
