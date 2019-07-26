<%@ Page Language="C#"  AutoEventWireup="true" Src="payRequest.aspx.cs" Inherits="payReqSmart"  %>

<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY REQUEST(UTF-8)</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script type="text/javascript">
function goPay(){
	document.tranMgr.submit();
}
</script>
</head>
<body>
<form name="tranMgr" method="post" target="_self"; action="https://web.nicepay.co.kr/v3/smart/smartPayment.jsp" accept-charset="euc-kr">
    <div class="payfin_area">
      <div class="top">NICEPAY PAY REQUEST(UTF-8)</div>
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
                <th><span>������</span></th>
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

			  <!-- �ɼ� -->
			  <input type="hidden" name="VbankExpDate" value="<%=TomorrowDateString()%>"/>      <!-- ��������Աݸ����� -->
			  <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"/>                  <!-- ������ �̸��� -->				  
			  <input type="hidden" name="GoodsCl" value="<%=goodsCl%>"/>                        <!-- ��ǰ���� �ǹ�(1), ������(0) -->
			  <input type="hidden" name="CharSet" value="<%=charSet%>"/>                        <!-- ���ڵ� ���� -->
			  <input type="hidden" name="ReturnURL" value="<%=returnURL%>">                     <!-- Return URL -->
              <input type="hidden" name="MallReserved"  value=""/>
              
			  <!-- ���� �Ұ��� -->
			  <input type="hidden" name="ediDate" value="<%=ediDate%>"/>                        <!-- ���� �����Ͻ� -->
			  <input type="hidden" name="EncryptData" value="<%=hash_String%>"/>                <!-- �ؽ���	-->
			  <input type="hidden" name="TrKey" value=""/>                                      <!-- �ʵ常 �ʿ� -->
			  <input type="hidden" name="MerchantKey" value="<%=merchantKey%>"/>                <!-- ���� Ű -->		
			  <input type="hidden" name="AcsNoIframe" value="Y"/>								<!-- ���̽����� ����â ������ �ɼ� (����Ұ�) -->
			  
			</table>
		  </div>
		</div>
		<div class="btngroup">
		  <a href="#" class="btn_blue" onClick="goPay();">�� û</a>
		</div>
	  </div>
	</div>
</form>
</body>
</html>