<%
m_authResultCode = request.form("AuthResultCode")                       '������� : 0000(����)
m_authResultMsg = request.form("AuthResultMsg")                         '������� �޽���

IF (m_authResultCode = "0000") THEN
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <���� ��� ����>
' �α� ���丮�� NICE.dll�� ��ġ��ġ /log ���� �Դϴ�.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Dim PInst  
Set NICEpay      = Server.CreateObject("NICE.NICETX2.1")
PInst            = NICEpay.InitializeX64("")
merchantKey      = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==" '����Ű
merchantID       = "nicepay00m"                                    '�������̵�

NICEpay.SetActionTypeX64 (PInst),"SECUREPAY"                       '�ŷ� ����
NICEpay.SetFieldX64 (PInst),"logpath","C:\log"                     'logpath
NICEpay.SetFieldX64 (PInst),"mid",merchantID                       '���� ID
NICEpay.SetFieldX64 (PInst),"LicenseKey",merchantKey               '����������Ű
NICEpay.SetFieldX64 (PInst),"tid",Request("TID")                   '�ŷ� ���̵� 
NICEpay.SetFieldX64 (PInst),"paymethod",Request("paymethod")       '���Ҽ���
NICEpay.SetFieldX64 (PInst),"amt",Request("amt")                   '�����ݾ� 
NICEpay.SetFieldX64 (PInst),"moid",Request("moid")                 '���� �ֹ���ȣ
NICEpay.SetFieldX64 (PInst),"GoodsName",Request("goodsname")       '��ǰ��
NICEpay.SetFieldX64 (PInst),"currency","KRW"                       '��ȭ����
NICEpay.SetFieldX64 (PInst),"buyername",Request("buyername")       '����
NICEpay.SetFieldX64 (PInst),"malluserid",Request("malluserid")     'ȸ�����ID
NICEpay.SetFieldX64 (PInst),"buyertel",Request("buyertel")         '�̵���ȭ
NICEpay.SetFieldX64 (PInst),"buyeremail",Request("buyeremail")     '�̸���
NICEpay.SetFieldX64 (PInst),"parentemail",Request("parentemail")   '��ȣ�� �̸��� �ּ�
NICEpay.SetFieldX64 (PInst),"debug","true"                         '�α׸��("true" �� �α�)
NICEpay.SetFieldX64 (PInst),"CancelPwd","123456"                   '��� �н�����
NICEpay.SetFieldX64 (PInst),"goodscl",Request("GoodsCl")           '�޴���/������
NICEpay.SetFieldX64 (PInst),"TransType",Request("TransType")       '�ŷ�����
NICEpay.SetFieldX64 (PInst),"trkey",Request("TrKey")
NICEpay.StartActionX64((PInst))

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <���� ��� �ʵ�>
' �Ʒ� ���� ������ �ܿ��� ���� Header�� ������ ������ Get ����
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
m_tid             = NICEpay.GetResultX64((PInst),"tid")            '�ŷ���ȣ
m_moid            = NICEpay.GetResultX64((PInst),"moid")           '�����ŷ���ȣ
m_resultCode      = NICEpay.GetResultX64((PInst),"resultcode")     '����ڵ�
m_resultMsg       = NICEpay.GetResultX64((PInst),"resultmsg")      '����޽���
m_goodsName       = NICEpay.GetResultX64((PInst),"GoodsName")      '��ǰ��
m_authDate        = NICEpay.GetResultX64((PInst),"AuthDate")       '�����Ͻ�
m_authCode        = NICEpay.GetResultX64((PInst),"authcode")       '���ι�ȣ
m_amt             = NICEpay.GetResultX64((PInst),"amt")            '���αݾ�
m_payMethod       = NICEpay.GetResultX64((PInst),"PayMethod")      '��������
m_cardCode        = NICEpay.GetResultX64((PInst),"CardCode")       'ī��� �ڵ�
m_cardName        = NICEpay.GetResultX64((PInst),"CardName")       'ī����
m_cardCaptureCode = NICEpay.GetResultX64((PInst),"AcquCardCode")   '���Ի� �ڵ� 
m_cardCaptureName = NICEpay.GetResultX64((PInst),"AcquCardName")   '���Ի� ��
m_bankCode        = NICEpay.GetResultX64((PInst),"BankCode")       '�����ڵ�
m_bankName        = NICEpay.GetResultX64((PInst),"BankName")       '����� 
m_vbankBankCode   = NICEpay.GetResultX64((PInst),"VbankBankCode")  '������������ڵ�
m_vbankBankName   = NICEpay.GetResultX64((PInst),"VbankBankName")  '������������
m_vbankNum        = NICEpay.GetResultX64((PInst),"VbankNum")       '������¹�ȣ
m_vbankExpDate    = NICEpay.GetResultX64((PInst),"VbankExpDate")   '��������Աݿ����� 
m_carrier         = NICEpay.GetResultX64((PInst),"Carrier")        '����籸��
m_dstAddr         = NICEpay.GetResultX64((PInst),"DstAddr")        '�޴�����ȣ 

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <���� ���� ���� Ȯ��>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''     
paySuccess = False	' ���� ���� ����

IF (m_payMethod = "CARD") THEN 
	If resultCode = "3001" Then paySuccess  = True                  '�ſ�ī��(���� ����ڵ�:3001)
ELSEIF (m_payMethod ="BANK") Then
	If resultCode = "4000" Then paySuccess  = True                  '������ü(���� ����ڵ�:4000)
ELSEIF (m_payMethod ="VBANK") THEN  
	If resultCode = "4100" Then paySuccess  = True                  '�޴���(���� ����ڵ�:A000) 
ELSEIF (m_payMethod ="CELLPHONE") THEN  
	If resultCode = "A000" Then paySuccess  = True                  '�������(���� ����ڵ�:4100)
END IF

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <Ŭ���� ����>
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
                <td>[<%=m_ResultCode%>]<%=m_ResultMsg%></td>
              </tr>
              <tr>
                <th><span>���� ����</span></th>
                <td><%=m_payMethod%></td>
              </tr>
              <tr>
                <th><span>��ǰ��</span></th>
                <td><%=m_goodsName%></td>
              </tr>
              <tr>
                <th><span>�ݾ�</span></th>
                <td><%=m_amt%>��</td>
              </tr>
              <tr>
                <th><span>�ŷ����̵�</span></th>
                <td><%=m_tid%></td>
              </tr>               
            <%If paymethod="CARD" Then %>
              <tr>
                <th><span>ī����</span></th>
                <td><%=m_cardName%></td>
              </tr>
              <tr>
                <th><span>ī���ڵ�</span></th>
                <td><%=m_cardCode%></td>
              </tr>
            <%ElseIf paymethod="BANK" Then%>
              <tr>
                <th><span>�����̸�</span></th>
                <td><%=m_bankName%></td>
              </tr>
              <tr>
                <th><span>�����ڵ�</span></th>
                <td><%=m_bankName%></td>
              </tr>
            <%ElseIf paymethod="CELLPHONE" Then%>
              <tr>
                <th><span>����� ����</span></th>
                <td><%=m_carrier%></td>
              </tr>
              <tr>
                <th><span>�޴��� ��ȣ</span></th>
                <td><%=m_dstAddr%></td>
              </tr>
            <%ElseIf paymethod="VBANK" Then%>
              <tr>
                <th><span>�Ա� ����</span></th>
                <td><%=m_vbankBankName%></td>
              </tr>
              <tr>
                <th><span>�Ա� ����</span></th>
                <td><%=m_vbankNum%></td>
              </tr>
              <tr>
                <th><span>�Ա� ����</span></th>
                <td><%=m_vbankExpDate%></td>
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