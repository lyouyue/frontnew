<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../../util/doFunction.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>每日推荐商品信息</title>
    <jsp:include page="../../util/import.jsp"/>
    <script type="text/javascript">
	$(function(){
		//表单验证
		$("#form1").validate({meta: "validate", 
			submitHandler:function(form){
					$(document).ready(function() { 
						//判断是否有选中的商品
						var rows = $("#productList").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择商品！</p>", "warning");
						}else{
							if(rows){
								var productData="";
								for(var i=0;i<rows.length;i++){
									if(i==rows.length-1)productData+=rows[i].productId+"@"+rows[i].productName;
									else productData+=rows[i].productId+"@"+rows[i].productName+",";
								}
								$("#productData").val(productData);//数据放入表单
								 var options = {  
				                     url:"${pageContext.request.contextPath}/back/dayRecommend/saveOrUpdateDayRecommend.action", 
				                     type:"post",  
				                     dataType:"json",
				                     success:function(data){ 
				                    	 queryParams={typeId:""};
				                    	 $("#productList").datagrid("reload",queryParams); //保存后重新加载列表
				                    	 closeWin();
				                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
									     $("#tt").datagrid("reload"); //保存后重新加载列表
					                 }
				                  };  
					              $("#form1").ajaxSubmit(options);
					              $("input.button_save").attr("disabled","disabled");//防止重复提交
						}	
					}
				});
              }
		});
    	$("#form2").validate({meta: "validate", 
		       submitHandler:function(form){
		       $(document).ready(
	            function() {  
	               var options = {  
	                     url:"${pageContext.request.contextPath}/back/dayRecommend/saveOrUpdateDayRecommend.action", 
	                     type:"post",  
	                     dataType:"json",
	                     success:function(data){ 
	                    	 closeWin();
	                    	 $("#tt").datagrid("clearSelections");//删除后取消所有选项
						     $("#tt").datagrid("reload"); //保存后重新加载列表
						    	
		                     }
		                  };  
		                  $("#form2").ajaxSubmit(options);
		                  $("input.button_save").attr("disabled","disabled");//防止重复提交
	               });
		       }
		    });
    	
		   $("#tt").datagrid({//数据表格
				/* title:"热销商品列表信息",
				iconCls:"icon-save",  */
				width:"auto",
				height:"auto",
				fitColumns: true,//宽度自适应
				align:"center",
				loadMsg:"正在处理，请等待......",
				//nowrap: false,//true是否将数据显示在一行
				striped: true,//true是否把一行条文化
				url:"${pageContext.request.contextPath}/back/dayRecommend/listDayRecommend.action",
				queryParams:{pageSize:pageSize},
				idField:"id",//唯一性标示字段
				frozenColumns:[[//冻结字段
				    {field:"ck",checkbox:true}
				]],
				columns:[[//未冻结字段
		            {field:"logoImages",title:"商品图片",width:80,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.id+"' onclick='showDetailInfo(this.id);'><img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='30px' height='25px' /></a>"; 
	            		}
		            }, 
					{field:"productName",title:"商品名称",width:150,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
		                return "<a style='display:block;' id='"+rowData.id+"' onclick='showDetailInfo(this.id);'>"+rowData.productName+"</a>";  
		         	  }
		            },
		            {field:"productCode",title:"商品编号",width:100}, 
					{field:"sort",title:"排序",width:40},
					{field:"isShow",title:"是否显示",width:50, 
				    	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
	                        if(value=="0"){ return "<font class='color_002'>不显示</font>";} 
	                        if(value=="1"){ return "<font class='color_001'>显示</font>";} 
                        }
                 	}
				]],
				pagination:true,//显示分页栏
				rownumbers:true,//显示行号   
				singleSelect:true,//true只可以选中一行
				toolbar:[//工具条
				    <%
					if("add".equals((String)functionsMap.get(purviewId+"_add"))){
					%> 
				    {
					text:"添加",
					iconCls:"icon-add",
					handler:function(){
						$("#addWin").css("display","");
						$("#editWin").css("display","none");
						$("#detailWin").css("display","none");
						$("#id").val("");
						createWindow(900,"auto","&nbsp;&nbsp;添加每日推荐商品","icon-add",false,"addWin");
						$("#typeId").val("16");
						$("input.button_save").removeAttr("disabled");//防止重复提交
						$("#productList").datagrid({//数据表格
							width:"auto",
							height:"auto",
							fitColumns: true,//宽度自适应
							align:"center",
							loadMsg:"正在处理，请等待......",
							striped: true,//true是否把一行条文化
							queryParams:{typeId:"",currentPage:1},
							url:"${pageContext.request.contextPath}/back/dayRecommend/listProductByType.action",
							idField:"productId",//唯一性标示字段
							frozenColumns:[[//冻结字段
							    {field:"ck",checkbox:true}
							]],
							columns:[[//未冻结字段
					            {field:"logoImg",title:"商品图片",width:80,formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
					                return "<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+value+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='30px' height='25px' />"; 
					            	}
					            },
					            {field:"productFullName",title:"商品名称",width:100},
					            {field:"productCode",title:"商品编号",width:70}, 
					            {field:"marketPrice",title:"原价(元)",width:55}, 
					            {field:"salesPrice",title:"销售价(元)",width:55},
					            {field:"isShow",title:"显示类型",width:55,
					            	formatter:function(value,rowData,rowIndex){  //function里面的三个参数代表当前字段值，当前行数据对象，行号（行号从0开始）
				                       return "<font class='color_001'>列表主商品</font>";
			                         }
					            }
							]],
							pagination:true,//显示分页栏
							rownumbers:true,//显示行号   
							singleSelect:true//true只可以选中一行
						});
						pageSplitThis(pageSize,queryParams,"productList");//调用分页函数
					}
				},"-",
				<%
				}
				if("update".equals((String)functionsMap.get(purviewId+"_update"))){
				%>
				{
					text:"修改",
					iconCls:"icon-edit",
					handler:function(){
						var rows = $("#tt").datagrid("getSelections");//找到所有选中的行
						if(rows.length<=0){
							msgShow("系统提示", "<p class='tipInfo'>请选择！</p>", "warning");
						}else if(rows.length>1){
							msgShow("系统提示", "<p class='tipInfo'>请选择一项！</p>", "warning");
						}else if(rows.length==1){
							$("#addWin").css("display","none");
							$("#editWin").css("display","");
							$("#detailWin").css("display","none");
							$("input.button_save").removeAttr("disabled");//防止重复提交
							createWindow(700,"auto","&nbsp;&nbsp;修改每日推荐商品","icon-edit",false,"editWin");
							$.ajax({
								   type: "POST", dataType: "JSON",
								   url: "${pageContext.request.contextPath}/back/dayRecommend/getDayRecommendInfo.action",
								   data: {id:rows[0].id},
								   success: function(data){
									   $("#id").val(data.id);
									   $("#logoImg").html("<img src='"+"<s:property value='%{#application.fileUrlConfig.uploadFileVisitRoot}'/>"+data.logoImg+"' onerror='this.src=\"${fileUrlConfig.sysFileVisitRoot_back}productInfo/images/mrbj.png\"' width='40px' height='40px' />");
									   $("#productId").val(data.productId);
									   $("#productCode").html(data.productCode);
									   $("#productName").html(data.productName);
									   $("#sort").val(data.sort);
									   $("#isShow_"+data.isShow).attr("checked",true);
								   }
								});   
						}
						
					}
				  },"-",
				  <%
				  }
				  if("delete".equals((String)functionsMap.get(purviewId+"_delete"))){
				  %>
				  {
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
											if(i==rows.length-1)ids+=rows[i].id;
											else ids+=rows[i].id+",";
										}
										$.ajax({
										   type: "POST",dataType: "JSON",
										   url: "${pageContext.request.contextPath}/back/dayRecommend/deleteDayRecommend.action",
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
				}]
			});
			pageSplit(pageSize);//调用分页函数
		});
    
    //修改某条记录的方法
	function updateThis(id){
		$("#addWin").css("display","none");
		$("#editWin").css("display","");
		$("input.button_save").removeAttr("disabled");//防止重复提交
		createWindow(700,"auto","&nbsp;&nbsp;修改每日推荐商品","icon-edit",false,"editWin");
		$.ajax({
			   type: "POST", dataType: "JSON",
			   url: "${pageContext.request.contextPath}/back/dayRecommend/getDayRecommendInfo.action",
			   data: {id:id},
			   success: function(data){
				   $("#id").val(data.id);
				   $("#productId").val(data.productId);
				   $("#productCode").html(data.productCode);
				   $("#productName").html(data.productName);
				   $("#sort").val(data.sort);
				   $("#isShow_"+data.isShow).attr("checked",true);
			   }
			});
	}
	//删除某条记录的方法
	function deleteThis(id){
		$.messager.confirm("系统提示", "<p class='tipInfo'>你确定要删除吗?</p>",
				function(data){
					if(data == true)
					$.ajax({
				   type: "POST", dataType: "JSON",
				   url: "${pageContext.request.contextPath}/back/dayRecommend/deleteDayRecommend.action",
				   data: {ids:id},
				   success: function(data){
					   $("#tt").datagrid("clearSelections");//删除后取消所有选项
					   if(data.isSuccess=="true")$("#tt").datagrid("reload"); //删除后重新加载列表
				   }
				});
		});
	}
	function query(){
		queryParams={selectFlag:true,pageSize:pageSize,currentPage:currentPage,productName:$("#qproductName").val(),productCode:$("#qproductCode").val()};
	  	$("#tt").datagrid("load",queryParams); 
	  	pageSplit(pageSize,queryParams);//调用分页函数
    }
	function reset(){
		$("#qproductName").val("");
		$("#qproductCode").val("");
	}
	</script>
	</head>
	<body>
	<jsp:include page="../../util/item.jsp"/>
		<!-- 查询框  -->
		<div class="main">
			<table class="searchTab">
				<tr>
					<td class="search_toright_td" style="width:85px;">商品名称：</td>
					<td class="search_toleft_td" style="width:140px;"><input type="text" id="qproductName"  name="s_productName"/></td>
					<td class="search_toright_td" style="width:80px;">商品编号：</td>
					<td class="search_toleft_td" style="width: 165px;"><input type="text" id="qproductCode" name="s_productCode"/></td>
					<td class="search_toleft_td">
						<a id="btnCancel" class="easyui-linkbutton" icon="icon-search" href="javascript:query()">查询</a>
						<a id="btnCancel" class="easyui-linkbutton" iconCls="icon-undo" href="javascript:reset()">重置</a>
					</td>
				</tr>
			</table>
			<table id="tt"></table>
			<div id="win" style="display:none;scrollbar-face-color:#C4E1FF;">
				<!-- 添加 -->
				<jsp:include page="addDayRecommend.jsp"/>
				<!-- 修改 -->
				<jsp:include page="editDayRecommend.jsp"/>
				<!-- 详情 -->
				<jsp:include page="detailDayRecommem.jsp"/>
			</div>
		</div>
	</body>
</html>
