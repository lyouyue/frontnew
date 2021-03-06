<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="../../util/doFunction.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>会员分享注册信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				/* title:"分享注册列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/shareRigster/listShareRigster.action",
				queryParams:{pageSize:pageSize},
				idField:"shareRegisterId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
// 					{field:"shareRegisterId",title:"分享注册ID",width:80},
					{field:"rcName",title:"推荐人名称",width:120},
					{field:"scName",title:"被推荐人名称",width:120},
					{field:"giveCoinNumber",title:"赠送金币数",width:120},
					{field:"shareTime",title:"分享时间",width:120}
			
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[
					<% 
					if("export".equals((String)functionsMap.get(purviewId+"_export"))){
					%>
					{//工具条
						text:"导出报表",
						iconCls:"icon-redo",
						handler:function(){
							window.location.href="${pageContext.request.contextPath}/back/shareRigster/exportShareRigsterExcel.action?shareCustomerName="+$("#shareCustomerName").val()+"&registerCustomerName="+$("#registerCustomerName").val()+"&registerDate="+$("#qregisterDate").val()+"&registerDate2="+$("#qregisterDate2").val();
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
					}
				]
			});
			pageSplit(pageSize);//调用分页函数
		});
    	function query(){
    		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,shareCustomerName:$("#shareCustomerName").val(),registerCustomerName:$("#registerCustomerName").val(),registerDate:$("#qregisterDate").val(),registerDate2:$("#qregisterDate2").val()};
    	  	$("#tt").datagrid("load",queryParams); 
    	  	pageSplit(pageSize,queryParams);//调用分页函数 
        }
    	function reset(){
    		$("#shareCustomerName").val("");
           	$("#registerCustomerName").val("");
        	$("#qregisterDate").val("");
        	$("#qregisterDate2").val("");
    	}
    </script>
	<style type="text/css">
		 .linkbtn{margin-top: 5px;margin-right: 10px;}
		 .linkbtn a{height:10px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
		 .querybtn{margin-top: 5px;margin-right: 10px;height:20px;}
		 .querybtn a{height:8px; font-size:14px; margin-top: 5px;width:70px;border: 1px #4F9D9D solid; background:#ECF5FF;font-weight: bolder;color:#003D79;}
	</style>
</head>
<body>
	<jsp:include page="../../util/item.jsp"/>
	<div class="main">
		<table class="searchTab">
			<tr>
				<td class="search_toright_td"  style="width:100px;">推荐人名称：</td>
				<td class="search_toleft_td"  style="width: 165px;"><input type="text" id="shareCustomerName" name="rigsterName" />&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width: 100px;">被推荐人名称：</td>
				<td class="search_toleft_td" style="width: 170px;"><input type="text" id="registerCustomerName" name="chareName" />&nbsp;&nbsp;</td>
				<td class="search_toright_td" style="width: 75px;">分享时间：</td>
				<td class="search_toleft_td" style="width: 255px;">
					<input id="qregisterDate" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'qregisterDate2\')}'})"/>
					- <input id="qregisterDate2" style="width: 100px;" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'qregisterDate\')}'})"/>
				</td>
				<td class="search_toleft_td">
					<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query();">查询</a>
					<a id="btnCancel" class="easyui-linkbutton"  iconCls="icon-undo" href="javascript:reset();">重置</a>
				</td>
			</tr>
		</table>
		<table id="tt"></table>
		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;"></div>
	</div>
</body>
</html>
