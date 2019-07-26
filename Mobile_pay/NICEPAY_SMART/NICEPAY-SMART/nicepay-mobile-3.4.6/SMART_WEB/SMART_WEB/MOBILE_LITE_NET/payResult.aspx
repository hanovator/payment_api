<%@ Page Language="C#" AutoEventWireup="true" Src="payResult.aspx.cs" Inherits="payResult" %>

<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY RESULT(UTF-8)</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script type="text/javascript">
function printReceipt(tid) {    
    var status = "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width=420,height=540";
           var url = "https://pg.nicepay.co.kr/issue/IssueLoader.jsp?TID="+tid+"&type=0";
    window.open(url,"popupIssue",status);
} 
</script>
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
                <th><span>결과내용</span></th>
                <td>[<asp:Literal ID="ResultCode" runat="server"/>] <asp:Literal ID="ResultMsg" runat="server"/><asp:Literal ID="ReceiptIssue" runat="server"/></td>
              </tr>
              <tr>
                <th><span>결제수단</span></th>
                <td><asp:Literal ID="PayMethod" runat="server"/></td>
              </tr>
              <tr>
                <th><span>상품명</span></th>
                <td><asp:Literal ID="GoodsName" runat="server"/></td>
              </tr>
              <tr>
                <th><span>금액</span></th>
                <td><asp:Literal ID="Amt" runat="server"/> 원</td>
              </tr>
              <tr>
                <th><span>거래아이디</span></th>
                <td><asp:Literal ID="TID" runat="server"/></td>
              </tr>
              <tr>
                <th><span>주문번호</span></th>
                <td><asp:Literal ID="Moid" runat="server"/></td>
              </tr>
              <tr>
                <th><span>주문번호</span></th>
                <td><asp:Literal ID="MID" runat="server"/></td>
              </tr>
              <tr>
                <th><span>구매자명</span></th>
                <td><asp:Literal ID="BuyerName" runat="server"/></td>
              </tr>
              <tr>
                <th><span>승인일시</span></th>
                <td><asp:Literal ID="AuthDate" runat="server"/></td>
              </tr>       
            <asp:panel id="cardPanel" runat="server" visible="false">
              <tr>
                <th><span>승인번호</span></th>
                <td><asp:Literal ID="AuthCode" runat="server"/></td>
              </tr>     
              <tr>
                <th><span>발급사명</span></th>
                <td><asp:Literal ID="CardName" runat="server"/></td>
              </tr> 
              <tr>
                <th><span>발급사코드</span></th>
                <td><asp:Literal ID="CardCode" runat="server"/></td>
              </tr>
              <tr>
                <th><span>매입사명</span></th>
                <td><asp:Literal ID="AcquCardName" runat="server"/></td>
              </tr>
              <tr>
                <th><span>매입사코드</span></th>
                <td><asp:Literal ID="AcquCardCode" runat="server"/></td>
              </tr>       			    
              <tr>
                <th><span>할부기간</span></th>
                <td><asp:Literal ID="CardQuota" runat="server"/></td>
              </tr>      
              <tr>
                <th><span>카드번호</span></th>
                <td><asp:Literal ID="CardNumber" runat="server"/></td>
              </tr>    
    			  </asp:panel>
        	  <asp:panel id="bankPanel" runat="server" visible="false">
              <tr>
                <th><span>은행코드</span></th>
                <td><asp:Literal ID="BankCode" runat="server"/></td>
              </tr>
              <tr>
                <th><span>은행명</span></th>
                <td><asp:Literal ID="BankName" runat="server"/></td>
              </tr>
              <tr>
                <th><span>현금영수증 타입(0:발행안함,1:소득공제,2:지출증빙)</span></th>
                <td><asp:Literal ID="RcptType" runat="server"/></td>
              </tr>
              <tr>
                <th><span>현금영수증 승인번호</span></th>
                <td><asp:Literal ID="RcptAuthCode" runat="server"/></td>
              </tr>
    			  </asp:panel>
    			  <asp:panel id="cellphonePanel" runat="server" visible="false">
              <tr>
                <th><span>이통사구분</span></th>
                <td><asp:Literal ID="Carrier" runat="server"/></td>
              </tr>
              <tr>
                <th><span>휴대폰번호</span></th>
                <td><asp:Literal ID="DstAddr" runat="server"/></td>
              </tr>
    			  </asp:panel>
    			  <asp:panel id="vbankPanel" runat="server" visible="false">
              <tr>
                <th><span>가상계좌코드</span></th>
                <td><asp:Literal ID="VbankBankCode" runat="server"/></td>
              </tr>
              <tr>
                <th><span>가상계좌은행명</span></th>
                <td><asp:Literal ID="VbankName" runat="server"/></td>
              </tr>
              <tr>
                <th><span>가상계좌번호</span></th>
                <td><asp:Literal ID="VbankNum" runat="server"/></td>
              </tr>
              <tr>
                <th><span>가상계좌 입금만료일</span></th>
                <td><asp:Literal ID="VbankExpDate" runat="server"/></td>
              </tr>
    			  </asp:panel>
          </table>
        </div>
      </div>
      <p>*테스트 아이디인경우 당일 오후 11시 30분에 취소됩니다.</p>
    </div>
  </div>
</body>
</html>