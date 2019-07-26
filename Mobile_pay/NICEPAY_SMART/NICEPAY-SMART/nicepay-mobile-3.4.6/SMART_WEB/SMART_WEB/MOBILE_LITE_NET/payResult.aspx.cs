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
        authResultCode = Request.Params["AuthResultCode"];            // ������� : 0000(����)
        authResultMsg = Request.Params["AuthResultMsg"];              // ������� �޽���

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
        * <���� ��� ����>
        * ����� ��� �ɼ��� ����� ȯ�濡 �µ��� �����ϼ���.
        * �α� ���丮�� �� �����ϼ���.
        ****************************************************/
        NiceLite lite = new NiceLite(@"SECUREPAY");

        LogPath = @"C:\log"; //�α� ���丮   
        CancelPwd = @"123456";

        lite.SetField(@"LogPath",LogPath);                             //�α����� ����  
        lite.SetField(@"type",@"SECUREPAY");                           //Ÿ�Լ���(����)  
        lite.SetField(@"MID",Request.Params["MID"]);                   //���� ���̵�
        lite.SetField(@"Amt",Request.Params["Amt"]);                   //���ұݾ�
        lite.SetField(@"EncodeKey",Request.Params["MerchantKey"]);     //���� ���̼��� Ű(���� ���̵� ����)
        lite.SetField(@"CancelPwd",CancelPwd);                         //��� �н�����(���� ���������������� ����)
        lite.SetField(@"PayMethod",Request.Params["PayMethod"]);       //���Ҽ���
        lite.SetField(@"GoodsName",Request.Params["GoodsName"]);       //��ǰ��
        lite.SetField(@"GoodsCnt",Request.Params["GoodsCnt"]);         //��ǰ����   
        lite.SetField(@"BuyerName",Request.Params["BuyerName"]);       //������ ��
        lite.SetField(@"BuyerTel",Request.Params["BuyerTel"]);         //������ ����ó
        lite.SetField(@"BuyerEmail",Request.Params["BuyerEmail"]);     //������ �̸���         
        lite.SetField(@"ParentEmail",Request.Params["ParentEmail"]);   //��ȣ�� �̸���      
        lite.SetField(@"BuyerAddr",Request.Params["BuyerAddr"]);       //������ �ּ�
        lite.SetField(@"BuyerPostNo",Request.Params["BuyerPostNo"]);   //������ �����ȣ
        lite.SetField(@"GoodsCl",Request.Params["GoodsCl"]);           //�޴��� ������ ����            
        lite.SetField(@"TrKey",Request.Params["TrKey"]);               //����key    
        lite.SetField(@"TransType",Request.Params["TransType"]);       //��û Ÿ��(�Ϲ�(0) ����ũ��(1))
        lite.SetField(@"MallUserID",Request.Params["MallUserID"]);     //ȸ���� ��ID         
        lite.SetField(@"debug",@"true");                               //�α׸��(�� ���� "false" �� ����)
        lite.SetField(@"Moid",string.Format("{0:yyyyMMddHHmmss}", DateTime.Now));  //������ �ֹ���ȣ
        lite.DoPay();

        /****************************************************
        * <���� ��� �ʵ�>
        * �Ʒ� ���� ������ �ܿ��� ���� Header�� ������ ������ Get ����
        ****************************************************/
        ResultCode.Text    = lite.GetValue("ResultCode");               //��������ڵ� 
        ResultMsg.Text     = lite.GetValue("ResultMsg");                //��������޽���
        AuthDate.Text      = lite.GetValue("AuthDate");                 //���������Ͻ�
        AuthCode.Text      = lite.GetValue("AuthCode");                 //�������ι�ȣ
        BuyerName.Text     = lite.GetValue("BuyerName");                //�����ڸ�
        GoodsName.Text     = lite.GetValue("GoodsName");                //������ǰ��         
        MID.Text           = lite.GetValue("MID");                      //����ID
        TID.Text           = lite.GetValue("TID");                      //�ŷ�ID
        Moid.Text          = lite.GetValue("Moid");                     //�ֹ���ȣ
        Amt.Text           = lite.GetValue("Amt");                      //�����ݾ�
        PayMethod.Text     = lite.GetValue("PayMethod");                //�������Ҽ���
        CardCode.Text      = lite.GetValue("CardCode");                 //ī���ڵ� 
        CardName.Text      = lite.GetValue("CardName");                 //ī����          
        CardNumber.Text    = lite.GetValue("CardNo");                   //ī���ȣ
        AcquCardCode.Text  = lite.GetValue("AcquCardCode");             //ī����Ի��ڵ�
        AcquCardName.Text  = lite.GetValue("AcquCardName");             //ī����Ի�� 
        CardQuota.Text     = lite.GetValue("CardQuota");                //ī���Һΰ���
        BankCode.Text      = lite.GetValue("BankCode");                 //������ü�����ڵ� 
        BankName.Text      = lite.GetValue("BankName");                 //������ü����� 
        RcptType.Text      = lite.GetValue("RcptType");                 //���ݿ����� Ÿ�� (0:�����������,1:�ҵ����,2:��������)
        RcptAuthCode.Text  = lite.GetValue("RcptAuthCode");             //���ݿ����� ���� ��ȣ 
        Carrier.Text       = lite.GetValue("Carrier");                  //�޴�������� ���� 
        DstAddr.Text       = lite.GetValue("DstAddr");                  //�޴��� ��ȣ 
        VbankBankCode.Text = lite.GetValue("VbankBankCode");            //������� �����ڵ� 
        VbankName.Text     = lite.GetValue("VbankBankName");            //������� �����
        VbankNum.Text      = lite.GetValue("VbankNum");                 //������� ��ȣ
        VbankExpDate.Text  = lite.GetValue("VbankExpDate");             //������� �Աݿ�����       

        /****************************************************
        * <���� ���� ���� Ȯ��>
        ****************************************************/
        bool paySuccess = false;
        if (PayMethod.Text.Equals("CARD")){
            if (ResultCode.Text.Equals("3001")) paySuccess = true;	    //�ſ�ī��(���� ����ڵ�:3001)  
            cardPanel.Visible = true;
        }else if (PayMethod.Text.Equals("BANK")){
            if (ResultCode.Text.Equals("4000")) paySuccess = true;	    //������ü(���� ����ڵ�:4000)  
            bankPanel.Visible = true;
        }else if (PayMethod.Text.Equals("CELLPHONE")){
            if (ResultCode.Text.Equals("A000")) paySuccess = true;	    //�޴���(���� ����ڵ�:A000)  
            cellphonePanel.Visible = true;
        }else if (PayMethod.Text.Equals("VBANK")){
            if (ResultCode.Text.Equals("4100")) paySuccess = true;	    //�������(���� ����ڵ�:4100)  
            vbankPanel.Visible = true;
        }
    }
}