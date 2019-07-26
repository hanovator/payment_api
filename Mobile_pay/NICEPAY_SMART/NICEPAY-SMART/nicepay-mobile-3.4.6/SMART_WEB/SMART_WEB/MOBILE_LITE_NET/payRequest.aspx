<%@ Page Language="C#"  AutoEventWireup="true" Src="payRequest.aspx.cs" Inherits="payReqSmart"  %>

<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY REQUEST(UTF-8)</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script type="text/javascript">
function goPay(){
	document.tranMgr.submit();
}
</script>
</head>
<body>
<form name="tranMgr" method="post" target="_self"; action="https://web.nicepay.co.kr/v3/smart/smartPayment.jsp" accept-charset="euc-kr">
    <div class="payfin_area">
      <div class="top">NICEPAY PAY REQUEST(UTF-8)</div>
      <div class="conwrap">
        <div class="con">
          <div class="tabletypea">
            <table>
              <colgroup><col width="30%" /><col width="*" /></colgroup>
              <tr>
                <th><span>결제 수단</span></th>
                <td>
                  <select name="PayMethod">
                    <option value="CARD">신용카드</option>
                    <option value="BANK">계좌이체</option>
                    <option value="CELLPHONE">휴대폰결제</option>
                    <option value="VBANK">가상계좌</option>
                  </select>
                </td>
              </tr>
              <tr>
                <th><span>결제 상품명</span></th>
                <td><input type="text" name="GoodsName" value="<%=goodsName%>"></td>
              </tr>
			  <tr>
				<th><span>결제 상품개수</span></th>
				<td><input type="text" name="GoodsCnt" value="<%=goodsCnt%>"></td>
			  </tr>	                	
              <tr>
                <th><span>결제 상품금액</span></th>
                <td><input type="text" name="Amt" value="<%=price%>"></td>
              </tr>
              <tr>
                <th><span>구매자</span></th>
                <td><input type="text" name="BuyerName" value="<%=buyerName%>"></td>
              </tr>	
			  <tr>
				<th><span>구매자 연락처</span></th>
				<td><input type="text" name="BuyerTel" value="<%=buyerTel%>"></td>
			  </tr> 
			  <tr>
				<th><span>상품 주문번호</span></th>
				<td><input type="text" name="Moid" value="<%=moid%>"></td>
			  </tr>	
			  <tr>
				<th><span>상점 아이디</span></th>
				<td><input type="text" name="MID" value="<%=merchantID%>"></td>
			  </tr>  

			  <!-- 옵션 -->
			  <input type="hidden" name="VbankExpDate" value="<%=TomorrowDateString()%>"/>      <!-- 가상계좌입금만료일 -->
			  <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"/>                  <!-- 구매자 이메일 -->				  
			  <input type="hidden" name="GoodsCl" value="<%=goodsCl%>"/>                        <!-- 상품구분 실물(1), 컨텐츠(0) -->
			  <input type="hidden" name="CharSet" value="<%=charSet%>"/>                        <!-- 인코딩 설정 -->
			  <input type="hidden" name="ReturnURL" value="<%=returnURL%>">                     <!-- Return URL -->
              <input type="hidden" name="MallReserved"  value=""/>
              
			  <!-- 변경 불가능 -->
			  <input type="hidden" name="ediDate" value="<%=ediDate%>"/>                        <!-- 전문 생성일시 -->
			  <input type="hidden" name="EncryptData" value="<%=hash_String%>"/>                <!-- 해쉬값	-->
			  <input type="hidden" name="TrKey" value=""/>                                      <!-- 필드만 필요 -->
			  <input type="hidden" name="MerchantKey" value="<%=merchantKey%>"/>                <!-- 상점 키 -->		
			  <input type="hidden" name="AcsNoIframe" value="Y"/>								<!-- 나이스페이 결제창 프레임 옵션 (변경불가) -->
			  
			</table>
		  </div>
		</div>
		<div class="btngroup">
		  <a href="#" class="btn_blue" onClick="goPay();">요 청</a>
		</div>
	  </div>
	</div>
</form>
</body>
</html>