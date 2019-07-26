<%@Language="VBScript" CODEPAGE="949"%>
<!--#include file="./class/SHA256.asp"-->
<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <결제요청 파라미터>
' 결제시 Form 에 보내는 결제요청 파라미터입니다.
' 샘플페이지에서는 기본(필수) 파라미터만 예시되어 있으며, 
' 추가 가능한 옵션 파라미터는 연동메뉴얼을 참고하세요.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
merchantKey      = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg=="  '상점키
merchantID       = "nicepay00m"                                                                                '상점아이디
goodsCnt         = "1"                                                                                         '결제상품개수
goodsName        = "나이스페이"                                                                                '결제상품명
price            = "1004"                                                                                      '결제상품금액	
buyerName        = "나이스"                                                                                    '구매자명
buyerTel         = "01000000000"                                                                               '구매자연락처
buyerEmail       = "happy@day.co.kr"                                                                           '구매자메일주소
moid             = "mnoid1234567890"                                                                           '상품주문번호	
encodeParameters = "CardNo,CardExpire,CardPwd"                                                                 '암호화대상항목 (변경불가)
returnURL        = "http://localhost/MOBILE_LITE_ASP/payResult.asp"                                            '결과페이지 URL
charSet          = "euc-kr"                                                                                    '결과페이지 인코딩

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <가상계좌 입금 만료일>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
tomorrow = (date()+1)
tomorrow = Replace(tomorrow, "-", "")

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <해쉬암호화> (수정하지 마세요)
' SHA256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
call initCodecs

ediDate = getNow()
hashString = SHA256_Encrypt(ediDate & merchantID & price & merchantKey)

Function getNow()
Dim aDate(2), aTime(2)
    aDate(0) = Year(Now)
    aDate(1) = Right("0" & Month(Now), 2)
    aDate(2) = Right("0" & Day(Now), 2)
    aTime(0) = Right("0" & Hour(Now), 2)
    aTime(1) = Right("0" & Minute(Now), 2)
    aTime(2) = Right("0" & Second(Now), 2)	
    getNow   = aDate(0)&aDate(1)&aDate(2)&aTime(0)&aTime(1)&aTime(2)	   
End Function
%>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY REQUEST(EUC-KR)</title>
<meta charset="euc-kr">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script type="text/javascript">
function goPay() {
	document.payForm.submit();
}
</script>
</head>
<body>
<form name="payForm" method="post" target = "_self" action="https://web.nicepay.co.kr/v3/smart/smartPayment.jsp" accept-charset="euc-kr">
    <div class="payfin_area">
      <div class="top">NICEPAY PAY REQUEST(EUC-KR)</div>
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
                <th><span>구매자명</span></th>
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
              <input type="hidden" name="VbankExpDate" value="<%=tomorrow%>"/>             <!-- 가상계좌입금만료일 -->
              <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"/>             <!-- 구매자 이메일 -->				  
              <input type="hidden" name="GoodsCl" value="1"/>                              <!-- 상품구분(실물(1),컨텐츠(0)) -->        
              <input type="hidden" name="TransType" value="0"/>                            <!-- 일반(0)/에스크로(1) --> 
              <input type="hidden" name="MallReserved"  value=""/>                         <!-- 상점 여분 필드 --> 
              <input type="hidden" name="ReturnURL" value="<%=returnURL%>"/>               <!-- 결과페이지 URL -->
              <input type="hidden" name="CharSet" value="<%=charSet%>"/>                   <!-- 결과페이지 인코딩 -->
              
              <!-- 변경 불가능 -->
              <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>"/> <!-- 암호화대상항목 -->
              <input type="hidden" name="ediDate" value="<%=ediDate%>"/>                   <!-- 전문 생성일시 -->
              <input type="hidden" name="EncryptData" value="<%=hashString%>"/>            <!-- 해쉬값 -->
              <input type="hidden" name="TrKey" value=""/>                                 <!-- 필드만 필요 -->
              <input type="hidden" name="MerchantKey" value="<%=merchantKey%>"/>           <!-- 상점 키 --> 
			  <input type="hidden" name="AcsNoIframe" value="Y"/>						   <!-- 나이스페이 결제창 프레임 옵션 (변경불가) -->
			  
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