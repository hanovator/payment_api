using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using NiceLiteLibNet;

public partial class payResult : System.Web.UI.Page{
    protected System.Web.UI.WebControls.Literal PayMethod;
    protected System.Web.UI.WebControls.Literal MID;
    protected System.Web.UI.WebControls.Literal Amt;
    protected System.Web.UI.WebControls.Literal BuyerName;
    protected System.Web.UI.WebControls.Literal GoodsName;
    protected System.Web.UI.WebControls.Literal AuthCode;
    protected System.Web.UI.WebControls.Literal AuthDate;
    protected System.Web.UI.WebControls.Literal ResultCode;
    protected System.Web.UI.WebControls.Literal ResultMsg;
    protected System.Web.UI.WebControls.Literal TID;
    protected System.Web.UI.WebControls.Literal Moid;
    protected System.Web.UI.WebControls.Literal CardCode;
    protected System.Web.UI.WebControls.Literal CardName;
    protected System.Web.UI.WebControls.Literal AcquCardCode;
    protected System.Web.UI.WebControls.Literal AcquCardName;
    protected System.Web.UI.WebControls.Literal CardQuota;
    protected System.Web.UI.WebControls.Literal CardNumber;
    protected System.Web.UI.WebControls.Literal BankCode;
    protected System.Web.UI.WebControls.Literal BankName;
    protected System.Web.UI.WebControls.Literal RcptType;
    protected System.Web.UI.WebControls.Literal RcptAuthCode;
    protected System.Web.UI.WebControls.Literal Carrier;
    protected System.Web.UI.WebControls.Literal DstAddr;
    protected System.Web.UI.WebControls.Literal VbankNum;
    protected System.Web.UI.WebControls.Literal VbankName;
    protected System.Web.UI.WebControls.Literal VbankBankCode;
    protected System.Web.UI.WebControls.Literal VbankExpDate;
    protected System.Web.UI.WebControls.Literal ReceiptIssue;
    protected System.Web.UI.WebControls.Panel cardPanel;
    protected System.Web.UI.WebControls.Panel bankPanel;
    protected System.Web.UI.WebControls.Panel cellphonePanel;
    protected System.Web.UI.WebControls.Panel vbankPanel;
    protected string LogPath;
    protected string EncodeKey;
    protected string CancelPwd;
    protected string authResultCode;
    protected string authResultMsg;

    protected void Page_Load(object sender, EventArgs e){
        authResultCode = Request.Params["AuthResultCode"];            // 인증결과 : 0000(성공)
        authResultMsg = Request.Params["AuthResultMsg"];              // 인증결과 메시지

        if (authResultCode == "0000"){
            if (!Page.IsPostBack){
                resultData();
            }
        }else{
            ResultCode.Text = authResultCode;
            ResultMsg.Text = authResultMsg;
        }

    }

    protected void resultData(){
        /****************************************************
        * <결제 결과 설정>
        * 사용전 결과 옵션을 사용자 환경에 맞도록 변경하세요.
        * 로그 디렉토리는 꼭 변경하세요.
        ****************************************************/
        NiceLite lite = new NiceLite(@"SECUREPAY");

        LogPath = @"C:\log"; //로그 디렉토리   
        CancelPwd = @"123456";

        lite.SetField(@"LogPath",LogPath);                             //로그폴더 설정  
        lite.SetField(@"type",@"SECUREPAY");                           //타입설정(고정)  
        lite.SetField(@"MID",Request.Params["MID"]);                   //상점 아이디
        lite.SetField(@"Amt",Request.Params["Amt"]);                   //지불금액
        lite.SetField(@"EncodeKey",Request.Params["MerchantKey"]);     //상점 라이센스 키(상점 아이디별 상이)
        lite.SetField(@"CancelPwd",CancelPwd);                         //취소 패스워드(상점 관리자페이지에서 설정)
        lite.SetField(@"PayMethod",Request.Params["PayMethod"]);       //지불수단
        lite.SetField(@"GoodsName",Request.Params["GoodsName"]);       //상품명
        lite.SetField(@"GoodsCnt",Request.Params["GoodsCnt"]);         //상품갯수   
        lite.SetField(@"BuyerName",Request.Params["BuyerName"]);       //구매자 명
        lite.SetField(@"BuyerTel",Request.Params["BuyerTel"]);         //구매자 연락처
        lite.SetField(@"BuyerEmail",Request.Params["BuyerEmail"]);     //구매자 이메일         
        lite.SetField(@"ParentEmail",Request.Params["ParentEmail"]);   //보호자 이메일      
        lite.SetField(@"BuyerAddr",Request.Params["BuyerAddr"]);       //구매자 주소
        lite.SetField(@"BuyerPostNo",Request.Params["BuyerPostNo"]);   //구매자 우편번호
        lite.SetField(@"GoodsCl",Request.Params["GoodsCl"]);           //휴대폰 컨텐츠 구분            
        lite.SetField(@"TrKey",Request.Params["TrKey"]);               //인증key    
        lite.SetField(@"TransType",Request.Params["TransType"]);       //요청 타입(일반(0) 에스크로(1))
        lite.SetField(@"MallUserID",Request.Params["MallUserID"]);     //회원사 고객ID         
        lite.SetField(@"debug",@"true");                               //로그모드(실 서비스 "false" 로 설정)
        lite.SetField(@"Moid",string.Format("{0:yyyyMMddHHmmss}", DateTime.Now));  //가맹점 주문번호
        lite.DoPay();

        /****************************************************
        * <결제 결과 필드>
        * 아래 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능
        ****************************************************/
        ResultCode.Text    = lite.GetValue("ResultCode");               //결제결과코드 
        ResultMsg.Text     = lite.GetValue("ResultMsg");                //결제결과메시지
        AuthDate.Text      = lite.GetValue("AuthDate");                 //결제승인일시
        AuthCode.Text      = lite.GetValue("AuthCode");                 //결제승인번호
        BuyerName.Text     = lite.GetValue("BuyerName");                //구매자명
        GoodsName.Text     = lite.GetValue("GoodsName");                //결제상품명         
        MID.Text           = lite.GetValue("MID");                      //상점ID
        TID.Text           = lite.GetValue("TID");                      //거래ID
        Moid.Text          = lite.GetValue("Moid");                     //주문번호
        Amt.Text           = lite.GetValue("Amt");                      //결제금액
        PayMethod.Text     = lite.GetValue("PayMethod");                //결제지불수단
        CardCode.Text      = lite.GetValue("CardCode");                 //카드코드 
        CardName.Text      = lite.GetValue("CardName");                 //카드사명          
        CardNumber.Text    = lite.GetValue("CardNo");                   //카드번호
        AcquCardCode.Text  = lite.GetValue("AcquCardCode");             //카드매입사코드
        AcquCardName.Text  = lite.GetValue("AcquCardName");             //카드매입사명 
        CardQuota.Text     = lite.GetValue("CardQuota");                //카드할부개월
        BankCode.Text      = lite.GetValue("BankCode");                 //계좌이체은행코드 
        BankName.Text      = lite.GetValue("BankName");                 //계좌이체은행명 
        RcptType.Text      = lite.GetValue("RcptType");                 //현금영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
        RcptAuthCode.Text  = lite.GetValue("RcptAuthCode");             //현금영수증 승인 번호 
        Carrier.Text       = lite.GetValue("Carrier");                  //휴대폰이통사 구분 
        DstAddr.Text       = lite.GetValue("DstAddr");                  //휴대폰 번호 
        VbankBankCode.Text = lite.GetValue("VbankBankCode");            //가상계좌 은행코드 
        VbankName.Text     = lite.GetValue("VbankBankName");            //가상계좌 은행명
        VbankNum.Text      = lite.GetValue("VbankNum");                 //가상계좌 번호
        VbankExpDate.Text  = lite.GetValue("VbankExpDate");             //가상계좌 입금예정일       

        /****************************************************
        * <결제 성공 여부 확인>
        ****************************************************/
        bool paySuccess = false;
        if (PayMethod.Text.Equals("CARD")){
            if (ResultCode.Text.Equals("3001")) paySuccess = true;	    //신용카드(정상 결과코드:3001)  
            cardPanel.Visible = true;
        }else if (PayMethod.Text.Equals("BANK")){
            if (ResultCode.Text.Equals("4000")) paySuccess = true;	    //계좌이체(정상 결과코드:4000)  
            bankPanel.Visible = true;
        }else if (PayMethod.Text.Equals("CELLPHONE")){
            if (ResultCode.Text.Equals("A000")) paySuccess = true;	    //휴대폰(정상 결과코드:A000)  
            cellphonePanel.Visible = true;
        }else if (PayMethod.Text.Equals("VBANK")){
            if (ResultCode.Text.Equals("4100")) paySuccess = true;	    //가상계좌(정상 결과코드:4100)  
            vbankPanel.Visible = true;
        }
    }
}