<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>



<!-- <form id="jobForm"> -->
<!-- 	<input type='hidden' name="page" value="" /> -->
<!-- 	<input type='hidden' name="perPageNum" value=""/> -->
<!-- 	<input type='hidden' name="searchType" value="" /> -->
<!-- 	<input type='hidden' name="keyword" value="" /> -->
<%-- 	<input type='hidden' name="prjct_sn" value="${prjct_sn }"/> --%>
	
<!-- </form> -->


	<!-- pagenation -->
 			<nav aria-label="Navigation">
 				<ul class="pagination justify-content-center m-0">
 					<li class="page-item">
				<a class="page-link" href="javascript:list_go(1);">
					<i class="fas fa-angle-double-left"></i>
				</a>
			</li>
			<li class="page-item">
				<a class="page-link" 
				href="javascript:list_go('${pageMaker2.prev ? pageMaker2.startPage-1 : cri2.page}');">
					<i class="fas fa-angle-left"></i>
				</a>
			</li>
			<c:forEach var="pageNum" begin="${pageMaker2.startPage }" end="${pageMaker2.endPage }" >
				<li class="page-item ${pageMaker2.cri.page == pageNum?'active':''}">
					<a class="page-link" href="javascript:list_go('${pageNum}');" >
					${pageNum }</a>
				</li>
			</c:forEach>
				<li class="page-item">
					<a class="page-link" href="javascript:list_go('${pageMaker2.next ? pageMaker2.endPage+1 :cri2.page}');">
						<i class="fas fa-angle-right" ></i>
					</a>
				</li>
				<li class="page-item">
					<a class="page-link" href="javascript:list_go('${pageMaker2.realEndPage}');">
						<i class="fas fa-angle-double-right"></i>
					</a>
				</li>	
 				</ul>
 			</nav>