<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="kr.co.nicepay.module.lite.NicePayWebConnector"%>
<%
request.setCharacterEncoding("UTF-8"); 
/*
*******************************************************
* <결제 결과 설정>
* 사용전 결과 옵션을 사용자 환경에 맞도록 변경하세요.
* 로그 디렉토리는 꼭 변경하세요.
*******************************************************
*/
String logPath              = "C:/workspace/server/tomcat_8.0/webapps/ROOT/auth/MOBILE_LITE_JSP/WEB-INF"; // 로그 디렉토리(모듈내 WEB-INF Path 설정)
String mid                  = "nicepay00m";                                                               // 상점ID
String actionType           = "PY0";                                                                      // 서비스모드 설정(결제 서비스 : PY0 , 취소 서비스 : CL0)
String cancelPwd            = "123456";                                                                   // 취소 비밀번호

/*
*******************************************************
* <변수 초기화>
*******************************************************
*/
String payMethod            = "";  String resultCode           = "";  String resultMsg            = "";
String authDate             = "";  String authCode             = "";  String buyerName            = "";
String mallUserID           = "";  String goodsName            = "";  String authResultMsg        = "";
String tid                  = "";  String moid                 = "";  String amt                  = "";
String cardCode             = "";  String cardName             = "";  String cardQuota            = "";
String bankCode             = "";  String bankName             = "";  String rcptType             = "";
String rcptAuthCode         = "";  String rcptTID              = "";  String carrier              = "";
String dstAddr              = "";  String vbankBankCode        = "";  String vbankBankName        = "";
String vbankNum             = "";  String vbankExpDate         = "";  String authResultCode       = "";

/*
*******************************************************
* <인증 결과>
*******************************************************
*/
authResultCode   = (String)request.getParameter("AuthResultCode");                                         // 인증결과 : 0000(성공)
authResultMsg    = (String)request.getParameter("AuthResultMsg");                                          // 인증결과 메시지

if("0000".equals(authResultCode)){
    NicePayWebConnector connector = new NicePayWebConnector();
    connector.setNicePayHome(logPath);
    connector.setRequestData(request);
    connector.addRequestData("MID", mid);
    connector.addRequestData("actionType", actionType);
    connector.addRequestData("MallIP", request.getRemoteAddr());                                           // 상점 고유 ip
    connector.addRequestData("CancelPwd", cancelPwd);                    
    connector.requestAction();

    /*
    *******************************************************
    * <결제 결과 필드>
    * 아래 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능
    *******************************************************
    */

    resultCode    = connector.getResultData("ResultCode");                                                  // 결과코드 (정상 결과코드:3001)
    resultMsg     = connector.getResultData("ResultMsg");                                                   // 결과메시지
    authDate      = connector.getResultData("AuthDate");                                                    // 승인일시 (YYMMDDHH24mmss)
    authCode      = connector.getResultData("AuthCode");                                                    // 승인번호
    buyerName     = connector.getResultData("BuyerName");                                                   // 구매자명
    mallUserID    = connector.getResultData("MallUserID");                                                  // 회원사고객ID
    payMethod     = connector.getResultData("PayMethod");                                                   // 결제수단
    mid           = connector.getResultData("MID");                                                         // 상점ID
    tid           = connector.getResultData("TID");                                                         // 거래ID
    moid          = connector.getResultData("Moid");                                                        // 주문번호
    amt           = connector.getResultData("Amt");                                                         // 금액
    goodsName     = connector.getResultData("GoodsName");                                                   // 금액
    cardCode      = connector.getResultData("CardCode");                                                    // 카드사 코드
    cardName      = connector.getResultData("CardName");                                                    // 결제카드사명
    cardQuota     = connector.getResultData("CardQuota");                                                   // 카드 할부개월 (00:일시불,02:2개월)
    bankCode      = connector.getResultData("BankCode");                                                    // 은행 코드
    bankName      = connector.getResultData("BankName");                                                    // 은행명
    rcptType      = connector.getResultData("RcptType");                                                    // 현금 영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
    rcptAuthCode  = connector.getResultData("RcptAuthCode");                                                // 현금영수증 승인 번호
    rcptTID       = connector.getResultData("RcptTID");                                                     // 현금 영수증 TID   
    carrier       = connector.getResultData("Carrier");                                                     // 이통사구분
    dstAddr       = connector.getResultData("DstAddr");                                                     // 휴대폰번호
    vbankBankCode = connector.getResultData("VbankBankCode");                                               // 가상계좌은행코드
    vbankBankName = connector.getResultData("VbankBankName");                                               // 가상계좌은행명
    vbankNum      = connector.getResultData("VbankNum");                                                    // 가상계좌번호
    vbankExpDate  = connector.getResultData("VbankExpDate");                                                // 가상계좌입금예정일

    /*
    *******************************************************
    * <결제 성공 여부 확인>
    *******************************************************
    */
    boolean paySuccess = false;
    if(payMethod.equals("CARD")){
        if(resultCode.equals("3001")) paySuccess = true;                                                    // 신용카드(정상 결과코드:3001)
    }else if(payMethod.equals("BANK")){
        if(resultCode.equals("4000")) paySuccess = true;                                                    // 계좌이체(정상 결과코드:4000)	
    }else if(payMethod.equals("CELLPHONE")){
        if(resultCode.equals("A000")) paySuccess = true;                                                    // 휴대폰(정상 결과코드:A000)
    }else if(payMethod.equals("VBANK")){	
        if(resultCode.equals("4100")) paySuccess = true;                                                    // 가상계좌(정상 결과코드:4100)
    }else if(payMethod.equals("SSG_BANK")){										
    	if(resultCode.equals("0000")) paySuccess = true;												   // SSG은행계좌(정상 결과코드:0000)
    }

}else{
    resultCode = authResultCode;
	resultMsg  = authResultMsg;
}

%>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY RESULT(UTF-8)</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
</head>
<body> 
  <div class="payfin_area">
    <div class="top">NICEPAY PAY RESULT(UTF-8)</div>
    <div class="conwrap">
      <div class="con">
        <div class="tabletypea">
          <table>
            <colgroup><col width="30%"/><col width="*"/></colgroup>
              <tr>
                <th><span>결과 내용</span></th>
                <td>[<%=resultCode%>]<%=resultMsg%></td>
              </tr>
              <tr>
                <th><span>결제 수단</span></th>
                <td><%=payMethod%></td>
              </tr>
              <tr>
                <th><span>상품명</span></th>
                <td><%=goodsName%></td>
              </tr>
              <tr>
                <th><span>금액</span></th>
                <td><%=amt%>원</td>
              </tr>
              <tr>
                <th><span>거래아이디</span></th>
                <td><%=tid%></td>
              </tr>               
            <%if(payMethod.equals("CARD")){%>
              <tr>
                <th><span>카드사명</span></th>
                <td><%=cardName%></td>
              </tr>
              <tr>
                <th><span>할부개월</span></th>
                <td><%=cardQuota%></td>
              </tr>
            <%}else if(payMethod.equals("BANK")){%>
              <tr>
                <th><span>은행</span></th>
                <td><%=bankName%></td>
              </tr>
              <tr>
                <th><span>현금영수증 타입</span></th>
                <td><%=rcptType%>(0:발행안함,1:소득공제,2:지출증빙)</td>
              </tr>
            <%}else if(payMethod.equals("CELLPHONE")){%>
              <tr>
                <th><span>이통사 구분</span></th>
                <td><%=carrier%></td>
              </tr>
              <tr>
                <th><span>휴대폰 번호</span></th>
                <td><%=dstAddr%></td>
              </tr>
            <%}else if(payMethod.equals("VBANK")){%>
              <tr>
                <th><span>입금 은행</span></th>
                <td><%=vbankBankName%></td>
              </tr>
              <tr>
                <th><span>입금 계좌</span></th>
                <td><%=vbankNum%></td>
              </tr>
              <tr>
                <th><span>입금 기한</span></th>
                <td><%=vbankExpDate%></td>
              </tr>
            <%}else if(payMethod.equals("SSG_BANK")){%>
              <tr>
                <th><span>은행</span></th>
                <td><%=bankName%></td>
              </tr>
              <tr>
                <th><span>현금영수증 타입</span></th>
                <td><%=rcptType%>(0:발행안함,1:소득공제,2:지출증빙)</td>
              </tr>				  
            <%}%>
          </table>
        </div>
      </div>
      <p>*테스트 아이디인경우 당일 오후 11시 30분에 취소됩니다.</p>
    </div>
  </div>
</body>
</html>