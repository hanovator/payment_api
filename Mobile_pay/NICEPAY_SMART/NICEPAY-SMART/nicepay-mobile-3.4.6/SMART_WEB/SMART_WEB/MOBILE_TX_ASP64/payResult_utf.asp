﻿<%
m_authResultCode = request.form("AuthResultCode")                       '인증결과 : 0000(성공)
m_authResultMsg = request.form("AuthResultMsg")                         '인증결과 메시지

IF (m_authResultCode = "0000") THEN
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <결제 결과 설정>
' 로그 디렉토리는 NICE.dll을 설치위치 /log 폴더 입니다.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set NICEpay      = Server.CreateObject("NICE.NICETX2.1")
PInst            = NICEpay.InitializeX64("")
merchantKey      = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==" '상점키
merchantID       = "nicepay00m"                                    '상점아이디

NICEpay.SetActionTypeX64 (PInst),"SECUREPAY"                       '거래 설정
NICEpay.SetFieldX64 (PInst),"logpath","C:\log"                     'Log Path 설정
NICEpay.SetFieldX64 (PInst),"mid",merchantID                       '상점 ID
NICEpay.SetFieldX64 (PInst),"LicenseKey",merchantKey               '가맹점상점키
NICEpay.SetFieldX64 (PInst),"tid",Request("TID")                   '거래 아이디 
NICEpay.SetFieldX64 (PInst),"paymethod",Request("paymethod")       '지불수단
NICEpay.SetFieldX64 (PInst),"amt",Request("amt")                   '결제금액 
NICEpay.SetFieldX64 (PInst),"moid",Request("moid")                 '상점 주문번호
NICEpay.SetFieldX64 (PInst),"GoodsName",Request("goodsname")       '상품명
NICEpay.SetFieldX64 (PInst),"currency","KRW"                       '통화구분
NICEpay.SetFieldX64 (PInst),"buyername",Request("buyername")       '성명
NICEpay.SetFieldX64 (PInst),"malluserid",Request("malluserid")     '회원사고객ID
NICEpay.SetFieldX64 (PInst),"buyertel",Request("buyertel")         '이동전화
NICEpay.SetFieldX64 (PInst),"buyeremail",Request("buyeremail")     '이메일
NICEpay.SetFieldX64 (PInst),"parentemail",Request("parentemail")   '보호자 이메일 주소
NICEpay.SetFieldX64 (PInst),"debug","true"                         '로그모드("true" 상세 로그)
NICEpay.SetFieldX64 (PInst),"CancelPwd","123456"                   '취소 패스워드
NICEpay.SetFieldX64 (PInst),"goodscl",Request("GoodsCl")           '휴대폰/컨텐츠
NICEpay.SetFieldX64 (PInst),"TransType",Request("TransType")       '거래형태
NICEpay.SetFieldX64 (PInst),"trkey",Request("TrKey")
NICEpay.StartActionX64((PInst))

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <결제 결과 필드>
' 아래 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
m_tid             = NICEpay.GetResultX64((PInst),"tid")            '거래번호
m_moid            = NICEpay.GetResultX64((PInst),"moid")           '상점거래번호
m_resultCode      = NICEpay.GetResultX64((PInst),"resultcode")     '결과코드
m_resultMsg       = NICEpay.GetResultX64((PInst),"resultmsg")      '결과메시지
m_goodsName       = NICEpay.GetResultX64((PInst),"GoodsName")      '상품명
m_authDate        = NICEpay.GetResultX64((PInst),"AuthDate")       '승인일시
m_authCode        = NICEpay.GetResultX64((PInst),"authcode")       '승인번호
m_amt             = NICEpay.GetResultX64((PInst),"amt")            '승인금액
m_payMethod       = NICEpay.GetResultX64((PInst),"PayMethod")      '결제수단
m_cardCode        = NICEpay.GetResultX64((PInst),"CardCode")       '카드사 코드
m_cardName        = NICEpay.GetResultX64((PInst),"CardName")       '카드사명
m_cardCaptureCode = NICEpay.GetResultX64((PInst),"AcquCardCode")   '매입사 코드 
m_cardCaptureName = NICEpay.GetResultX64((PInst),"AcquCardName")   '매입사 명
m_bankCode        = NICEpay.GetResultX64((PInst),"BankCode")       '은행코드
m_bankName        = NICEpay.GetResultX64((PInst),"BankName")       '은행명 
m_vbankBankCode   = NICEpay.GetResultX64((PInst),"VbankBankCode")  '가상계좌은행코드
m_vbankBankName   = NICEpay.GetResultX64((PInst),"VbankBankName")  '가상계좌은행명
m_vbankNum        = NICEpay.GetResultX64((PInst),"VbankNum")       '가상계좌번호
m_vbankExpDate    = NICEpay.GetResultX64((PInst),"VbankExpDate")   '가상계좌입금예정일 
m_carrier         = NICEpay.GetResultX64((PInst),"Carrier")        '이통사구분
m_dstAddr         = NICEpay.GetResultX64((PInst),"DstAddr")        '휴대폰번호 

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <결제 성공 여부 확인>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''     
paySuccess = False	' 결제 성공 여부

IF (m_payMethod = "CARD") THEN 
	If resultCode = "3001" Then paySuccess  = True                  '신용카드(정상 결과코드:3001)
ELSEIF (m_payMethod ="BANK") Then
	If resultCode = "4000" Then paySuccess  = True                  '계좌이체(정상 결과코드:4000)
ELSEIF (m_payMethod ="VBANK") THEN  
	If resultCode = "4100" Then paySuccess  = True                  '휴대폰(정상 결과코드:A000) 
ELSEIF (m_payMethod ="CELLPHONE") THEN  
	If resultCode = "A000" Then paySuccess  = True                  '가상계좌(정상 결과코드:4100)
END IF

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <클래스 해제>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
NICEpay.DestroyX64 (PInst)

ELSE
    m_resultCode =  m_authResultCode
    m_resultMsg = m_authResultMsg
END IF
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
                <td>[<%=m_ResultCode%>]<%=m_ResultMsg%></td>
              </tr>
              <tr>
                <th><span>결제 수단</span></th>
                <td><%=m_payMethod%></td>
              </tr>
              <tr>
                <th><span>상품명</span></th>
                <td><%=m_goodsName%></td>
              </tr>
              <tr>
                <th><span>금액</span></th>
                <td><%=m_amt%>원</td>
              </tr>
              <tr>
                <th><span>거래아이디</span></th>
                <td><%=m_tid%></td>
              </tr>               
            <%If paymethod="CARD" Then %>
              <tr>
                <th><span>카드사명</span></th>
                <td><%=m_cardName%></td>
              </tr>
              <tr>
                <th><span>카드코드</span></th>
                <td><%=m_cardCode%></td>
              </tr>
            <%ElseIf paymethod="BANK" Then%>
              <tr>
                <th><span>은행이름</span></th>
                <td><%=m_bankName%></td>
              </tr>
              <tr>
                <th><span>은행코드</span></th>
                <td><%=m_bankName%></td>
              </tr>
            <%ElseIf paymethod="CELLPHONE" Then%>
              <tr>
                <th><span>이통사 구분</span></th>
                <td><%=m_carrier%></td>
              </tr>
              <tr>
                <th><span>휴대폰 번호</span></th>
                <td><%=m_dstAddr%></td>
              </tr>
            <%ElseIf paymethod="VBANK" Then%>
              <tr>
                <th><span>입금 은행</span></th>
                <td><%=m_vbankBankName%></td>
              </tr>
              <tr>
                <th><span>입금 계좌</span></th>
                <td><%=m_vbankNum%></td>
              </tr>
              <tr>
                <th><span>입금 기한</span></th>
                <td><%=m_vbankExpDate%></td>
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