<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
 <div id="addOrEditWin" >
	<form id="form1"  method="post" action="">
		<input id="parentId" type="hidden" name="tuanProductType.parentId" value=""/>
		<input id="tuanProductTypeId" type="hidden" name="tuanProductType.tuanProductTypeId" value=""/>
		<input id="createTime" type="hidden" name="tuanProductType.createTime" value="">
		<table align="center" class="addOrEditTable" width="600px;">
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>分类名称:&nbsp;&nbsp;</td>
				<td  class="toleft_td">&nbsp;&nbsp;<input id="u_sortName" type="text" name="tuanProductType.sortName" value="" class="{validate:{required:true,maxlength:[15]}}"/></td>
			</tr>
			<tr>
				<td class="toright_td" width="150px"><span style="color:red">* </span>排序编码:&nbsp;&nbsp;</td>
				<td class="toleft_td">&nbsp;&nbsp;<input id="u_sortCode" type="text" maxlength="2" name="tuanProductType.sortCode" value="" class="{validate:{required:true,number:true}}"/></td>
			</tr>
		</table>
		<div class="editButton"  data-options="region:'south',border:false" >
			<a id="btnSave" class="easyui-linkbutton" icon="icon-save" onclick="$('#form1').submit()" href="javascript:;">保存</a>
			<a id="btnCancel" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin()" href="javascript:;">取消</a>
		</div>
	</form>
 </div>
