<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <script type="text/javascript">
	$(function() {
		$('#output_Form').form({
			url : '${pageContext.request.contextPath}/storageAction!outputData.action',
			onSubmit:function(param){
				var rows = $('#inList_datagrid').datagrid('getChecked'); 
				var ids = [];
				for ( var i = 0; i < rows.length; i++) {
					ids.push(rows[i].id);
				}
				param.ids = ids;    
				return $(this).form('validate');
			},
			success : function(r) {
				var obj = jQuery.parseJSON(r);
				if (obj.success) {
					$('#output_Dialog').dialog('close');
					$('#inList_datagrid').datagrid('load');
					$('#inList_datagrid').datagrid('unselectAll');
					$.messager.show({
						title : '提示',
						msg : r.msg
					});
				}
				$.messager.show({
					title : '提示',
					msg : obj.msg
				});
			}
		});
		
		
		$('#output_Form input').bind('keyup', function(event) {/* 增加回车提交功能 */
			if (event.keyCode == '13') {
				$('#output_Form').submit();
			}
		});
		$('#inList_datagrid').datagrid({
			url : '${pageContext.request.contextPath}/storageAction!inList.action',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			rownumbers:true,
			singleSelect : true,
			pageSize : 10,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'eqNumb',
			sortOrder : 'asc',
			/*pagePosition : 'both',*/
			checkOnSelect : false,
			selectOnCheck : false,
			frozenColumns : [ [ {
				field : 'id',
				title : '编号',
				width : 100,
				checkbox : true
			}, {
				field : 'eqNumb',
				title : '设备数量',
				width : 100,
				sortable : true
			} ] ],
			columns : [ [ {
				field : 'storageNumb',
				title : '状态',
				width : 100,
				styler:function(value, row, index){
					if(value==0){
						return 'background-color:#ffee00;color:red;';
					}
				},
				formatter:function(value, row, index){
					if(value==0){
						return '在库中';
					}
				},
				sortable : true
			}, {
				field : 'storageParam',
				title : '参数',
				width : 100,
				sortable : true
			}, {
				field : 'storageW',
				title : '温度',
				width : 150,
				sortable : true
			},{
				field : 'storageS',
				title : '湿度',
				width : 100,
				sortable : true
			}
			] ],
			toolbar : [ '-',{
				text : '出库',
				iconCls : 'icon-remove',
				handler : function() {
					outputData();
				}
			}, '-', 
			]
		});
	});

	function clearFun() {
		$('input[name=storageNumb]').val('');
		$('#inList_datagrid').datagrid('load', {});
	}
	 
	function outputData() {
		var rows = $('#inList_datagrid').datagrid('getChecked'); 
		var ids = [];
		if (rows.length > 0) {
			$('#output_Dialog').dialog('open');
			for ( var i = 0; i < rows.length; i++) {
				ids.push(rows[i].id);
			}
		} else {
			$.messager.show({
				title : '提示',
				msg : '请勾选要出库的记录！'
			});
		}
	}

</script>
  
<div id="inList_layout" class="easyui-layout" data-options="fit:true,border:false">
	<div id="output_Dialog" class="easyui-dialog" data-options="title:'出库',width: 250,    
    height: 110,closed:true, modal:true,
				closable:true, buttons:[{
				text:'出库',
				iconCls:'icon-add',
				handler:function(){
					$('#output_Form').submit();
				}
			}]">
	<form id="output_Form" method="post" > 
		<table>
			<tr>
				<th>机房号：</th>
				<td><input type="text" name="storageNumb" class="easyui-numberbox"   data-options="min:0,precision:0"/>  
				</td>
			</tr>
		</table>
	</form>
</div>
	<div data-options="region:'center',border:false">
		<table id="inList_datagrid"></table>
	</div>
</div>
