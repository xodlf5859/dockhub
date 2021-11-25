<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>

<script>
window.onload=function(){
  	MemberPictureThumb($('#pictureView')[0],'${member.mber_photo}',
  			'<%=request.getContextPath()%>');
}  

function  changePicture_go(){
	//alert("click picture btn");
	var picture = $('input#inputFile')[0];
	
	var fileFormat = picture.value.substr(picture.value.lastIndexOf(".")+1).toUpperCase();
	
	//이미지 확장자 jpg 확인
	if(!(fileFormat=="JPG" || fileFormat=="JPEG")){
		alert("이미지는 jpg 형식만 가능합니다.");
		return;
	} 
	//이미지 파일 용량 체크
	if(picture.files[0].size>1024*1024*1){
		alert("사진 용량은 1MB 이하만 가능합니다.");
		return;
	};

	document.getElementById('inputFileName').value=picture.files[0].name;
	
	if (picture.files && picture.files[0]) {
		 var reader = new FileReader();
		 
		 reader.onload = function (e) {
	        	//이미지 미리보기	        	
	        	$('div#pictureView')
	        	.css({'background-image':'url('+e.target.result+')',
					  'background-position':'center',
					  'background-size':'cover',
					  'background-repeat':'no-repeat'
	        		});
	        }
	        
	       reader.readAsDataURL(picture.files[0]);
	} 
	
	// 이미지 변경 확인
	$('input[name="uploadPicture"]').val(picture.files[0].name);
	
}

function modify_go(){
	var form=$('form[role="form"]');	
	
	   var uploadCheck = $('input[name="checkUpload"]').val();   
//	    if(uploadCheck==0){
//	       alert("사진업로드는 필수 입니다");      
//	       return;
//	    }

	   if($('input[name="mber_password"]').val()==""){
		      alert("패스워드는 필수입니다.");
		      return;
	   }
		   
	   if($('input[name="mber_nm"]').val()==""){
	      alert("이름은 필수입니다.");
	      return;
	   }
	   
	   if($('input[name="mber_ncnm"]').val()==""){
		      alert("닉네임은 필수입니다.");
		      return;
	   }
	form.submit();
}
</script>  





