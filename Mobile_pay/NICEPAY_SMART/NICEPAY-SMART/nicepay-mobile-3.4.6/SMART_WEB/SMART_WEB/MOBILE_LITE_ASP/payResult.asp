<!--#include file="./class/NICELite.asp"-->
<%
m_authResultCode = request.form("AuthResultCode")               '������� : 0000(����)
m_authResultMsg = request.form("AuthResultMsg")                 '������� �޽���

IF (m_authResultCode = "0000") THEN

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ' <���� ��� ����>
    ' ����� ��� �ɼ��� ����� ȯ�濡 �µ��� �����ϼ���.
    ' �α� ���丮�� �� �����ϼ���.
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Set NICEpay   = new clssNICEpay
    merchantKey   = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==" '����Ű
    NICEpay.setfield "logdir","c:\log"                          '�α� ��� ���� 
    NICEpay.setfield "type","PYO"                               '���񽺸�� ����(���� ���� : PY0 , ��� ���� : CL0)
    NICEpay.setfield "EncodeKey",merchantKey                    '����Ű ����
    NICEpay.setfield "NetCancelAmt",Request.Form("Amt")         '��� �ݾ� 
    NICEpay.setfield "NetCancelPwd","123456"                    '��� ��й�ȣ
    NICEpay.startAction()

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ' <���� ��� �ʵ�>
    ' �Ʒ� ���� ������ �ܿ��� ���� Header�� ������ ������ Get ����
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    resultCode    = NICEpay.getResult("ResultCode")             '��� �ڵ�
    resultMsg     = NICEpay.getResult("ResultMsg")	            '��� �޽���
    resultErrCode = NICEpay.getResult("resulterrcode")          '��� ���� �ڵ�
    tid           = NICEpay.getResult("TID")                    '�ŷ� ID
    moid          = NICEpay.getResult("Moid")                   '�ֹ���ȣ
    amt           = NICEpay.getResult("Amt")                    '����
    payMethod     = NICEpay.getResult("PayMethod")              '��������
    authDate      = NICEpay.getResult("AuthDate")               '���� ��¥
    cardCode      = NICEpay.getResult("CardCode")               'ī��� �ڵ�
    cardName      = NICEpay.getResult("CardName")               'ī����
    cardQuota     = NICEpay.getResult("CardQuota")              '00:�Ͻú�,02:2����
    bankCode      = NICEpay.getResult("BankCode")               '������ü ���� �ڵ�
    bankName      = NICEpay.getResult("BankName")               '������ü �����
    rcptType      = NICEpay.getResult("RcptType")               '���� ������(0:�����������,1:�ҵ����,2:��������)
    rcptAuthCode  = NICEpay.getResult("RcptAuthCode")           '���ݿ����� ���� ��ȣ
    rcptTID       = NICEpay.getResult("RcptTID")                '���� ������ TID   
    carrier       = NICEpay.getResult("Carrier")                '����籸��
    dstAddr       = NICEpay.getResult("DstAddr")                '�޴�����ȣ
    vBankCode     = NICEpay.getResult("VbankBankCode")          '������������ڵ�
    vBankName     = NICEpay.getResult("VbankBankName")          '������������
    vbankNum      = NICEpay.getResult("VbankNum")               '������¹�ȣ
    vbankExpDate  = NICEpay.getResult("VbankExpDate")           '��������Աݿ�����
    goodsName     = NICEpay.getResult("GoodsName")

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ' <���� ���� ���� Ȯ��>
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    paySuccess = False
    If payMethod = "CARD" Then
        If resultCode = "3001" Then paySuccess  = True          '�ſ�ī��(���� ����ڵ�:3001)
    ElseIf  payMethod = "BANK" Then
        If resultCode = "4000" Then paySuccess  = True 	        '������ü(���� ����ڵ�:4000)	
    ElseIf payMethod  = "CELLPHONE" Then
        If resultCode = "A000" Then paySuccess  = True	        '�޴���(���� ����ڵ�:A000)
    ElseIf  payMethod = "VBANK" Then
        If resultCode = "4100" Then paySuccess  = True	        '�������(���� ����ڵ�:4100)
    End If

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    ' <Ŭ���� ����>
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
<title>NICEPAY PAY RESULT(EUC-KR)</title>
<meta charset="euc-kr">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
</head>
<body> 
  <div class="payfin_area">
    <div class="top">NICEPAY PAY RESULT(EUC-KR)</div>
    <div class="conwrap">
      <div class="con">
        <div class="tabletypea">
          <table>
            <colgroup><col width="30%"/><col width="*"/></colgroup>
              <tr>
                <th><span>��� ����</span></th>
                <td>[<%=resultCode%>]<%=resultMsg%></td>
              </tr>
              <tr>
                <th><span>���� ����</span></th>
                <td><%=payMethod%></td>
              </tr>
              <tr>
                <th><span>��ǰ��</span></th>
                <td><%=goodsName%></td>
              </tr>
              <tr>
                <th><span>�ݾ�</span></th>
                <td><%=amt%>��</td>
              </tr>
              <tr>
                <th><span>�ŷ����̵�</span></th>
                <td><%=tid%></td>
              </tr>               
            <%If paymethod="CARD" Then %>
              <tr>
                <th><span>ī����</span></th>
                <td><%=cardName%></td>
              </tr>
              <tr>
                <th><span>�Һΰ���</span></th>
                <td><%=cardQuota%></td>
              </tr>
            <%ElseIf paymethod="BANK" Then%>
              <tr>
                <th><span>����</span></th>
                <td><%=bankName%></td>
              </tr>
              <tr>
                <th><span>���ݿ����� Ÿ��(0:�������,1:�ҵ����,2:��������)</span></th>
                <td><%=rcptType%></td>
              </tr>
            <%ElseIf paymethod="CELLPHONE" Then%>
              <tr>
                <th><span>����� ����</span></th>
                <td><%=carrier%></td>
              </tr>
              <tr>
                <th><span>�޴��� ��ȣ</span></th>
                <td><%=dstAddr%></td>
              </tr>
            <%ElseIf paymethod="VBANK" Then%>
              <tr>
                <th><span>�Ա� ����</span></th>
                <td><%=vBankName%></td>
              </tr>
              <tr>
                <th><span>�Ա� ����</span></th>
                <td><%=vbankNum%></td>
              </tr>
              <tr>
                <th><span>�Ա� ����</span></th>
                <td><%=vbankExpDate%></td>
              </tr>
	          <%End If%>
          </table>
        </div>
      </div>
      <p>*�׽�Ʈ ���̵��ΰ�� ���� ���� 11�� 30�п� ��ҵ˴ϴ�.</p>
    </div>
  </div>
</body>
</html>
