<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page import="kr.co.nicepay.module.lite.NicePayWebConnector"%>
<%
request.setCharacterEncoding("euc-kr"); 
/*
*******************************************************
* <���� ��� ����>
* ����� ��� �ɼ��� ����� ȯ�濡 �µ��� �����ϼ���.
* �α� ���丮�� �� �����ϼ���.
*******************************************************
*/
String logPath              = "C:/workspace/server/tomcat_8.0/webapps/ROOT/auth/MOBILE_LITE_JSP/WEB-INF"; // �α� ���丮(��⳻ WEB-INF Path ����)
String mid                  = "nicepay00m";                                                               // ����ID
String actionType           = "PY0";                                                                      // ���񽺸�� ����(���� ���� : PY0 , ��� ���� : CL0)
String cancelPwd            = "123456";                                                                   // ��� ��й�ȣ

/*
*******************************************************
* <���� �ʱ�ȭ>
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
* <���� ���>
*******************************************************
*/
authResultCode   = (String)request.getParameter("AuthResultCode");                                         // ������� : 0000(����)
authResultMsg    = (String)request.getParameter("AuthResultMsg");                                          // ������� �޽���

if("0000".equals(authResultCode)){
    NicePayWebConnector connector = new NicePayWebConnector();
    connector.setNicePayHome(logPath);                                  
    connector.setRequestData(request);                                  
    connector.addRequestData("MID", mid);                      
    connector.addRequestData("actionType", actionType);                      
    connector.addRequestData("MallIP", request.getRemoteAddr());                                           // ���� ���� ip
    connector.addRequestData("CancelPwd", cancelPwd);                    
    connector.requestAction();

    /*
    *******************************************************
    * <���� ��� �ʵ�>
    * �Ʒ� ���� ������ �ܿ��� ���� Header�� ������ ������ Get ����
    *******************************************************
    */

    resultCode    = connector.getResultData("ResultCode");                                                 // ����ڵ� (���� ����ڵ�:3001)
    resultMsg     = connector.getResultData("ResultMsg");                                                  // ����޽���
    authDate      = connector.getResultData("AuthDate");                                                   // �����Ͻ� (YYMMDDHH24mmss)
    authCode      = connector.getResultData("AuthCode");                                                   // ���ι�ȣ
    buyerName     = connector.getResultData("BuyerName");                                                  // �����ڸ�
    mallUserID    = connector.getResultData("MallUserID");                                                 // ȸ�����ID
    payMethod     = connector.getResultData("PayMethod");                                                  // ��������
    tid           = connector.getResultData("TID");                                                        // �ŷ�ID
    moid          = connector.getResultData("Moid");                                                       // �ֹ���ȣ
    amt           = connector.getResultData("Amt");                                                        // �ݾ�
    goodsName     = connector.getResultData("GoodsName");                                                  // �ݾ�
    cardCode      = connector.getResultData("CardCode");                                                   // ī��� �ڵ�
    cardName      = connector.getResultData("CardName");                                                   // ����ī����
    cardQuota     = connector.getResultData("CardQuota");                                                  // ī�� �Һΰ��� (00:�Ͻú�,02:2����)
    bankCode      = connector.getResultData("BankCode");                                                   // ���� �ڵ�
    bankName      = connector.getResultData("BankName");                                                   // �����
    rcptType      = connector.getResultData("RcptType");                                                   // ���� ������ Ÿ�� (0:�����������,1:�ҵ����,2:��������)
    rcptAuthCode  = connector.getResultData("RcptAuthCode");                                               // ���ݿ����� ���� ��ȣ
    rcptTID       = connector.getResultData("RcptTID");                                                    // ���� ������ TID   
    carrier       = connector.getResultData("Carrier");                                                    // ����籸��
    dstAddr       = connector.getResultData("DstAddr");                                                    // �޴�����ȣ
    vbankBankCode = connector.getResultData("VbankBankCode");                                              // ������������ڵ�
    vbankBankName = connector.getResultData("VbankBankName");                                              // ������������
    vbankNum      = connector.getResultData("VbankNum");                                                   // ������¹�ȣ
    vbankExpDate  = connector.getResultData("VbankExpDate");                                               // ��������Աݿ�����

    /*
    *******************************************************
    * <���� ���� ���� Ȯ��>
    *******************************************************
    */
    boolean paySuccess = false;
    if(payMethod.equals("CARD")){
        if(resultCode.equals("3001")) paySuccess = true;                                                   // �ſ�ī��(���� ����ڵ�:3001)
    }else if(payMethod.equals("BANK")){
        if(resultCode.equals("4000")) paySuccess = true;                                                   // ������ü(���� ����ڵ�:4000)	
    }else if(payMethod.equals("CELLPHONE")){
        if(resultCode.equals("A000")) paySuccess = true;                                                   // �޴���(���� ����ڵ�:A000)
    }else if(payMethod.equals("VBANK")){	
        if(resultCode.equals("4100")) paySuccess = true;                                                   // �������(���� ����ڵ�:4100)
    }else if(payMethod.equals("SSG_BANK")){										
    	if(resultCode.equals("0000")) paySuccess = true;												   // SSG�������(���� ����ڵ�:0000)
    }

}else{
    resultCode = authResultCode;
	resultMsg  = authResultMsg;
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