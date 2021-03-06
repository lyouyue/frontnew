<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>会员等级信息信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
    $(function(){
		   $("#tt").datagrid({//数据表格
				title:"会员等级列表信息",
				iconCls:"icon-save", 
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/customerCredit/listCustomerCredit.action",
				queryParams:{pageSize:pageSize},
				idField:"customerCreditId",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"customerCreditId",title:"等级编号",width:120, formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.customerCreditId+"' onclick='showDetailInfo(this.id);'>"+rowData.customerCreditId+"</a>";  
		         	  }  
					}, 
					{field:"capacityValue",title:"能力值",width:120},
					{field:"buyerRank",title:"买家头衔",width:120},  
					{field:"minRefValue",title:"最小值",width:120},  
					{field:"maxRefValue",title:"最大值",width:120},  
					{field:"updName,delName",title:"操作",width:120, 
						formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		               		return "<a id='"+rowData.customerCreditId+"' onclick='updOrDelSA(this.id,"+rowData.customerCreditId+",1);'>"+"修改"+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a id='"+rowData.customerCreditId+"' onclick='updOrDelSA(this.id,"+rowData.customerCreditId+",2);'>"+"删除"+"</a>";  
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
						createWindow(900,'auto',"&nbsp;&nbsp;添加","icon-add",false,"addOrEditWin");
						$("#addOrEditWin").css("display","");
						$("#detailWin").css("display","none");
						$("#buyerPhoto").html("");
						$("#sellerPhoto").html("");
						$("#customerCreditId").val(null);
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
											if(i==rows.length-1)ids+=rows[i].customerCreditId;
											else ids+=rows[i].customerCreditId+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/customerCredit/deletecustomerCredit.action",
										   data: {ids:ids},
										   success: function(data){
											   $("#tt").datagrid("clearSelections");//删除后取消所有选项
											   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
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
    	function updOrDelSA(id,rowid,flag){
    		if(flag == 1){
    			createWindow(900,'auto',"&nbsp;&nbsp;修改","icon-edit",false,"addOrEditWin");
    			$.ajax({
					   type: "POST", dataType: "JSON",
					    url: "${pageContext.request.contextPath}/back/customerCredit/getCustomerCreditObject.action",
					   data: {customerCreditId:id},
					   success: function(data){
						   $("#customerCreditId").val(data.customerCreditId);
						   $("#capacityValue").val(data.capacityValue);
						   $("#buyerRank").val(data.buyerRank);
						   $("#buyerIcon").val(data.buyerIcon);
						   $("#buyerPhoto").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.buyerIcon+"' width='40px' height='20px' />");
					   	   $("#minRefValue").val(data.minRefValue);
						   $("#maxRefValue").val(data.maxRefValue);
					   }
					});
    		}else{
    			$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
    				function(data){
    					if(data == true)
    					$.ajax({
						   type: "POST", dataType: "JSON",
						   url: "${pageContext.request.contextPath}/back/customerCredit/deleteCustomerCredit.action",
						   data: {ids:id},
						   success: function(data){
							   $("#tt").datagrid("clearSelections");//删除后取消所有选项
							   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
						   }
						});
				});
    		}
    	}
    	
    </script>
  </head>
  
  <body>
  		<table id="tt"></table>
  		<div id="win" style="display:none;overflow-y:auto;scrollbar-face-color:#C4E1FF;">
		   <!-- 添加或者修改 -->
		  <jsp:include page="addOrEditor.jsp"/>
		  <!-- 详情页 -->
		  <jsp:include page="detail.jsp"/>
		</div>
  </body>
</html>
