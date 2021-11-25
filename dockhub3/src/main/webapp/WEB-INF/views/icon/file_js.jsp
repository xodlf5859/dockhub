<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.7.7/handlebars.min.js"></script>
<script type="text/x-handlebars-template"  id="file-list-template" >

<div class="fileLi">

<form id="check" name ="check" method="post">
<table class="table table-bordered table-hover">
	<tr>
		<th style="width : 5%; text-align : center;">NO</th>
		<th style="width : 8%; text-align : center;">종류</th>
		<th  style="">이름</th>
		<th  style="width : 10%; text-align : center;">작성자</th>
		<th style="width : 15%; text-align : center;">크기</th> 
		<th style="width : 25%;">수정일시</th> 
	</tr>
{{#if .}}

{{else}}
<tr  style='pointer-events : none;height : 245px'>
	<td colspan="6" style="text-align : center;">해당 폴더에 파일이 존재하지 않습니다.</td>
</tr>
{{/if}}
{{#each .}}
	<tr>
		<td><input type="checkbox" name="checkFile" class="checkFile" onchange="checkCr(this)"value="{{filesave_sn}}"></td>
		<td style="text-align : center;">
			{{#icon filesave_ty}}
				{{filesave_ty}}
			{{/icon}}
		</td>
		<td {{#folder filesave_ty filesave_sn}}{{/folder}}>{{#name filesave_nm}}{{/name}}</td>
		<td style="text-align : center;">{{crtr_ncnm}}</td>
		<td>{{#size filesize}}{{/size}}</td>
		<td style="font-size : small">
			{{filesave_update_time }}
		</td>
	</tr>
{{#listsize @last @index}}{{/listsize}}			
{{/each}}

</table>
</form>
</div>
</script>

<script type="text/x-handlebars-template"  id="file-pagination-template" >
<li class="paginate_button page-item">
   <a href="1" aria-controls="example2" data-dt-idx="1" tabindex="0" class="page-link">
      <i class='fas fa-angle-double-left'></i>
   </a>
</li>
<li class="paginate_button page-item">
   <a href="{{#if prev}}{{prevPageNum}}{{/if}}" aria-controls="example2" data-dt-idx="1" tabindex="0" class="page-link">
      <i class='fas fa-angle-left'></i>
   </a>
</li>
{{#each pageNum}}
<li class="paginate_button page-item {{signActive this}} ">
   <a href="{{this}}" aria-controls="example2" data-dt-idx="1" tabindex="0" class="page-link">
      {{this}}
   </a>
</li>
{{/each}}

<li class="paginate_button page-item ">
   <a href="{{#if next}}{{nextPageNum}}{{/if}}" aria-controls="example2" data-dt-idx="1" tabindex="0" class="page-link">
      <i class='fas fa-angle-right'></i>
   </a>
</li>
<li class="paginate_button page-item">
   <a href="{{realEndPage}}" aria-controls="example2" data-dt-idx="1" tabindex="0" class="page-link">
      <i class='fas fa-angle-double-right'></i>
   </a>
</li>   
</script>
<script>



function fileDownload(){
	$("input[name=checkFile]:checked").each(function(){
		var filesave_sn = $(this).val();
		/* console.log(filesave_sn); */

		location.href="<%=request.getContextPath() %>/myFile/getFile.do?filesave_sn="+filesave_sn;
	
	});
	$("input[name=checkFile]:checked").prop("checked", false);
}





function deleteFile1(){

	$("input[name=checkFile]:checked").each(function(){
		var filesave_sn = $(this).val();
		$.ajax({
			url:"<%=request.getContextPath()%>/myFile/deleteNode?id="+filesave_sn,
			type:"post",
			success : function(){
			var node = $("#nodeId").val();
			var page = $("#filePage").val();	
			getPage("<%=request.getContextPath()%>/myFile/getFile/"+node+"/"+page);
				
			},
			error : function(){
				alert("파일삭제가 실패했습니다.");
			}
		});
		

	})
	
	$("input[name=checkFile]:checked").prop("checked", false);
	$("#deleteFile").hide();
}


var filePage=1;
function ajaxFileUploadm(){
	$("#uploadFile").click();
}
function ajaxFileChangem(){
	ajaxFileTransmitm();
}
function ajaxFileTransmitm(){
	var form = $("#ajaxForm")[0];
	console.log(form)
	var data = new FormData(form);
	
	$.ajax({
		url : "<%=request.getContextPath() %>/myFile/regist.do",
		type : "POST",
		data : data,
		processData : false,
		contentType:false,
		cache : false,
		success : function(){
			var node = $("#nodeId").val();
			getPage("<%=request.getContextPath()%>/myFile/getFile/"+node+"/"+1);
			$("#nodeId").val(node);
	
		},
		error : function(){
			alert("upload fail");
		}
		
	})
}



function getTreeData(){
	
	$.ajax({
		url:"<%=request.getContextPath()%>/myFile/getFileList",
		type:"post",
		contentType:'application/json',
		success:function(data){
			var arr=[];
			$.each(data,function(i,v){
				
				var obj = {};
				obj.id = v.filesave_sn;
				obj.text = v.filesave_nm;
				if (v.upper_file_sn==0) {
					obj.parent="#";
					obj.state={
						opened:true
					}
				}else{
					obj.parent = v.upper_file_sn;
					
				}
				arr.push(obj);
			})
			
			$("#tree").jstree(true).settings.core.data = arr;
			$("#tree").jstree(true).refresh();		
		},
		error:function(){
			alert('서버 연결을 실패했습니다.2');	
		}
	}); 
}
function printData(replyArr,target,templateObject){
	   var template = Handlebars.compile(templateObject.html());
	   var html = template(replyArr);
	   $('.fileLi').remove();
	   target.after(html);
	}

function getPage(pageInfo){

   $.ajax({
	   url : pageInfo,
	   type : "post",
	   contentType:"application/json",
	   success : function(data){
	   		printData(data.fileList,$('#filesDiv'),$('#file-list-template'));
	   		if (data.fileList.length != 0) {
		   		printPagination(data.pageMaker,$('ul#pagination'),$('#file-pagination-template'));
			}else{
				$("#pagination").empty();
			}
	   },
	   error : function(error){
		   //e.printStackTrace();
	   	 	AjaxErrorSecurityRedirectHandler(error.status);
	   }
   });
}

Handlebars.registerHelper({
	   "prettifyDate":function(timeValue){ //Handlebars에 날짜출력함수 등록
	      var dateObj = new Date(timeValue);
	      var year   = dateObj.getFullYear(); //4자리
	      var month   = dateObj.getMonth()+1; //0부터이므로 +1
	      var date   = dateObj.getDate(); //date는 날짜 day는 요일
	      return year+"/"+month+"/"+date;
	   },

	   "signActive":function(pageNum){
		   var page = $("#filePage").val();
	      if(pageNum==page) return 'active';
	   },
	   "folder" : function(filesave_ty, filesave_sn){
		   
		   if (filesave_ty==null) {
			return 'onClick=selectFolder('+filesave_sn+')';
			}else{
			return null;
			}
	   },
	   "icon" : function(filesave_ty){
		  if(filesave_ty == null){
			  return '<i class="far fa-folder-open fa-lg"></i>';
			  
		  }else if(filesave_ty == "jpg" || filesave_ty == "png"|| filesave_ty == "JPG"|| filesave_ty == "PNG"){
			  return '<i class="far fa-file-image fa-lg " style="color : dodgerblue"></i>';
		  }else if(filesave_ty =="txt" || filesave_ty == "TXT"){
			  return '<i class="far fa-file-alt fa-lg"></i>';
		  }else if(filesave_ty =="pdf" || filesave_ty == "PDF"){
			  return '<i class="far fa-file-pdf fa-lg" style="color : crimson"></i>';
		  }else if(filesave_ty =="doc" || filesave_ty == "docx"||filesave_ty =="DOC" || filesave_ty == "DOCX"||filesave_ty =="hwp" || filesave_ty == "HWP"){
			  return '<i class="far fa-file-word fa-lg" style="color : tomato"></i>';
		  }else if(filesave_ty =="xls" || filesave_ty == "xlsx"||filesave_ty =="XLS" || filesave_ty == "XLSX"){
			  return '<i class="far fa-file-excel fa-lg" style="color : olivedrab"></i>';
		  }else if(filesave_ty =="ppt" || filesave_ty == "pptx"||filesave_ty =="PPT" || filesave_ty == "PPTX"){
			  return '<i class="far fa-file-powerpoint fa-lg" style="color : chocolate"></i>';
		  }
	   },
	   "size" :function(filesize){
		   if (filesize!=0) {
			   return byteCalculation(filesize);
			}else{
				return "";
			}

	   },
	   "name" : function(filename){
		   if (filename.length>13) {
			return filename.substr(0,14)+"...";
		}else{
			return filename;
		}
	   },
		"listsize" : function(last, index){
			var returnStr = "";
			if (last==true) {
				if (index != 5) {
					var forCnt = (4-index);
					for (var i = 0; i < forCnt; i++) {
					returnStr += "<tr style='pointer-events : none;height : 49px'><td></td><td></td><td></td><td></td><td></td><td></td></tr>";
					}
				}
			}
			return returnStr;
		}

	   
	}) 
 
function byteCalculation(bytes) {
	var bytes = parseInt(bytes);
	var s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
	var e = Math.floor(Math.log(bytes)/Math.log(1024));
	if(e == "-Infinity") return "0 "+s[0]; 
	else 
	return (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e];
}



	
	
function selectFolder(filesave_sn){
	$("#"+filesave_sn+"_anchor").trigger('click');
	
}	
function printPagination(pageMaker,target,templateObject){
	var pageNum = new Array(pageMaker.endPage-pageMaker.startPage+1);
	
	for(var i=0;i<pageMaker.endPage-pageMaker.startPage+1;i++){
	   pageNum[i]=pageMaker.startPage+i;
	}
	pageMaker.pageNum=pageNum;
	pageMaker.prevPageNum=pageMaker.startPage-1;
	pageMaker.nextPageNum=pageMaker.endPage+1;
	
	var template = Handlebars.compile(templateObject.html());
	var html = template(pageMaker);
	target.html("").html(html);
}


function removeName(){
	 $("#fileName").empty(); 
}

function checkCr(check){
	
	var arr=[];
	$("input[name=checkFile]:checked").each(function(){
		var filesave_sn = $(this).val();
		arr.push(filesave_sn);		
	});
	
	$.ajax({
	   url : "<%=request.getContextPath()%>/myFile/getCrtr",
	   data : JSON.stringify(arr),
	   type : "post",
	   contentType:"application/json",
	   success : function(data){
	   		if (data == "ok") {
		   		$("#deleteFile").show();						
			}else if(data =="no"){
				$("#deleteFile").hide();				
			}
	   },
	   error : function(error){
		   error.printStackTrace();
		  	
	   	 	//AjaxErrorSecurityRedirectHandler(error.status);
	   }
	}); 

	
}
window.onload= function(){
	$("#deleteFile").hide();
	$("#delete").val("");
/* 	$('input[type="checkbox"]').change(function(){
		alert("///");
	}) */

 	$.ajax({
		url:"<%=request.getContextPath()%>/myFile/getFileList",
		type:"post",
		contentType:'application/json',
		success:function(data){
			var arr=[];
			$.each(data,function(i,v){
				var obj = {};
				obj.id = v.filesave_sn;
				obj.text = v.filesave_nm;
				if (v.upper_file_sn==0) {
					obj.parent="#";
					obj.state={
						opened:true
					}
				}else{
					obj.parent = v.upper_file_sn;
					
				}
				arr.push(obj);
			})
			$('#tree').jstree({ 
				'core' : { 
					'data' : arr,
					"check_callback" : true
						
				},
				"plugins" : ["dnd","contextmenu", "wholerow"],
				"cookies" : {
					"save_selected" : false
				},
				'contextmenu' : {
					"select_node" : false,
					items : function (o, cb) { // Could be an object directly
				         return {
				            "create" : {
				            	
				               "separator_before"   : false,
				               "separator_after"   : true,
				               "_disabled"         : false, //(this.check("create_node", data.reference, {}, "last")),
				               "label"            : "Create",
				               "action"         : function (data) {
				                  var inst = $.jstree.reference(data.reference),
				                     obj = inst.get_node(data.reference);
				                  inst.create_node(obj, {}, "last", function (new_node) {
				                     try {
				                        inst.edit(new_node);
				                     } catch (ex) {
				                        setTimeout(function () { inst.edit(new_node); },0);
				                     }
				                  });
				                  
				               }
				            },
				            "rename" : {
				            	
				               "separator_before"   : false,
				               "separator_after"   : false,
				               "_disabled"         : false, //(this.check("rename_node", data.reference, this.get_parent(data.reference), "")),
				               "label"            : "Rename",
				               "action"         : function (data) {
				                  var inst = $.jstree.reference(data.reference),
				                    obj = inst.get_node(data.reference);
				                  	inst.edit(obj);
				               }
				            },
				            "remove" : {
				               "separator_before"   : false,
				               "icon"            : false,
				               "separator_after"   : false,
				               "_disabled"         : false, //(this.check("delete_node", data.reference, this.get_parent(data.reference), "")),
				               "label"            : "Delete",
				               "action"         : function (data) {
				            	    var result = confirm('포함된 파일이 전부 삭제되고 복구가 불가합니다. \n정말 삭제하시겠습니까?'); 
				            	   if(result) { //yes    
					                  var inst = $.jstree.reference(data.reference),
					                     obj = inst.get_node(data.reference);
					                  if(inst.is_selected(obj)) {
					                     inst.delete_node(inst.get_selected());
					                  }
					                  else {
					                     inst.delete_node(obj);
					                  }
				            	   } else { //no 
				            		   
				            	   } 
				               }
				            }
				       };
				  }
				}
					
			});			
		},
		error:function(){
			alert('서버 연결을 실패했습니다.1');	
		}
	}); 
 	
	$('#tree').on('move_node.jstree',function(e,data){
// 		console.log(data.node.id);
// 		console.log(data.parent);
		$.ajax({
			url:"<%=request.getContextPath()%>/myFile/moveNode?id="+data.node.id+"&parent="+data.parent,
			type:"post",
			success : function(res){
				
				var node = $("#nodeId").val();
				var page = $("#filePage").val();
				getPage("<%=request.getContextPath()%>/myFile/getFile/"+node+"/"+page);
				
			},
			error : function(){
				alert("파일이동이 실패했습니다.");
			}
		}); 
		
	});

  $("#tree").bind("delete_node.jstree",(function(event, data) {
		  $.ajax({
				url:"<%=request.getContextPath()%>/myFile/deleteNode?id="+data.node.id,
				type:"post",
				success : function(){
				var node = $("#nodeId").val();
				var page = $("#filePage").val();	
				if (data.node.id == node) {
					 	node = $("#parent").val();
					 	page = 1;
				}
				getPage("<%=request.getContextPath()%>/myFile/getFile/"+node+"/"+page);
					
				},
				error : function(){
					alert("파일삭제가 실패했습니다.");
				}
			});
	}));
  
  $("#tree").bind("rename_node.jstree",(function(event, data) {
	  $.ajax({
			url:"<%=request.getContextPath()%>/myFile/renameNode?id="+data.node.id+"&text="+data.text,
			type:"post",
			success : function(res){
				//var from = $("#from").val();
				//console.log(data.node.id, data.node.parent);
				var node = $("#nodeId").val();
				var page = $("#filePage").val();
				getPage("<%=request.getContextPath()%>/myFile/getFile/"+node+"/"+page);
				
// 				data.node.text = data.text;
				//data.inst.refresh();
// 				$("#tree").jstree(true).settings.core.data = data;
// 				$("#tree").jstree(true).refresh();
				getTreeData();
				$("#from").val("rename");
				
			},
			error : function(){
				alert("이름변경이 실패했습니다.");
			}
		});
	}));
  
  $("#tree").bind("create_node.jstree",(function(event, data) {
	  console.log(data.node.parent)
	 $.ajax({
			url:"<%=request.getContextPath()%>/myFile/createNode?parent="+data.node.parent+"&prjct_sn="+prjct_sn,
			type:"post",
			success : function(res){
				/* var node = $("#nodeId").val(); */
				data.node.id = res;
				data.node.text = data.text;
// 				$("#from").val("create");
	 			$("#nodeId").val(data.node.parent);
				$("#filePage").val(1); 
				//$(data.node).trigger("select_node.jstree");
				//selectNode(data);
				/* selectFolder(data.node.parent); */
				getPage("<%=request.getContextPath()%>/myFile/getFile/"+data.node.parent+"/"+1);
				
			},
			dataType : "text"
		});
	}));

  $('#tree').bind('select_node.jstree', function(event, data){
	  var from = $("#from").val();
	  if (from == "rename") {
		$("#from").val("");
		  return;
		
	}
<%--  	$.ajax({
 		url:"<%=request.getContextPath()%>/myFile/getParent?prjct_sn="+prjct_sn,
		type:"post",
		success : function(res){
			getPage("<%=request.getContextPath()%>/myFile/getFile/"+res+"/"+filePage);
			$("#nodeId").val(res);
			$("#parent").val(res);
		},
		dataType : "text"
 	}); 	 --%>

 	 $("#fileName").empty(); 
 	var parent = $("#parent").val();
 	
 	for (var i = data.node.parents.length-1; i >= 0; i--) {
 		 if(data.node.parents[i]!="#"){
 			 if (data.node.parents[i]!=parent) {
		 		$.ajax({
		 	 		url:"<%=request.getContextPath()%>/myFile/getName?filesave_sn="+data.node.parents[i],
		 			type:"post",
		 			success : function(res){
					 	$("#fileName").append(" > "+res);
		 			},
		 			dataType : "text",
		 			async : false
		 	 	});
		 		
			}
		}
 	}
 	 $("#fileName").append(" > "+data.node.text); 
	//$("#fileName").append(">"+data.node.text); 
	   
	  var page = 1;
	  if(data.node.id == $("#nodeId").val()){
		  page =$("#filePage").val(); 
	  }
		$("#nodeId").val(data.node.id);
		$("#filePage").val(page);
		getPage("<%=request.getContextPath()%>/myFile/getFile/"+data.node.id+"/"+page);
		
		
		$("input[name=checkFile]:checked").prop("checked", false);
		$("#deleteFile").hide();
		
	}); 
  

	getPage("<%=request.getContextPath()%>/myFile/getFile/"+0+"/"+1);
	$("#nodeId").val(0);
	$("#parent").val(0); 
	
   
   /* pagenation 에 클릭이벤트를 주되 나올때  li, a를 거쳐서 나오면 실행해달라 */
   $('ul.pagination').on('click','li a',function(event){
      // $(this) : event.currentTarget 여기서는 a(currentTarget), li, pagination(target) 
      if($(this).attr("href")){
         filePage=$(this).attr("href");
         var node = $("#nodeId").val();
         $("#filePage").val(filePage);
 		 getPage("<%=request.getContextPath()%>/myFile/getFile/"+node+"/"+filePage);			
        
         
         
        }
		$("input[name=checkFile]:checked").prop("checked", false);
		$("#deleteFile").hide();
      return false;
      });
   
 

}



</script>