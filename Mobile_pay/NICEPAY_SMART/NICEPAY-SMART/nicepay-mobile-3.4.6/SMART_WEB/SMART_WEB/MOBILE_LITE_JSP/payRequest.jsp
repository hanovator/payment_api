<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="org.apache.commons.codec.binary.Hex" %>
<%@ page import="org.apache.commons.codec.digest.DigestUtils" %>
<%
/*
*******************************************************
* <결제요청 파라미터>
* 결제시 Form 에 보내는 결제요청 파라미터입니다.
* 샘플페이지에서는 기본(필수) 파라미터만 예시되어 있으며, 
* 추가 가능한 옵션 파라미터는 연동메뉴얼을 참고하세요.
*******************************************************
*/
String merchantKey      = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==";   // 상점키
String merchantID       = "nicepay00m";                                                                                 // 상점아이디
String goodsCnt         = "1";                                                                                          // 결제상품개수
String goodsName        = "나이스페이";                                                                                 // 결제상품명
String price            = "1004";                                                                                       // 결제상품금액	
String buyerName        = "나이스";                                                                                     // 구매자명
String buyerTel         = "01000000000";                                                                                // 구매자연락처
String buyerEmail       = "happy@day.co.kr";                                                                            // 구매자메일주소
String moid             = "mnoid1234567890";                                                                            // 상품주문번호
String returnURL        = "http://localhost:8095/auth/MOBILE_LITE_JSP/payResult.jsp";                                   // 결과페이지(절대경로)
String charset          = "euc-kr";                                                                                     // 인코딩
String goodsCl          = "1";                                                                                          // 상품구분 실물(1), 컨텐츠(2)
String encodeParameters = "CardNo,CardExpire,CardPwd";                                                                  // 암호화대상항목 (변경불가)
	
/*
*******************************************************
* <해쉬암호화> (수정하지 마세요)
* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
*******************************************************
*/
DataEncrypt sha256Enc 	= new DataEncrypt();
String ediDate      	= getyyyyMMddHHmmss();	
String hashString    	= sha256Enc.encrypt(ediDate + merchantID + price + merchantKey);

/*
******************************************************* 
* <서버 IP값>
*******************************************************
*/
InetAddress inet= InetAddress.getLocalHost();	
%>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY REQUEST(EUC-KR)</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script type="text/javascript">
//결제창 최초 요청시 실행됩니다. <<'nicepaySubmit()' 이름 수정 불가능>>
function nicepayStart(){
    document.getElementById("vExp").value = getTomorrow();
    document.payForm.submit();
}

//가상계좌입금만료일 설정 (today +1)
function getTomorrow(){
    var today = new Date();
    var yyyy = today.getFullYear().toString();
    var mm = (today.getMonth()+1).toString();
    var dd = (today.getDate()+1).toString();
    if(mm.length < 2){mm = '0' + mm;}
    if(dd.length < 2){dd = '0' + dd;}
    return (yyyy + mm + dd);
}
</script>
</head>
<body>
<form name="payForm" method="post" target="_self" action="https://web.nicepay.co.kr/v3/smart/smartPayment.jsp">
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
			  
			  <!-- IP -->
			  <input type="hidden" name="MallIP" value="<%=inet.getHostAddress()%>"/>      <!-- 상점서버IP -->
			  
			  <!-- 옵션 -->
			  <input type="hidden" name="VbankExpDate" id="vExp"/>                         <!-- 가상계좌입금만료일 -->
			  <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"/>             <!-- 구매자 이메일 -->				  
			  <input type="hidden" name="GoodsCl" value="<%=goodsCl%>"/>                   <!-- 상품구분 실물(1), 컨텐츠(0) -->
			  <input type="hidden" name="CharSet" value="<%=charset%>"/>                   <!-- 인코딩 설정 -->
			  <input type="hidden" name="ReturnURL" value="<%=returnURL%>">                <!-- Return URL -->
              
			  <!-- 변경 불가능 -->
              <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>"/> <!-- 암호화대상항목 -->              
			  <input type="hidden" name="ediDate" value="<%=ediDate%>"/>                   <!-- 전문 생성일시 -->
			  <input type="hidden" name="EncryptData" value="<%=hashString%>"/>            <!-- 해쉬값	-->
			  <input type="hidden" name="TrKey" value=""/>                                 <!-- 필드만 필요 -->
			  <input type="hidden" name="AcsNoIframe" value="Y"/>						   <!-- 나이스페이 결제창 프레임 옵션 (변경불가) -->
			  
			</table>
		  </div>
		</div>
		<div class="btngroup">
		  <a href="#" class="btn_blue" onClick="nicepayStart();">요 청</a>
		</div>
	  </div>
	</div>
</form>
</body>
</html>
<%!
public final synchronized String getyyyyMMddHHmmss(){
    SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyyMMddHHmmss");
    return yyyyMMddHHmmss.format(new Date());
}
// SHA-256 형식으로 암호화
public class DataEncrypt{
	MessageDigest md;
	String strSRCData = "";
	String strENCData = "";
	String strOUTData = "";

	public DataEncrypt(){ }
	public String encrypt(String strData){
		String passACL = null;
		MessageDigest md = null;
		try{
			md = MessageDigest.getInstance("SHA-256");
			md.reset();
			md.update(strData.getBytes());
			byte[] raw = md.digest();
			passACL = encodeHex(raw);
		}catch(Exception e){
			System.out.print("암호화 에러" + e.toString());
	    }
		return passACL;
	}
	
	public String encodeHex(byte [] b){
		char [] c = Hex.encodeHex(b);
		return new String(c);
	}
}
%>