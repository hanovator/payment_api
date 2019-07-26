<!--#include file="./class/NICELite.asp"-->
<%
m_authResultCode = request.form("AuthResultCode")               '인증결과 : 0000(성공)
m_authResultMsg = request.form("AuthResultMsg")                 '인증결과 메시지

IF (m_authResultCode = "0000") THEN

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ' <결제 결과 설정>
    ' 사용전 결과 옵션을 사용자 환경에 맞도록 변경하세요.
    ' 로그 디렉토리는 꼭 변경하세요.
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Set NICEpay   = new clssNICEpay
    merchantKey   = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==" '상점키
    NICEpay.setfield "logdir","c:\log"                          '로그경로설정 
    NICEpay.setfield "type","PYO"                               '서비스모드설정(결제서비스:PY0, 취소서비스:CL0)
    NICEpay.setfield "EncodeKey",merchantKey                    '상점키설정
    NICEpay.setfield "NetCancelAmt",Request.Form("Amt")         '취소금액 
    NICEpay.setfield "NetCancelPwd","123456"                    '취소비밀번호
    NICEpay.setfield "CharSet","utf-8"                          '인코딩
    NICEpay.startAction()

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ' <결제 결과 필드>
    ' 아래 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    resultCode    = NICEpay.getResult("ResultCode")             '결과코드
    resultMsg     = NICEpay.getResult("ResultMsg")	            '결과메시지
    resultErrCode = NICEpay.getResult("resulterrcode")          '결과에러코드
    tid           = NICEpay.getResult("TID")                    '거래ID
    moid          = NICEpay.getResult("Moid")                   '주문번호
    amt           = NICEpay.getResult("Amt")                    '가격
    payMethod     = NICEpay.getResult("PayMethod")              '결제수단
    authDate      = NICEpay.getResult("AuthDate")               '승인날짜
    cardCode      = NICEpay.getResult("CardCode")               '카드사코드
    cardName      = NICEpay.getResult("CardName")               '카드사명
    cardQuota     = NICEpay.getResult("CardQuota")              '00:일시불, 02:2개월
    bankCode      = NICEpay.getResult("BankCode")               '계좌이체 은행 코드
    bankName      = NICEpay.getResult("BankName")               '계좌이체 은행명
    rcptType      = NICEpay.getResult("RcptType")               '현금영수증 (0:발행되지않음, 1:소득공제, 2:지출증빙)
    rcptAuthCode  = NICEpay.getResult("RcptAuthCode")           '현금영수증 승인 번호
    rcptTID       = NICEpay.getResult("RcptTID")                '현금영수증 TID   
    carrier       = NICEpay.getResult("Carrier")                '이통사구분
    dstAddr       = NICEpay.getResult("DstAddr")                '휴대폰번호
    vBankCode     = NICEpay.getResult("VbankBankCode")          '가상계좌은행코드
    vBankName     = NICEpay.getResult("VbankBankName")          '가상계좌은행명
    vbankNum      = NICEpay.getResult("VbankNum")               '가상계좌번호
    vbankExpDate  = NICEpay.getResult("VbankExpDate")           '가상계좌입금예정일
    goodsName     = NICEpay.getResult("GoodsName")

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ' <결제 성공 여부 확인>
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    paySuccess = False
    If payMethod = "CARD" Then
        If resultCode = "3001" Then paySuccess  = True            '신용카드(정상 결과코드:3001)
    ElseIf  payMethod = "BANK" Then
        If resultCode = "4000" Then paySuccess  = True 	          '계좌이체(정상 결과코드:4000)	
    ElseIf payMethod  = "CELLPHONE" Then
        If resultCode = "A000" Then paySuccess  = True	          '휴대폰(정상 결과코드:A000)
    ElseIf  payMethod = "VBANK" Then
        If resultCode = "4100" Then paySuccess  = True	          '가상계좌(정상 결과코드:4100)
    End If

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ' <클래스 해제>
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Set NICEpay = Nothing
ELSE
    resultCode =  m_authResultCode
    resultMsg  = m_authResultMsg
END IF
%>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY RESULT(UTF-8)</title>
<meta charset="utf-8">
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
            <%If paymethod="CARD" Then %>
              <tr>
                <th><span>카드사명</span></th>
                <td><%=cardName%></td>
              </tr>
              <tr>
                <th><span>할부개월</span></th>
                <td><%=cardQuota%></td>
              </tr>
            <%ElseIf paymethod="BANK" Then%>
              <tr>
                <th><span>은행</span></th>
                <td><%=bankName%></td>
              </tr>
              <tr>
                <th><span>현금영수증 타입(0:발행안함,1:소득공제,2:지출증빙)</span></th>
                <td><%=rcptType%></td>
              </tr>
            <%ElseIf paymethod="CELLPHONE" Then%>
              <tr>
                <th><span>이통사 구분</span></th>
                <td><%=carrier%></td>
              </tr>
              <tr>
                <th><span>휴대폰 번호</span></th>
                <td><%=dstAddr%></td>
              </tr>
            <%ElseIf paymethod="VBANK" Then%>
              <tr>
                <th><span>입금 은행</span></th>
                <td><%=vBankName%></td>
              </tr>
              <tr>
                <th><span>입금 계좌</span></th>
                <td><%=vbankNum%></td>
              </tr>
              <tr>
                <th><span>입금 기한</span></th>
                <td><%=vbankExpDate%></td>
              </tr>
            <%End If%>
          </table>
        </div>
      </div>
      <p>*테스트 아이디인경우 당일 오후 11시 30분에 취소됩니다.</p>
    </div>
  </div>
</body>
</html>
