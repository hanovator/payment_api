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
* <������û �Ķ����>
* ������ Form �� ������ ������û �Ķ�����Դϴ�.
* ���������������� �⺻(�ʼ�) �Ķ���͸� ���õǾ� ������, 
* �߰� ������ �ɼ� �Ķ���ʹ� �����޴����� �����ϼ���.
*******************************************************
*/
String merchantKey      = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==";   // ����Ű
String merchantID       = "nicepay00m";                                                                                 // �������̵�
String goodsCnt         = "1";                                                                                          // ������ǰ����
String goodsName        = "���̽�����";                                                                                 // ������ǰ��
String price            = "1004";                                                                                       // ������ǰ�ݾ�	
String buyerName        = "���̽�";                                                                                     // �����ڸ�
String buyerTel         = "01000000000";                                                                                // �����ڿ���ó
String buyerEmail       = "happy@day.co.kr";                                                                            // �����ڸ����ּ�
String moid             = "mnoid1234567890";                                                                            // ��ǰ�ֹ���ȣ
String returnURL        = "http://localhost:8095/auth/MOBILE_LITE_JSP/payResult.jsp";                                   // ���������(������)
String charset          = "euc-kr";                                                                                     // ���ڵ�
String goodsCl          = "1";                                                                                          // ��ǰ���� �ǹ�(1), ������(2)
String encodeParameters = "CardNo,CardExpire,CardPwd";                                                                  // ��ȣȭ����׸� (����Ұ�)
	
/*
*******************************************************
* <�ؽ���ȣȭ> (�������� ������)
* SHA-256 �ؽ���ȣȭ�� �ŷ� �������� �������� ����Դϴ�. 
*******************************************************
*/
DataEncrypt sha256Enc 	= new DataEncrypt();
String ediDate      	= getyyyyMMddHHmmss();	
String hashString    	= sha256Enc.encrypt(ediDate + merchantID + price + merchantKey);

/*
******************************************************* 
* <���� IP��>
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
//����â ���� ��û�� ����˴ϴ�. <<'nicepaySubmit()' �̸� ���� �Ұ���>>
function nicepayStart(){
    document.getElementById("vExp").value = getTomorrow();
    document.payForm.submit();
}

//��������Աݸ����� ���� (today +1)
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
				<th><span>���� ����</span></th>
				<td>
				  <select name="PayMethod">
					<option value="CARD">�ſ�ī��</option>
					<option value="BANK">������ü</option>
					<option value="CELLPHONE">�޴�������</option>
					<option value="VBANK">�������</option>
				  </select>
				</td>
			  </tr>
			  <tr>
				<th><span>���� ��ǰ��</span></th>
				<td><input type="text" name="GoodsName" value="<%=goodsName%>"></td>
			  </tr>			  
			  <tr>
				<th><span>���� ��ǰ����</span></th>
				<td><input type="text" name="GoodsCnt" value="<%=goodsCnt%>"></td>
			  </tr>	  
			  <tr>
				<th><span>���� ��ǰ�ݾ�</span></th>
				<td><input type="text" name="Amt" value="<%=price%>"></td>
			  </tr>	  
			  <tr>
				<th><span>�����ڸ�</span></th>
				<td><input type="text" name="BuyerName" value="<%=buyerName%>"></td>
			  </tr>	  
			  <tr>
				<th><span>������ ����ó</span></th>
				<td><input type="text" name="BuyerTel" value="<%=buyerTel%>"></td>
			  </tr>    
			  <tr>
				<th><span>��ǰ �ֹ���ȣ</span></th>
				<td><input type="text" name="Moid" value="<%=moid%>"></td>
			  </tr>
              <tr>
                <th><span>���� ���̵�</span></th>
                <td><input type="text" name="MID" value="<%=merchantID%>"></td>
              </tr>              
			  
			  <!-- IP -->
			  <input type="hidden" name="MallIP" value="<%=inet.getHostAddress()%>"/>      <!-- ��������IP -->
			  
			  <!-- �ɼ� -->
			  <input type="hidden" name="VbankExpDate" id="vExp"/>                         <!-- ��������Աݸ����� -->
			  <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"/>             <!-- ������ �̸��� -->				  
			  <input type="hidden" name="GoodsCl" value="<%=goodsCl%>"/>                   <!-- ��ǰ���� �ǹ�(1), ������(0) -->
			  <input type="hidden" name="CharSet" value="<%=charset%>"/>                   <!-- ���ڵ� ���� -->
			  <input type="hidden" name="ReturnURL" value="<%=returnURL%>">                <!-- Return URL -->
              
			  <!-- ���� �Ұ��� -->
              <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>"/> <!-- ��ȣȭ����׸� -->              
			  <input type="hidden" name="ediDate" value="<%=ediDate%>"/>                   <!-- ���� �����Ͻ� -->
			  <input type="hidden" name="EncryptData" value="<%=hashString%>"/>            <!-- �ؽ���	-->
			  <input type="hidden" name="TrKey" value=""/>                                 <!-- �ʵ常 �ʿ� -->
			  <input type="hidden" name="AcsNoIframe" value="Y"/>						   <!-- ���̽����� ����â ������ �ɼ� (����Ұ�) -->
			  
			</table>
		  </div>
		</div>
		<div class="btngroup">
		  <a href="#" class="btn_blue" onClick="nicepayStart();">�� û</a>
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
// SHA-256 �������� ��ȣȭ
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
			System.out.print("��ȣȭ ����" + e.toString());
	    }
		return passACL;
	}
	
	public String encodeHex(byte [] b){
		char [] c = Hex.encodeHex(b);
		return new String(c);
	}
}
%>