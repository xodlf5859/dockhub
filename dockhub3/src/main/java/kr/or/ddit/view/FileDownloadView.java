package kr.or.ddit.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.MediaType;
import org.springframework.web.servlet.View;

import kr.or.ddit.util.MakeFileName;

public class FileDownloadView implements View {

	private String contentType = MediaType.APPLICATION_OCTET_STREAM_VALUE;

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	@Override
	public String getContentType() {
		return this.contentType;
	}
	
	@Override
	public void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String savedPath = (String) model.get("savedPath");
		String fileName = (String) model.get("fileName");

		// 보낼 파일 설정.
		File downloadFile = new File(savedPath + File.separator + fileName);
		FileInputStream inStream = new FileInputStream(downloadFile);

		// 파일 포맷으로 MIME를 결정한다.
		ServletContext context = request.getServletContext();
		String mimeType = context.getMimeType(downloadFile.getName());
		if (mimeType == null) {
			mimeType = "application/octet-stream";
		}

		this.contentType = mimeType;

		// response 수정.
		response.setContentType(mimeType);
		response.setContentLength((int) downloadFile.length());

		String headerKey = "Content-Disposition";

		// 한글깨짐 방지 : ISO-8859-1
		String sendFileName = MakeFileName.parseFileNameFromUUID(downloadFile.getName(), "\\$\\$");

		String header = request.getHeader("User-Agent");
		if (header.contains("MSIE")) {
			sendFileName = URLEncoder.encode(sendFileName, "UTF-8");
		} else {
			sendFileName = new String(sendFileName.getBytes("utf-8"), "ISO-8859-1");
		}
		String headerValue = String.format("attachment; filename=\"%s\"", sendFileName);
		response.setHeader(headerKey, headerValue);

		// 파일 내보내기
		OutputStream outStream = response.getOutputStream();
		byte[] buffer = new byte[4096];
		int bytesRead = -1;

		while ((bytesRead = inStream.read(buffer)) != -1) {
			outStream.write(buffer, 0, bytesRead);
		}

		inStream.close();
		outStream.close();
	}
	
	
	
//	//지아 파일 여러개 다운로드
//	@Override
//	public void render(Map<String, ?> model, HttpServletRequest request, HttpServletResponse response)
//			throws Exception {
//		List<FileSaveVO> fileList = (List<FileSaveVO>) model.get("fileList");
//		System.out.println("size//////////////////////////////////"+fileList.size());
//		OutputStream outStream = null;
//		for (FileSaveVO fileSaveVO : fileList) {
//			System.out.println("////////////////////////"+fileSaveVO.getFilesave_nm());
//			String savedPath = fileSaveVO.getFilesave_pth();
//			String fileName = fileSaveVO.getFilesave_nm();
//			// 보낼 파일 설정.
//			File downloadFile = new File(savedPath + File.separator + fileName);
//			FileInputStream inStream = new FileInputStream(downloadFile);
//
//			// 파일 포맷으로 MIME를 결정한다.
//			ServletContext context = request.getServletContext();
//			String mimeType = context.getMimeType(downloadFile.getName());
//			if (mimeType == null) {
//				mimeType = "application/octet-stream";
//			}
//
//			this.contentType = mimeType;
//
//			// response 수정.
//			response.setContentType(mimeType);
//			response.setContentLength((int) downloadFile.length());
//
//			String headerKey = "Content-Disposition";
//
//			// 한글깨짐 방지 : ISO-8859-1
//			String sendFileName = MakeFileName.parseFileNameFromUUID(downloadFile.getName(), "\\$\\$");
//
//			String header = request.getHeader("User-Agent");
//			if (header.contains("MSIE")) {
//				sendFileName = URLEncoder.encode(sendFileName, "UTF-8");
//			} else {
//				sendFileName = new String(sendFileName.getBytes("utf-8"), "ISO-8859-1");
//			}
//			String headerValue = String.format("attachment; filename=\"%s\"", sendFileName);
//			response.setHeader(headerKey, headerValue);
//
//			// 파일 내보내기
//			outStream = response.getOutputStream();
//			
//			byte[] buffer = new byte[4096];
//			int bytesRead = -1;
//
//			while ((bytesRead = inStream.read(buffer)) != -1) {
//				outStream.write(buffer, 0, bytesRead);
//			}
//			System.out.println(inStream);
//			inStream.close();
//			
//		}
//		outStream.close();
//		
//		
//
//		
//	}

}
