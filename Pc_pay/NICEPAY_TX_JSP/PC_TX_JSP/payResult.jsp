<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="kr.co.nicevan.nicepay.adapter.web.NicePayHttpServletRequestWrapper"%>
<%@ page import="kr.co.nicevan.nicepay.adapter.web.NicePayWEB"%>
<%@ page import="kr.co.nicevan.nicepay.adapter.web.dto.WebMessageDTO"%>
<%
request.setCharacterEncoding("euc-kr"); 

/*
*******************************************************
* <���� ��� ����>
* ����� ��� �ɼ��� ����� ȯ�濡 �µ��� �����ϼ���.
* �α� ���丮�� �� �����ϼ���.
*******************************************************
*/
NicePayWEB nicepayWEB = new NicePayWEB();
String payMethod = request.getParameter("PayMethod");
String merchantKey = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==";

nicepayWEB.setParam("NICEPAY_LOG_HOME","C:/log");                           // �α� ���丮 ����
nicepayWEB.setParam("APP_LOG","1");                                         // ���ø����̼Ƿα� ��� ����(0: DISABLE, 1: ENABLE)
nicepayWEB.setParam("EVENT_LOG","1");                                       // �̺�Ʈ�α� ��� ����(0: DISABLE, 1: ENABLE)
nicepayWEB.setParam("EncFlag","S");                                         // ��ȣȭ�÷��� ����(N: ��, S:��ȣȭ)
nicepayWEB.setParam("SERVICE_MODE","PY0");                                  // ���񽺸�� ����(���� ���� : PY0 , ��� ���� : CL0)
nicepayWEB.setParam("Currency","KRW");                                      // ��ȭ ����(���� KRW(��ȭ) ����)                                                      
nicepayWEB.setParam("PayMethod",payMethod);                                 // �������                                                  
nicepayWEB.setParam("EncodeKey",merchantKey);                               // ����Ű  

/*
*******************************************************
* <���� ��� �ʵ�>
* �Ʒ� ���� ������ �ܿ��� ���� Header�� ������ ������ Get ����
*******************************************************
*/
NicePayHttpServletRequestWrapper httpRequestWrapper = new NicePayHttpServletRequestWrapper(request);
httpRequestWrapper.addParameter("EncMode","S10");                           // ���� ��ȣȭ
WebMessageDTO responseDTO   = nicepayWEB.doService(httpRequestWrapper,response);

String resultCode           = responseDTO.getParameter("ResultCode");       // ����ڵ� (���� ����ڵ�:3001)
String resultMsg            = responseDTO.getParameter("ResultMsg");        // ����޽���
String authDate             = responseDTO.getParameter("AuthDate");         // �����Ͻ� (YYMMDDHH24mmss)
String authCode             = responseDTO.getParameter("AuthCode");         // ���ι�ȣ
String buyerName            = responseDTO.getParameter("BuyerName");        // �����ڸ�
String mallUserID           = responseDTO.getParameter("MallUserID");       // ȸ�����ID
String goodsName            = responseDTO.getParameter("GoodsName");        // ��ǰ��
String mid                  = responseDTO.getParameter("MID");              // ����ID
String tid                  = responseDTO.getParameter("TID");              // �ŷ�ID
String moid                 = responseDTO.getParameter("Moid");             // �ֹ���ȣ
String amt                  = responseDTO.getParameter("Amt");              // �ݾ�
String cardCode             = responseDTO.getParameter("CardCode");         // ����ī����ڵ�
String cardName             = responseDTO.getParameter("CardName");         // ����ī����
String cardQuota            = responseDTO.getParameter("CardQuota");        // ī�� �Һΰ��� (00:�Ͻú�,02:2����)
String bankCode             = responseDTO.getParameter("BankCode");         // �����ڵ�
String bankName             = responseDTO.getParameter("BankName");         // �����
String rcptType             = responseDTO.getParameter("RcptType");         // ���� ������ Ÿ�� (0:�����������,1:�ҵ����,2:��������)
String rcptAuthCode         = responseDTO.getParameter("RcptAuthCode");     // ���ݿ����� ���� ��ȣ
String rcptTID              = responseDTO.getParameter("RcptTID");          // ���� ������ TID   
String carrier              = responseDTO.getParameter("Carrier");          // ����籸��
String dstAddr              = responseDTO.getParameter("DstAddr");          // �޴�����ȣ
String vbankBankCode        = responseDTO.getParameter("VbankBankCode");    // ������������ڵ�
String vbankBankName        = responseDTO.getParameter("VbankBankName");    // ������������
String vbankNum             = responseDTO.getParameter("VbankNum");         // ������¹�ȣ
String vbankExpDate         = responseDTO.getParameter("VbankExpDate");     // ��������Աݿ�����

/*
*******************************************************
* <���� ���� ���� Ȯ��>
*******************************************************
*/
boolean paySuccess = false;
if(payMethod.equals("CARD")){
    if(resultCode.equals("3001")) paySuccess = true;	                      // �ſ�ī��(���� ����ڵ�:3001)       	
}else if(payMethod.equals("BANK")){		                                    
    if(resultCode.equals("4000")) paySuccess = true;                        // ������ü(���� ����ڵ�:4000)	
}else if(payMethod.equals("CELLPHONE")){			                        
    if(resultCode.equals("A000")) paySuccess = true;                        // �޴���(���� ����ڵ�:A000)	
}else if(payMethod.equals("VBANK")){		                                
    if(resultCode.equals("4100")) paySuccess = true;                        // �������(���� ����ڵ�:4100)
}else if(payMethod.equals("SSG_BANK")){										
	if(resultCode.equals("0000")) paySuccess = true;						// SSG�������(���� ����ڵ�:0000)
}
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
            <%if(payMethod.equals("CARD")){%>
              <tr>
                <th><span>ī����</span></th>
                <td><%=cardName%></td>
              </tr>
              <tr>
                <th><span>�Һΰ���</span></th>
                <td><%=cardQuota%></td>
              </tr>
            <%}else if(payMethod.equals("BANK")){%>
              <tr>
                <th><span>����</span></th>
                <td><%=bankName%></td>
              </tr>
              <tr>
                <th><span>���ݿ����� Ÿ��</span></th>
                <td><%=rcptType%>(0:�������,1:�ҵ����,2:��������)</td>
              </tr>
            <%}else if(payMethod.equals("CELLPHONE")){%>
              <tr>
                <th><span>����� ����</span></th>
                <td><%=carrier%></td>
              </tr>
              <tr>
                <th><span>�޴��� ��ȣ</span></th>
                <td><%=dstAddr%></td>
              </tr>
            <%}else if(payMethod.equals("VBANK")){%>
              <tr>
                <th><span>�Ա� ����</span></th>
                <td><%=vbankBankName%></td>
              </tr>
              <tr>
                <th><span>�Ա� ����</span></th>
                <td><%=vbankNum%></td>
              </tr>
              <tr>
                <th><span>�Ա� ����</span></th>
                <td><%=vbankExpDate%></td>
              </tr>
            <%}else if(payMethod.equals("SSG_BANK")){%>
              <tr>
                <th><span>����</span></th>
                <td><%=bankName%></td>
              </tr>
              <tr>
                <th><span>���ݿ����� Ÿ��</span></th>
                <td><%=rcptType%>(0:�������,1:�ҵ����,2:��������)</td>
              </tr>
            <%}%>
          </table>
        </div>
      </div>
      <p>*�׽�Ʈ ���̵��ΰ�� ���� ���� 11�� 30�п� ��ҵ˴ϴ�.</p>
    </div>
  </div>
</body>
</html>