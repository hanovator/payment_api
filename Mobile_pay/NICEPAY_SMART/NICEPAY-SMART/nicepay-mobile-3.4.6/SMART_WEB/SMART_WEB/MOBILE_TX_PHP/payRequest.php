<?php
header("Content-Type:text/html; charset=euc-kr;");
/*
*******************************************************
* <������û �Ķ����>
* ������ Form �� ������ ������û �Ķ�����Դϴ�.
* ���������������� �⺻(�ʼ�) �Ķ���͸� ���õǾ� ������, 
* �߰� ������ �ɼ� �Ķ���ʹ� �����޴����� �����ϼ���.
*******************************************************
*/
$merchantKey      = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==";   // ����Ű
$merchantID       = "nicepay00m";                                                       // �������̵�
$goodsCnt         = "1";                                                                // ������ǰ����
$goodsName        = "���̽�����";                                                       // ������ǰ��
$price            = "1004";                                                             // ������ǰ�ݾ�	
$buyerName        = "���̽�";                                                           // �����ڸ�
$buyerTel         = "01000000000";                                                      // �����ڿ���ó
$buyerEmail       = "happy@day.co.kr";                                                  // �����ڸ����ּ�
$moid             = "mnoid1234567890";                                                  // ��ǰ�ֹ���ȣ
$ReturnURL        = "http://localhost:90/MOBILE_TX_PHP/payResult.php";              // Return URL
$CharSet          = "euc-kr";                                                           // ����� ���ڵ� ����

/*
*******************************************************
* <�ؽ���ȣȭ> (�������� ������)
* SHA-256 �ؽ���ȣȭ�� �ŷ� �������� �������� ����Դϴ�. 
*******************************************************
*/ 
$ediDate = date("YmdHis");
$hashString = bin2hex(hash('sha256', $ediDate.$merchantID.$price.$merchantKey, true));
?>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY REQUEST(EUC-KR)</title>
<meta charset="euc-kr"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi"/>
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script type="text/javascript">
//����Ʈ�� ���� ��û
function goPay(form) {
    document.getElementById("vExp").value = getTomorrow();   
    document.tranMgr.submit();
}
//������� �Աݸ����� ���� (today +1)
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
<form name="tranMgr" method="post" target="_self" action="https://web.nicepay.co.kr/v3/smart/smartPayment.jsp">
  <div class="payfin_area">
    <div class="top">NICEPAY PAY REQUEST(EUC-KR)</div>
    <div class="conwrap">
      <div class="con">
        <div class="tabletypea">
          <table>
            <colgroup><col width="30%"/><col width="*"/></colgroup>
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
                <td><input type="text" name="GoodsName" value="<?=$goodsName?>"></td>
              </tr>			  
              <tr>
                <th><span>���� ��ǰ����</span></th>
                <td><input type="text" name="GoodsCnt" value="<?=$goodsCnt?>"></td>
              </tr>	  
              <tr>
                <th><span>���� ��ǰ�ݾ�</span></th>
                <td><input type="text" name="Amt" value="<?=$price?>"></td>
              </tr>	  
              <tr>
                <th><span>�����ڸ�</span></th>
                <td><input type="text" name="BuyerName" value="<?=$buyerName?>"></td>
              </tr>	  
              <tr>
                <th><span>������ ����ó</span></th>
                <td><input type="text" name="BuyerTel" value="<?=$buyerTel?>"></td>
              </tr>    
              <tr>
                <th><span>��ǰ �ֹ���ȣ</span></th>
                <td><input type="text" name="Moid" value="<?=$moid?>"></td>
              </tr>
              <tr>
                <th><span>���� ���̵�</span></th>
                <td><input type="text" name="MID" value="<?=$merchantID?>"></td>
              </tr>               
              
              <!-- �ɼ� -->
              <input type="hidden" name="ReturnURL" value="<?=$ReturnURL?>"/>       <!-- Return URL -->		     
              <input type="hidden" name="CharSet" value="<?=$CharSet?>"/>           <!-- ���ڵ� ���� -->              
              <input type="hidden" name="GoodsCl" value="1"/>                       <!-- ��ǰ���� �ǹ�(1), ������(0) -->
              <input type="hidden" name="VbankExpDate" id="vExp"/>                  <!-- ��������Աݸ����� -->                        
              <input type="hidden" name="BuyerEmail" value="<?=$buyerEmail?>"/>     <!-- ������ �̸��� -->             				  
               
              <!-- ���� �Ұ��� -->
              <input type="hidden" name="EncryptData" value="<?=$hashString?>"/>    <!-- �ؽ��� -->
              <input type="hidden" name="ediDate" value="<?=$ediDate?>"/>           <!-- ���� �����Ͻ� --> 
			  <input type="hidden" name="AcsNoIframe" value="Y"/>				    <!-- ���̽����� ����â ������ �ɼ� (����Ұ�) -->
			  
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